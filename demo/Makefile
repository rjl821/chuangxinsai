# ==============================================================================
# VCS / Verdi / DVE / SpyGlass / Design Compiler common entry
# [REPLACE] When adapting the demo, edit this user configuration section and
# the filelist directory. Source filenames belong in filelist files, never here.
# ==============================================================================

export LC_ALL := C
export LANG := C
export LANGUAGE :=

SHELL := /bin/bash
ROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
export DEMO_ROOT := $(ROOT_DIR)

# ==============================================================================
# User configuration: design and simulation
# ==============================================================================
DUT_TOP := vector_mac
TB_MODE ?= uvm

SV_TB_TOP       := tb_vector_mac
UVM_TB_TOP      := dut_tb
SYN_FILELIST    := $(ROOT_DIR)/filelist/rtl.f
SV_SIM_FILELIST := $(ROOT_DIR)/filelist/sv.f
UVM_FILELIST    := $(ROOT_DIR)/filelist/uvm.f

SEED ?= 2026
UVM_VERBOSITY ?= UVM_LOW

ifeq ($(TB_MODE),sv)
TB_TOP       := $(SV_TB_TOP)
SIM_FILELIST := $(SV_SIM_FILELIST)
TEST_NAME    ?= sv_smoke_test
UVM_COMPILE_OPTS :=
TEST_OPTS := +TEST_NAME=$(TEST_NAME)
else ifeq ($(TB_MODE),uvm)
TB_TOP       := $(UVM_TB_TOP)
SIM_FILELIST := $(UVM_FILELIST)
TEST_NAME    ?= vector_mac_smoke_test
UVM_COMPILE_OPTS := -ntb_opts uvm-1.2
TEST_OPTS := +UVM_TESTNAME=$(TEST_NAME) +UVM_VERBOSITY=$(UVM_VERBOSITY)
else
$(error TB_MODE must be sv or uvm, got '$(TB_MODE)')
endif

# Simulation and synthesis use the same clock period, in ns.
CLOCK_PERIOD_NS := 10.0

# ==============================================================================
# User configuration: DC constraints
# ==============================================================================
CLOCK_NAME           := core_clk
CLOCK_PORT           := clk
ASYNC_RESET_PORT     := rst_n
NO_INPUT_DELAY_PORTS := clk rst_n

INPUT_DELAY_RATIO       := 0.20
OUTPUT_DELAY_RATIO      := 0.20
SETUP_UNCERTAINTY_RATIO := 0.05
HOLD_UNCERTAINTY_NS     := 0.0
OUTPUT_LOAD_PF          := 0.02
MAX_TRANSITION_RATIO    := 0.10

# TSMC 28 nm HPC+, TT / 0.8 V / 25 C, complete NLDM standard-cell library.
TECH_LIB := /home/jjt/TSMC28/logic/tcbn28hpcplusbwp12t40p140_180a/AN61001_20180514/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp12t40p140_180a/tcbn28hpcplusbwp12t40p140tt0p8v25c.db
INPUT_DRIVE_CELL := INVD1BWP12T40P140
EXTRA_LINK_LIBS :=

SPYGLASS_GOAL ?= lint/lint_rtl

# ==============================================================================
# Fixed flow: normally no changes are needed below this line
# ==============================================================================
BUILD_DIR ?= $(ROOT_DIR)/build
MODE_BUILD := $(BUILD_DIR)/vcs/$(TB_MODE)
LOG_DIR    := $(MODE_BUILD)/log
OBJ_DIR    := $(MODE_BUILD)/obj
SIM_DIR    := $(MODE_BUILD)/sim
COV_ROOT   := $(MODE_BUILD)/cov
COV_GUI_DIR := $(MODE_BUILD)/cov_gui
SIMV       := $(OBJ_DIR)/simv
LINT_DIR   := $(BUILD_DIR)/spyglass
LINT_PROJECT := $(LINT_DIR)/$(DUT_TOP).prj

CM_TYPES := line+cond+fsm+tgl+branch+assert
CM_NAME  := $(TEST_NAME)_$(SEED)
CM_DIR   := $(COV_ROOT)/$(CM_NAME).vdb
#FSDB     := $(SIM_DIR)/$(CM_NAME).fsdb
FSDB     := $(SIM_DIR)/DUT.fsdb

