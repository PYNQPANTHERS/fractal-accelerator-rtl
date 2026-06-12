# Makefile
# General purpose icarus verilog runner.
# Usage:
#   make TB=tb/queues/tb_queues.sv        run a specific testbench
#   make all                               run every testbench found
#   make clean                             remove build artifacts
#
# The TB variable points to the testbench file relative to repo root.
# All HDL source files are automatically included from hdl/.
# Waveforms are written to sim/waves/<tb_name>.vcd


HDL_DIRS   := hdl/queues hdl/comparator hdl/memory hdl/arbiter 
TB_DIRS    := tb/memory
SIM_DIR    := sim/waves
BUILD_DIR  := sim/build
RENDER_DIR := sim/render

# Sources for control_unit testbenches (isolated — CU has declaration quirks)
_CU_WC_SRCS  := $(filter-out $(wildcard hdl/worker_core/tb_*.sv), \
                               $(wildcard hdl/worker_core/*.sv))
CU_HDL_SRCS  := $(wildcard hdl/control_unit/*.sv) \
                $(wildcard hdl/control_unit/cluster/*.sv) \
                $(_CU_WC_SRCS)

# Sources for engine/top testbenches (all subsystems except worker_core TB stubs)
_ENGINE_WC_SRCS  := $(filter-out $(wildcard hdl/worker_core/tb_*.sv), \
                                  $(wildcard hdl/worker_core/*.sv))
ENGINE_HDL_SRCS  := $(wildcard hdl/queues/*.sv) \
                    $(wildcard hdl/comparator/*.sv) \
                    $(wildcard hdl/scheduler/*.sv) \
                    $(wildcard hdl/memory/*.sv) \
                    $(wildcard hdl/control_unit/*.sv) \
                    $(wildcard hdl/control_unit/cluster/*.sv) \
                    $(_ENGINE_WC_SRCS) \
                    hdl/top/per_sixteenth_engine.sv

# Sources for top_level testbench (engine sources + controller + top)
TOP_HDL_SRCS     := $(ENGINE_HDL_SRCS) \
                    hdl/top/sixteenth_controller.sv \
                    hdl/top/top_level.sv

# Collect all HDL sources automatically
_TB_IN_HDL := $(foreach dir,$(HDL_DIRS),$(wildcard $(dir)/tb_*.sv))
HDL_SRCS   := $(filter-out $(_TB_IN_HDL),$(foreach dir,$(HDL_DIRS),$(wildcard $(dir)/*.sv)))

IVFLAGS := -g2012 -Wall -Wno-timescale

.PHONY: default
default:
	@if [ -z "$(TB)" ]; then \
		echo ""; \
		echo "  Usage: make TB=tb/queues/tb_queues.sv"; \
		echo "  Or:    make all"; \
		echo ""; \
	else \
		$(MAKE) run TB=$(TB); \
	fi

# Run a single testbench
.PHONY: run
run:
	mkdir -p $(SIM_DIR) $(BUILD_DIR)
	@if [ -z "$(TB)" ]; then echo "ERROR: TB not set"; exit 1; fi
	$(eval TB_NAME := $(basename $(notdir $(TB))))
	$(eval OUT     := $(BUILD_DIR)/$(TB_NAME).out)
	$(eval VCD     := $(SIM_DIR)/$(TB_NAME).vcd)
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Compiling: $(TB)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	iverilog $(IVFLAGS) -o $(OUT) $(HDL_SRCS) $(TB)
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Running:   $(TB_NAME)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	vvp $(OUT)
	@echo ""
	@echo "  Waveform: $(VCD)"
	@echo ""

# Run all testbenches found in tb/
ALL_TBS := $(foreach dir,$(TB_DIRS),$(wildcard $(dir)/tb_*.sv))

.PHONY: all
all: $(SIM_DIR) $(BUILD_DIR)
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Running all testbenches"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@PASS=0; FAIL=0; \
	for tb in $(ALL_TBS); do \
		TB_NAME=$$(basename $$tb .sv); \
		OUT=$(BUILD_DIR)/$$TB_NAME.out; \
		iverilog $(IVFLAGS) -o $$OUT $(HDL_SRCS) $$tb 2>&1; \
		if [ $$? -ne 0 ]; then \
			echo "  [COMPILE FAIL] $$tb"; \
			FAIL=$$((FAIL+1)); \
		else \
			RESULT=$$(vvp $$OUT); \
			echo "$$RESULT"; \
			if echo "$$RESULT" | grep -q "ALL TESTS PASSED"; then \
				PASS=$$((PASS+1)); \
			else \
				FAIL=$$((FAIL+1)); \
			fi; \
		fi; \
	done; \
	echo ""; \
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; \
	echo "  FINAL: $$PASS testbench(es) passed, $$FAIL failed"; \
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; \
	echo ""

$(SIM_DIR):
	mkdir -p $(SIM_DIR)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Render three fractal frames through control_unit → CSVs
.PHONY: cu-debug
cu-debug:
	mkdir -p $(SIM_DIR) $(BUILD_DIR)
	$(eval TB_NAME := tb_cu_debug)
	$(eval OUT     := $(BUILD_DIR)/$(TB_NAME).out)
	iverilog $(IVFLAGS) -o $(OUT) $(CU_HDL_SRCS) tb/control_unit/$(TB_NAME).sv
	vvp $(OUT) 2>&1 | head -300

.PHONY: cu-single
cu-single:
	mkdir -p $(SIM_DIR) $(BUILD_DIR)
	$(eval TB_NAME := tb_cu_single)
	$(eval OUT     := $(BUILD_DIR)/$(TB_NAME).out)
	iverilog $(IVFLAGS) -o $(OUT) $(CU_HDL_SRCS) tb/control_unit/$(TB_NAME).sv
	vvp $(OUT)

.PHONY: cu-render
cu-render:
	mkdir -p $(SIM_DIR) $(BUILD_DIR)
	$(eval TB_NAME := tb_cu_render)
	$(eval OUT     := $(BUILD_DIR)/$(TB_NAME).out)
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Compiling: tb/control_unit/$(TB_NAME).sv"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	iverilog $(IVFLAGS) -o $(OUT) $(CU_HDL_SRCS) tb/control_unit/$(TB_NAME).sv
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Running:   $(TB_NAME)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	vvp $(OUT)
	@echo ""

# Level-1: per_sixteenth_engine, one sixteenth, all real sub-modules
.PHONY: pse
pse:
	mkdir -p $(SIM_DIR) $(BUILD_DIR) $(RENDER_DIR)
	$(eval TB_NAME := tb_per_sixteenth_engine)
	$(eval OUT     := $(BUILD_DIR)/$(TB_NAME).out)
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Compiling: tb/top/$(TB_NAME).sv"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	iverilog $(IVFLAGS) -o $(OUT) $(ENGINE_HDL_SRCS) tb/top/$(TB_NAME).sv
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Running:   $(TB_NAME)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	vvp $(OUT)
	@echo ""
	@echo "  Outputs: $(RENDER_DIR)/pse_bram.csv"
	@echo "           $(RENDER_DIR)/pse_dram.csv"
	@echo "           $(RENDER_DIR)/pse_image.csv"
	@echo ""

# Level-1b: per_sixteenth_engine, single run, top-full config, dumps CSV on sixteenth_complete
.PHONY: pse-single
pse-single:
	mkdir -p $(SIM_DIR) $(BUILD_DIR) $(RENDER_DIR)
	$(eval TB_NAME := tb_pse_single)
	$(eval OUT     := $(BUILD_DIR)/$(TB_NAME).out)
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Compiling: tb/top/$(TB_NAME).sv"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	iverilog $(IVFLAGS) -o $(OUT) $(ENGINE_HDL_SRCS) tb/top/$(TB_NAME).sv
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Running:   $(TB_NAME)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	vvp $(OUT)
	@echo ""
	@echo "  Outputs: $(RENDER_DIR)/single_bram.csv"
	@echo "           $(RENDER_DIR)/single_dram.csv"
	@echo "           $(RENDER_DIR)/single_image.csv"
	@echo ""

# Level-2: per_sixteenth_engine, two sixteenths, cross-run checks
.PHONY: engine-full
engine-full:
	mkdir -p $(SIM_DIR) $(BUILD_DIR) $(RENDER_DIR)
	$(eval TB_NAME := tb_engine_full)
	$(eval OUT     := $(BUILD_DIR)/$(TB_NAME).out)
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Compiling: tb/top/$(TB_NAME).sv"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	iverilog $(IVFLAGS) -o $(OUT) $(ENGINE_HDL_SRCS) tb/top/$(TB_NAME).sv
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Running:   $(TB_NAME)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	vvp $(OUT)
	@echo ""
	@echo "  Outputs: $(RENDER_DIR)/engine_sixteenth_0_bram.csv"
	@echo "           $(RENDER_DIR)/engine_sixteenth_0_dram.csv"
	@echo "           $(RENDER_DIR)/engine_sixteenth_0_image.csv"
	@echo "           $(RENDER_DIR)/engine_sixteenth_5_{bram,dram,image}.csv"
	@echo "           $(RENDER_DIR)/engine_full_{bram,dram}.csv"
	@echo ""

# Level-3: full top_level, all 16 sixteenths, PS input injection
.PHONY: top-full
top-full:
	mkdir -p $(SIM_DIR) $(BUILD_DIR) $(RENDER_DIR)
	$(eval TB_NAME := tb_top_level)
	$(eval OUT     := $(BUILD_DIR)/$(TB_NAME).out)
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Compiling: tb/top/$(TB_NAME).sv"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	iverilog $(IVFLAGS) -o $(OUT) $(TOP_HDL_SRCS) tb/top/$(TB_NAME).sv
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Running:   $(TB_NAME)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	vvp $(OUT)
	@echo ""
	@echo "  Outputs: $(RENDER_DIR)/top_sixteenth_N_{bram,image}.csv  (N=0..15)"
	@echo "           $(RENDER_DIR)/top_dram.csv"
	@echo "           $(RENDER_DIR)/top_full_image.csv"
	@echo ""

# Tile-size benchmark: renders the full image on TILE_W=16 then TILE_W=8 and
# reports core-utilisation / scheduler-occupancy metrics for the report.
.PHONY: tile-bench
tile-bench:
	mkdir -p $(SIM_DIR) $(BUILD_DIR) $(RENDER_DIR)
	$(eval TB_NAME := tb_tile_benchmark)
	$(eval OUT     := $(BUILD_DIR)/$(TB_NAME).out)
	@echo ""
	@echo "  Compiling: tb/top/$(TB_NAME).sv  (TILE_W=16 + TILE_W=8 DUTs)"
	iverilog $(IVFLAGS) -o $(OUT) $(TOP_HDL_SRCS) tb/top/$(TB_NAME).sv
	@echo "  Running:   $(TB_NAME)"
	vvp $(OUT)
	@echo ""
	@echo "  Rendering PNGs..."
	-cd $(RENDER_DIR) && python3 visualise.py bench_tile16_image.csv
	-cd $(RENDER_DIR) && python3 visualise.py bench_tile8_image.csv
	@echo "  Outputs: $(RENDER_DIR)/bench_tile{8,16}_{dram,image}.csv (+ .png)"
	@echo ""

# BRAM→DRAM CSV render validation: loads fractal CSV, drives bram_to_dram, checks pixel fidelity
.PHONY: b2d-csv
b2d-csv:
	mkdir -p $(SIM_DIR) $(BUILD_DIR) $(RENDER_DIR)
	$(eval TB_NAME := tb_bram_to_dram_csv)
	$(eval OUT     := $(BUILD_DIR)/$(TB_NAME).out)
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Compiling: tb/memory/$(TB_NAME).sv"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	iverilog $(IVFLAGS) -o $(OUT) $(HDL_SRCS) tb/memory/$(TB_NAME).sv
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Running:   $(TB_NAME)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	vvp $(OUT)
	@echo ""
	@echo "  Outputs: $(RENDER_DIR)/b2d_bram_source.csv"
	@echo "           $(RENDER_DIR)/b2d_partial_dram.csv"
	@echo "           $(RENDER_DIR)/b2d_full_dram.csv"
	@echo ""

# Clean
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) $(SIM_DIR)
	find $(RENDER_DIR) -type f ! -name '*.py' ! -name 'bench_metrics.csv' ! -name 'bench_tile*.png' -delete 2>/dev/null || true
	@echo "Cleaned build, wave, and render outputs (kept .py scripts + benchmark report/PNGs)"