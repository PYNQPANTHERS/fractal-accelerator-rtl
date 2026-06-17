# fractal-accelerator-rtl

Verilog/SystemVerilog HDL and testbenches for the fractal accelerator PL fabric.
Targets the Zynq-7020 on the PYNQ-Z1.

## What this is

A general-purpose escape-time fractal renderer implemented entirely in
programmable logic. Supports fractals expressible as a complex polynomial
iteration (Mandelbrot, Julia, …) configured by the PS at render start; once
started, the PL runs to completion with no software involvement.

The architecture centres on a pool of parallel iterator cores (organised into
clusters) sharing a job queue, coordinated by a quad-tree scheduler implementing
the Mariani–Silver algorithm. A 1024×1024 image is rendered as 16 sequential
256×256 "sixteenths", each living in BRAM during computation and streamed to
DRAM over an AXI-HP write port.

## Two designs

The RTL is maintained as two parallel, self-contained trees under `hdl/`:

| Tree | Engines | Precision | Top module |
|------|---------|-----------|------------|
| `hdl/dual_core/` | **2** (even/odd sixteenths in parallel, merged by an internal `axi_wr_arbiter`) | narrow | `top_level` |
| `hdl/dual_precision/` | **1** | narrow **+ wide** (zoom-selected: `zoom_level > 165` → wide) | `top_level` |

Both `top_level`s expose the **same external ports** (`cfg_*` config inputs +
`hp_axi_wr_*` write port + irqs), so a single Vivado block design
(`axi_lite_slave` → `cfg_*`, `hp_axi_wr_*` → `axi_hp_master_wrap`) drives either.
The wrappers themselves are instantiated in the block design, not in RTL.

Each tree contains its own copy of every submodule:

```
hdl/<design>/
  top/            top_level, sixteenth_controller, per_sixteenth_engine
  control_unit/   control_unit, dispatch, bram_read_write, translate, cluster/
  scheduler/      quad-tree FSM, border_pixel_generator, scheduler_stack
  comparator/     bounds check, differ/complete flags
  worker_core/    iterator cores, multiply/multiply_manager (+ core_top, helpers)
  memory/         colour_bram, state_bram, tile_table, bram_to_dram
  queues/         job_queue(_handler), complete_queue(_handler), fifo, sync_fifo
  axi/            axi_lite_slave, axi_hp_master_wrap

tb/               testbenches (shared across both trees)
sim/              build/, waves/, render/ (CSV + visualise.py)
```

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
hierarchical references — no AXI in the loop; `hp_axi_wr_ready` is held high) and
dump CSVs to `sim/render/`. Render them to PNG:

```bash
cd sim/render && python3 visualise.py            # all CSVs
                 python3 visualise.py <file>.csv  # one
```

Requires Icarus Verilog (`iverilog`/`vvp`) and Python + Pillow for visualise.

## Testbenches

Unit and integration testbenches live in `tb/` and run against either tree:

```bash
make test     TB=tb/scheduler/tb_scheduler.sv DESIGN=dual_precision
make test-all DESIGN=dual_core                 # build+run every tb/**/tb_*.sv
```

Each TB compiles against the whole selected tree (unused modules are dropped), so
one TB serves both designs. See **[tb/TEST_COVERAGE.md](tb/TEST_COVERAGE.md)** for
the current pass/fail status, what each functional test verifies, and the modules
that still need dedicated unit tests.

## RTL does not contain

- PS driver, server, or frontend code → see `fractal-accelerator-sw`