COMPILE_CM_DIR := $(OBJ_DIR)/compile.vdb
MERGED_CM_DIR  ?= $(COV_ROOT)/merged.vdb
# URG interprets the final path component as the database name. Repeating
# "merged" creates the desired $(COV_ROOT)/merged.vdb output.
MERGED_DBNAME := $(COV_ROOT)/merged/merged
COV_INPUTS ?= $(filter-out $(MERGED_CM_DIR),$(wildcard $(COV_ROOT)/*.vdb))
COV_REPORT ?= $(MODE_BUILD)/coverage_report

# Resolve Verdi from the caller's PATH; no installation path is hard-coded.
VERDI_BIN := $(shell command -v verdi 2>/dev/null)
VCS_PLI_DIR := $(abspath $(dir $(VERDI_BIN))/../share/PLI/VCS/linux64)
PLI_OPTS := -P $(VCS_PLI_DIR)/novas.tab $(VCS_PLI_DIR)/pli.a

VLOGAN_OPTS := -full64 -sverilog -timescale=1ns/1ps -kdb \
	-debug_access+all -nc $(UVM_COMPILE_OPTS)
ELAB_OPTS := -full64 $(UVM_COMPILE_OPTS) -kdb -debug_access+all \
	-sim_res=1ps -Mdir=$(OBJ_DIR)/csrc $(PLI_OPTS) \
	-cm $(CM_TYPES) -cm_dir $(COMPILE_CM_DIR)
COV_RUN_OPTS := -cm $(CM_TYPES) -cm_dir $(CM_DIR) -cm_name $(CM_NAME) \
	-covg_cont_on_error
RUN_OPTS := +ntb_random_seed=$(SEED) $(TEST_OPTS) \
	+CLOCK_PERIOD_NS=$(CLOCK_PERIOD_NS) +FSDB=$(FSDB) \
	$(COV_RUN_OPTS) -l $(SIM_DIR)/$(CM_NAME).log
DVE_RUN_OPTS := $(RUN_OPTS) -gui=dve

.PHONY: help prepare comp elab run sim sim_sv sim_uvm verdi dve \
		lint lint_gui dc all cov_merge mergecov dvecov verdicov clean

help:
	@echo "make sim [TB_MODE=sv|uvm] [TEST_NAME=name] [SEED=n]"
	@echo "                    : compile, elaborate, run, and save FSDB/VDB"
	@echo "make run ...        : reuse the existing simv for another test/seed"
	@echo "make sim_sv ...     : shorthand for TB_MODE=sv"
	@echo "make sim_uvm ...    : shorthand for TB_MODE=uvm (UVM 1.2)"
	@echo "make verdi ...      : run the selected test, then open Verdi from filelist"
	@echo "make dve ...        : elaborate and start the live DVE simulation GUI"
	@echo "make cov_merge ...  : manually merge selected mode's coverage databases"
	@echo "make dvecov         : inspect merged coverage in DVE"
	@echo "make verdicov       : inspect merged coverage in Verdi"
	@echo "make lint           : SpyGlass reads the synthesis filelist"
	@echo "make lint_gui       : open the latest SpyGlass lint project and results"
	@echo "make dc             : DC reads the synthesis filelist and runs synthesis"
	@echo "make all            : run sim, lint, and dc"
	@echo "make clean          : delete this project's build directory"

prepare:
	@mkdir -p $(LOG_DIR) $(OBJ_DIR) $(SIM_DIR) $(COV_ROOT) $(COV_GUI_DIR)
	@mkdir -p $(LINT_DIR)
	@mkdir -p $(BUILD_DIR)/dc/reports $(BUILD_DIR)/dc/outputs $(BUILD_DIR)/dc/work

comp: prepare
ifeq ($(TB_MODE),uvm)
	# VCS T-2022.06 first builds the bundled UVM 1.2 package.
	@cd $(OBJ_DIR) && vlogan $(VLOGAN_OPTS) -l $(LOG_DIR)/uvm_compile.log
endif
	# -F reads every source and include path from the selected filelist.
	@cd $(OBJ_DIR) && vlogan $(VLOGAN_OPTS) -F $(SIM_FILELIST) \
		-l $(LOG_DIR)/compile.log 

elab: comp
	@cd $(OBJ_DIR) && vcs $(ELAB_OPTS) -top $(TB_TOP) -o $(SIMV) \
		-l $(LOG_DIR)/elab.log

run: prepare
	@test -x $(SIMV) || { \
		echo "ERROR: $(SIMV) does not exist; run 'make elab TB_MODE=$(TB_MODE)' first."; \
		exit 2; \
	}
	@cd $(OBJ_DIR) && $(SIMV) $(RUN_OPTS)

sim: elab
	@cd $(OBJ_DIR) && $(SIMV) $(RUN_OPTS)

sim_sv:
	@$(MAKE) sim TB_MODE=sv

sim_uvm:
	@$(MAKE) sim TB_MODE=uvm

# Verdi parses exactly the same filelist as VCS. The filelist expands
# DEMO_ROOT, so all source and include entries resolve to absolute paths.
verdi: sim
	@cd $(SIM_DIR) && verdi -sv \
		$(UVM_COMPILE_OPTS) -f $(SIM_FILELIST) \
		-top $(TB_TOP) -ssf $(FSDB) -nologo &

# DVE is attached to simv, so this is an interactive live-simulation GUI.
dve: elab
	@cd $(OBJ_DIR) && $(SIMV) $(DVE_RUN_OPTS)

lint: prepare
	@cd $(LINT_DIR) && \
		TOP="$(DUT_TOP)" SYN_FILELIST="$(SYN_FILELIST)" \
		SPYGLASS_OUT="$(LINT_DIR)" SPYGLASS_GOAL="$(SPYGLASS_GOAL)" \
		spyglass -shell -tcl $(ROOT_DIR)/scripts/spyglass.tcl

# Open the project saved by the latest lint run without rerunning analysis.
lint_gui:
	@test -f "$(LINT_PROJECT)" || { \
		echo "ERROR: $(LINT_PROJECT) does not exist; run 'make lint' first."; \
		exit 2; \
	}
	@cd $(LINT_DIR) && \
		spyglass -project "$(LINT_PROJECT)" -goals "$(SPYGLASS_GOAL)" \
		> lint_gui.log 2>&1 &

dc: prepare
	@cd $(BUILD_DIR)/dc && \
		TOP="$(DUT_TOP)" SYN_FILELIST="$(SYN_FILELIST)" \
		SDC_FILE="$(ROOT_DIR)/constraints/design.sdc" \
		CLOCK_PERIOD_NS="$(CLOCK_PERIOD_NS)" \
		CLOCK_NAME="$(CLOCK_NAME)" CLOCK_PORT="$(CLOCK_PORT)" \
		ASYNC_RESET_PORT="$(ASYNC_RESET_PORT)" \
		NO_INPUT_DELAY_PORTS="$(NO_INPUT_DELAY_PORTS)" \
		INPUT_DELAY_RATIO="$(INPUT_DELAY_RATIO)" \
		OUTPUT_DELAY_RATIO="$(OUTPUT_DELAY_RATIO)" \
		SETUP_UNCERTAINTY_RATIO="$(SETUP_UNCERTAINTY_RATIO)" \
		HOLD_UNCERTAINTY_NS="$(HOLD_UNCERTAINTY_NS)" \
		OUTPUT_LOAD_PF="$(OUTPUT_LOAD_PF)" \
		MAX_TRANSITION_RATIO="$(MAX_TRANSITION_RATIO)" \
		TECH_LIB="$(TECH_LIB)" INPUT_DRIVE_CELL="$(INPUT_DRIVE_CELL)" \
		EXTRA_LINK_LIBS="$(EXTRA_LINK_LIBS)" \
		dc_shell -64bit -f $(ROOT_DIR)/scripts/dc.tcl \
		-output_log_file $(BUILD_DIR)/dc/dc.log

all: sim lint dc

cov_merge mergecov: prepare
	@if [ -z "$(strip $(COV_INPUTS))" ]; then \
		echo "ERROR: no VDB inputs. Run tests first or set COV_INPUTS='a.vdb b.vdb'."; \
		exit 2; \
	fi
	@test -d $(COMPILE_CM_DIR) || { \
		echo "ERROR: design coverage database $(COMPILE_CM_DIR) does not exist."; \
		exit 2; \
	}
	@VCS_USE_MALLOC=1 urg -full64 -dir $(COMPILE_CM_DIR) $(COV_INPUTS) \
		-dbname $(MERGED_DBNAME) -report $(COV_REPORT) \
		-format both -show ratios -show tests

dvecov: prepare
	@test -d "$(MERGED_CM_DIR)" || { \
		echo "ERROR: $(MERGED_CM_DIR) does not exist; run 'make cov_merge TB_MODE=$(TB_MODE)' first."; \
		exit 2; \
	}
	@cd $(COV_GUI_DIR) && dve -full64 -cov -covdir $(MERGED_CM_DIR)

# Verdi T-2022.06 vdCov can crash in libsnpsmalloc while enumerating tests.
verdicov: prepare
	@test -d "$(MERGED_CM_DIR)" || { \
		echo "ERROR: $(MERGED_CM_DIR) does not exist; run 'make cov_merge TB_MODE=$(TB_MODE)' first."; \
		exit 2; \
	}
	@cd $(COV_GUI_DIR) && VCS_USE_MALLOC=1 \
		verdi -cov -covdir $(MERGED_CM_DIR) \
		-guiConf $(COV_GUI_DIR)/verdi_cov.conf \
		-logdir $(COV_GUI_DIR)/vdCovLog

clean:
	
