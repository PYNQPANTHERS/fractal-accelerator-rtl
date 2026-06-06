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

# Sources for full-engine testbench (all subsystems except broken iterator stubs)
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

# Full-engine render: per_sixteenth_engine with all real subsystems
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
	@echo "  Outputs: $(RENDER_DIR)/engine_full_dram.csv"
	@echo "           $(RENDER_DIR)/engine_full_bram.csv"
	@echo "           $(RENDER_DIR)/engine_full_image.csv"
	@echo ""

# Clean
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) $(SIM_DIR) $(RENDER_DIR)
	@echo "Cleaned build, wave, and render outputs"