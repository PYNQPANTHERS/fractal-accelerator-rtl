# Makefile — parameterized over the two designs.
#
#   make full   DESIGN=dual_core        full 1024x1024 image, 2 engines
#   make full   DESIGN=dual_precision    full 1024x1024 image, 1 engine (narrow+wide)
#   make single DESIGN=dual_core         one 256x256 sixteenth (per_sixteenth_engine)
#   make single DESIGN=dual_precision    one 256x256 sixteenth
#
# DESIGN selects which hdl/<DESIGN>/ tree the RTL comes from — that is the ONLY
# thing that changes between builds. DESIGN defaults to dual_core.
#
# Optional render config (plusargs) for `full` / `single`:
#   CENTRE_X / CENTRE_Y : 35-bit hex Q2.33
#   ZOOM MAX_I FTYPE    : integers
#   JULIA_RE / JULIA_IM : 35-bit hex julia c
#   TAG                 : output filename prefix (default: the target name)

DESIGN     ?= dual_core
DESIGN_DIR := hdl/$(DESIGN)

SIM_DIR    := sim/waves
BUILD_DIR  := sim/build
RENDER_DIR := sim/render
IVFLAGS    := -g2012 -Wall -Wno-timescale

# dual_core has two engines → compile the shared TB with -D DUAL so it probes
# engine B. dual_precision has a single engine and omits it.
ifeq ($(DESIGN),dual_core)
DESIGN_DEFS := -D DUAL
else
DESIGN_DEFS :=
endif

# ── Source collection ──────────────────────────────────────────────────────────
# Every .sv under the selected design tree, minus any testbench files (tb_*.sv).
# Each tree is self-contained (its own worker_core), so no cross-tree swapping.
_ALL_SV    := $(shell find $(DESIGN_DIR) -name '*.sv')
_TB_SV     := $(shell find $(DESIGN_DIR) -name 'tb_*.sv')
HDL_SRCS   := $(filter-out $(_TB_SV),$(_ALL_SV))

# Testbenches (shared across both designs)
TB_FULL    := tb/top/tb_full.sv
TB_SINGLE  := tb/top/tb_pse_single.sv

# Plusargs assembled from optional make vars
PLUSARGS = $(if $(CENTRE_X),+centre_x=$(CENTRE_X)) \
           $(if $(CENTRE_Y),+centre_y=$(CENTRE_Y)) \
           $(if $(ZOOM),+zoom=$(ZOOM)) \
           $(if $(MAX_I),+max_i=$(MAX_I)) \
           $(if $(FTYPE),+ftype=$(FTYPE)) \
           $(if $(JULIA_RE),+julia_re=$(JULIA_RE)) \
           $(if $(JULIA_IM),+julia_im=$(JULIA_IM)) \
           $(if $(TAG),+tag=$(TAG))

# ── Targets ─────────────────────────────────────────────────────────────────────
.PHONY: default
default:
	@echo ""
	@echo "  make full   DESIGN=dual_core|dual_precision   — full image"
	@echo "  make single DESIGN=dual_core|dual_precision   — one sixteenth"
	@echo "  (DESIGN defaults to dual_core)"
	@echo ""

.PHONY: full
full:
	@mkdir -p $(SIM_DIR) $(BUILD_DIR) $(RENDER_DIR)
	$(eval OUT := $(BUILD_DIR)/$(DESIGN)_full.out)
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Compiling: $(TB_FULL)   [DESIGN=$(DESIGN)]"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	iverilog $(IVFLAGS) $(DESIGN_DEFS) -o $(OUT) $(HDL_SRCS) $(TB_FULL)
	@echo ""
	@echo "  Running:   $(DESIGN) full image"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	vvp $(OUT) $(PLUSARGS)
	@echo ""
	@echo "  Outputs: $(RENDER_DIR)/<tag>_full_image.csv  (+ per-sixteenth bram CSVs)"
	@echo ""

.PHONY: single
single:
	@mkdir -p $(SIM_DIR) $(BUILD_DIR) $(RENDER_DIR)
	$(eval OUT := $(BUILD_DIR)/$(DESIGN)_single.out)
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Compiling: $(TB_SINGLE)   [DESIGN=$(DESIGN)]"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	iverilog $(IVFLAGS) $(DESIGN_DEFS) -o $(OUT) $(HDL_SRCS) $(TB_SINGLE)
	@echo ""
	@echo "  Running:   $(DESIGN) single sixteenth"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	vvp $(OUT) $(PLUSARGS)
	@echo ""
	@echo "  Outputs: $(RENDER_DIR)/single_*.csv"
	@echo ""

# Build-only variants (compile, no run) for launching many runs in parallel.
.PHONY: full-build single-build
full-build:
	@mkdir -p $(BUILD_DIR) $(RENDER_DIR)
	iverilog $(IVFLAGS) $(DESIGN_DEFS) -o $(BUILD_DIR)/$(DESIGN)_full.out $(HDL_SRCS) $(TB_FULL)
	@echo "  Built $(BUILD_DIR)/$(DESIGN)_full.out"
single-build:
	@mkdir -p $(BUILD_DIR) $(RENDER_DIR)
	iverilog $(IVFLAGS) $(DESIGN_DEFS) -o $(BUILD_DIR)/$(DESIGN)_single.out $(HDL_SRCS) $(TB_SINGLE)
	@echo "  Built $(BUILD_DIR)/$(DESIGN)_single.out"

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) $(SIM_DIR)
	find $(RENDER_DIR) -type f ! -name '*.py' -delete 2>/dev/null || true
	@echo "Cleaned build, wave, and render outputs (kept .py scripts)"
