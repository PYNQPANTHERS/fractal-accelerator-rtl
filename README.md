<div align="center">

# PYNQZOOM

### A fractal accelerator in hardware

</div>

---

## Overview

A general-purpose escape-time fractal renderer implemented entirely in programmable logic. The PS configures a render over AXI-Lite and raises a start pulse; from that point the PL runs to completion with no software involvement, writing the finished frame to DDR over AXI-HP.

The architecture centres on a pool of parallel iterator cores organised into clusters, coordinated by a hardware implementation of the Mariani-Silver quad-tree algorithm. Rather than dispatching every pixel unconditionally, the scheduler tests box borders and flood-fills uniform regions, only queuing individual pixels where the boundary is non-uniform. A 1024×1024 frame is rendered as 16 sequential 256×256 sixteenths, each held in on-chip BRAM during computation and streamed to DDR by a dedicated AXI-HP writeback unit once complete.

Each core supports two runtime-selectable precision modes without additional hardware: a narrow mode that runs two independent pixel lanes in parallel using the native DSP multiply width, and a wide mode that groups the same DSP slices across multiple cycles via partial-product accumulation to achieve double the arithmetic precision for deep zooms. Fractal variant and Julia mode are controlled by a per-render opcode, enabling a large family of fractal forms to be rendered without RTL changes.

---

## Two designs

The RTL is maintained as two parallel, self-contained trees under `hdl/`:

| Tree | Engines | Precision | Top module |
| :--- | :--- | :--- | :--- |
| `hdl/dual_core/` | **2** -- even/odd sixteenths in parallel, merged by an internal `axi_wr_arbiter` | Narrow | `top_level` |
| `hdl/dual_precision/` | **1** | Narrow **+ wide** -- zoom-selected at runtime | `top_level` |

`dual_core` contains a pool of narrow-width cores optimised for minimal per-core resource usage, allowing the maximum number of cores to be placed on the fabric. `dual_precision` trades core count for wide-mode capability: each core carries the additional logic needed for partial-product accumulation, which increases per-core LUT usage and reduces the total number of cores that can be instantiated.

Both `top_level`s expose the same external ports (`cfg_*` config inputs, `hp_axi_wr_*` write port, irqs), so a single Vivado block design drives either without modification. The AXI wrappers are instantiated in the block design, not in RTL.

Each tree is fully self-contained, with its own copy of every submodule.

---

## Repository structure

```text
hdl/<design>/
  top/              Top-level control and frame sequencing
                    (top_level, sixteenth_controller, per_sixteenth_engine)
  control_unit/     Job dispatch, result collection, and cluster arbitration
                    (control_unit, dispatch, bram_read_write, translate, cluster/)
  scheduler/        Mariani-Silver quad-tree FSM and border pixel generation
                    (scheduler, border_pixel_chooser, scheduler_stack)
  comparator/       Border uniformity detection and stale-pixel filtering
                    (comparator, bounds check, differ/complete flags)
  worker_core/      Parallel iterator cores and fixed-point arithmetic pipeline
                    (core_top, multiply_manager, multiply, helpers)
  memory/           On-chip frame buffer, scheduler state, tile metadata, and AXI-HP writeback
                    (colour_bram, state_bram, tile_table, bram_to_dram)
  queues/           Decoupled producer/consumer FIFOs for job and completion paths
                    (job_queue(_handler), complete_queue(_handler), fifo, sync_fifo)
  axi/              PS-PL configuration and bulk tile writeback interfaces
                    (axi_lite_slave, axi_hp_master_wrap)

tb/                 Unit and integration testbenches, shared across both design trees
sim/                Simulation artefacts: compiled binaries, VCD waveforms,
                    per-transaction CSVs and visualise.py PNG reconstruction
```

---

## Building & running

Everything is parameterised by `DESIGN=dual_core|dual_precision` (default
`dual_core`). The only thing that changes between builds is which `hdl/<DESIGN>/`
tree the sources come from.

```bash
# full 1024x1024 image
make full   DESIGN=dual_core          # 2 engines
make full   DESIGN=dual_precision      # 1 engine

# one 256x256 sixteenth
make single DESIGN=dual_core
make single DESIGN=dual_precision

# compile only (e.g. to launch many runs in parallel)
make full-build  DESIGN=...
make single-build DESIGN=...
```

Optional render config via make vars (passed as plusargs):
`CENTRE_X CENTRE_Y ZOOM MAX_I FTYPE JULIA_RE JULIA_IM TAG`. Example:

```bash
make full DESIGN=dual_precision ZOOM=20 MAX_I=3 TAG=seahorse
```

The testbenches reconstruct the image from the colour-BRAM write stream (via
hierarchical references (no AXI in the loop; `hp_axi_wr_ready` is held high) and
dump CSVs to `sim/render/`. Render them to PNG:

```bash
cd sim/render && python3 visualise.py            # all CSVs
                 python3 visualise.py <file>.csv  # one
```

> Requires Icarus Verilog (`iverilog`/`vvp`) and Python + Pillow for visualise.

---

## Testbenches

Unit and integration testbenches live in `tb/` and run against either tree:

```bash
make test     TB=tb/scheduler/tb_scheduler.sv DESIGN=dual_precision
make test-all DESIGN=dual_core                 # build+run every tb/**/tb_*.sv
```

---

## RTL does not contain

- PS driver, server, or frontend code → see `fractal-accelerator-sw`
