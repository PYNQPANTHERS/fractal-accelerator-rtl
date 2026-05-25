# fractal-accelerator-rtl
 
Verilog HDL and testbenches for the fractal accelerator PL fabric. Targets the Zynq-7020 on the Pynq-Z1.
 
## What this is
 
A general-purpose escape-time fractal renderer implemented entirely in programmable logic. Supports any fractal expressible as a complex polynomial iteration (Mandelbrot, Julia, Burning Ship, etc.) via a microprogram written by the PS at render start. Once started, the PL requires no software involvement until the render is complete.
 
The architecture centres on a pool of parallel iterator cores running a shared job queue, coordinated by a quad-tree scheduler implementing the Mariani-Silver algorithm. A 1024×1024 image is rendered as four sequential 512×512 quarters, each living entirely in BRAM during computation.
 
## Repo layout
 
```
hdl/
  iterator/       core pipeline, Karatsuba multiplier, microprogram execution
  scheduler/      quad tree FSM, stack manager, border pixel ordering
  comparator/     complete queue drain, bounds check, differ/complete flags
  arbiter/        BRAM read/write arbitration across 28 cores
  queues/         job queue, complete queue, FIFO primitives
  top/            top-level integration, AXI port wiring, quarter control FSM
 
tb/
  iterator/       per-opcode unit tests, Karatsuba correctness, escape detection
  scheduler/      split/floodfill sequences, stack push/pop, backtrack logic
  comparator/     bounds check, stale result rejection, flag timing
  arbiter/        simultaneous request collision, priority enforcement
  integration/    full quarter render sim, known-pixel verification
 
sim/              waveform dumps, regression scripts, Makefile
```
 
## Running simulations
 
```bash
cd sim
# add as we go along
```
 
Requires Icarus Verilog or Verilator. See `sim/Makefile` for tool flags.

## RTL does not contain
 
- Vivado project files or block designs → see `fractal-accelerator-vivado`
- PS driver, server, or frontend code → see `fractal-accelerator-sw`