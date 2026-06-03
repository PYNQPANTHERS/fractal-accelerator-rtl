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


HDL_DIRS   := hdl/queues hdl/comparator hdl/worker_core #hdl/iterator hdl/scheduler hdl/comparator hdl/arbiter hdl/top
TB_DIRS    := tb/queues tb/iterator tb/scheduler tb/comparator tb/arbiter tb/integration
SIM_DIR    := sim/waves
BUILD_DIR  := sim/build

# Collect all HDL sources automatically
HDL_SRCS := $(foreach dir,$(HDL_DIRS),$(wildcard $(dir)/*.sv))
HDL_SRCS := $(filter-out hdl/worker_core/core_top.sv,$(HDL_SRCS))

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
	vvp $(OUT) +vcd=$(VCD)
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

# ── control_unit render testbench ──────────────────────────────────────────────
CU_SRCS := \
	hdl/control_unit/control_unit.sv \
	hdl/control_unit/frame_fsm.sv \
	hdl/control_unit/bram_read_write.sv \
	hdl/control_unit/sequencer.sv \
	hdl/control_unit/cluster_arbiter.sv \
	hdl/control_unit/job_datapath.sv \
	hdl/control_unit/translate.sv \
	hdl/control_unit/cluster/cluster.sv \
	hdl/control_unit/cluster/priority_encoder.sv \
	hdl/control_unit/cluster/sync_fifo.sv \
	hdl/worker_core/core_top.sv \
	hdl/worker_core/multiply_manager.sv \
	hdl/worker_core/multiply.sv \
	hdl/worker_core/coord_flagger.sv \
	hdl/worker_core/max_iteration_flagger.sv \
	hdl/worker_core/magnitude_comparison_unit.sv \
	hdl/worker_core/sum_alter.sv

.PHONY: cu
cu:
	mkdir -p $(BUILD_DIR) sim/render
	iverilog $(IVFLAGS) -o $(BUILD_DIR)/tb_control_unit.out \
		$(CU_SRCS) hdl/control_unit/tb_control_unit.sv
	vvp $(BUILD_DIR)/tb_control_unit.out
	@echo ""
	@echo "  Render: python3 hdl/worker_core/render.py --csv sim/render/frame.csv --max-iter 128 --out sim/render/frame.png"

# Clean
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) $(SIM_DIR)
	@echo "Cleaned build and wave outputs"