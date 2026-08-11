# ==============================================================================
# SV testbench: VCS / Verdi / SpyGlass / Design Compiler 通用入口
# [REPLACE] 换设计时，只需要修改“用户配置区”。
# ==============================================================================

export LC_ALL := C
export LANG := C
export LANGUAGE :=

SIM_DIR     := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
TB_DIR      := $(abspath $(SIM_DIR)/..)
PROJECT_DIR := $(abspath $(SIM_DIR)/../..)

# ==============================================================================
# 用户配置区：设计和仿真
# ==============================================================================
DUT_TOP := sv_dut_dummy
TB_TOP  := tb_top

# VCS 和 Verdi 读取完整仿真 filelist；SpyGlass 和 DC 读取综合 filelist。
SIM_FILELIST := $(SIM_DIR)/files.f
SYN_FILELIST := $(SIM_DIR)/rtl.f

TEST_NAME ?= tb_smoke_test
SEED      ?= 1
NUM_TRANS ?= 50
VERBOSE  ?= 0
GUI      ?= 0

# ==============================================================================
# 用户配置区：DC 时序约束
# ==============================================================================
CLOCK_NAME           := core_clk
CLOCK_PORT           := clk
RESET_PORT           := rst_n
NO_INPUT_DELAY_PORTS := clk rst_n
CLOCK_PERIOD_NS      := 10.0

INPUT_DELAY_RATIO       := 0.20
OUTPUT_DELAY_RATIO      := 0.20
SETUP_UNCERTAINTY_RATIO := 0.05
HOLD_UNCERTAINTY_NS     := 0.0
OUTPUT_LOAD_PF          := 0.02
MAX_TRANSITION_RATIO    := 0.10

# ==============================================================================
# 用户配置区：TSMC28 工艺库和工具路径
# ==============================================================================
TECH_LIB := /home/jjt/TSMC28/logic/tcbn28hpcplusbwp12t40p140_180a/AN61001_20180514/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp12t40p140_180a/tcbn28hpcplusbwp12t40p140tt0p8v25c.db
INPUT_DRIVE_CELL := INVD1BWP12T40P140
EXTRA_LINK_LIBS :=

VERDI_HOME := /home/jjt/install/synopsys/verdi/verdi/T-2022.06

# ==============================================================================
# 固定流程：通常不需要修改
# ==============================================================================
OUT ?= $(SIM_DIR)/out
CM_TYPE := line+cond+fsm+tgl+branch+assert
CM_NAME := $(TEST_NAME)_$(SEED)
CM_ROOT := $(OUT)/cov
CM_DIR  := $(CM_ROOT)/$(CM_NAME).vdb
MERGED_CM_DIR ?= $(CM_ROOT)/merged.vdb
# URG 把 -dbname 最后一段当作测试名，所以重复一次 merged 才会生成 merged.vdb。
MERGED_DBNAME := $(CM_ROOT)/merged/merged
COV_INPUTS := $(filter-out $(MERGED_CM_DIR),$(wildcard $(CM_ROOT)/*.vdb))
COV_REPORT ?= $(OUT)/coverage_report
SIMV    := $(OUT)/obj/$(TB_TOP).simv
FSDB    := $(OUT)/sim/$(CM_NAME).fsdb
FSDB_DO := $(OUT)/obj/fsdb_dump_$(CM_NAME).do
DVE_DO  := $(SIM_DIR)/tb_sim_run.do

PLI_DIR := $(VERDI_HOME)/share/PLI/VCS/LINUX64
PLI_OPTS := -P $(PLI_DIR)/novas.tab $(PLI_DIR)/pli.a

VLOGAN_OPTS := -full64 -sverilog -timescale=1ns/1ps \
	-kdb -debug_access+all -nc
# 本机 vlogan 不接受 -cm；覆盖率由 vcs 在 elaboration 时完整插桩。
ELAB_OPTS := -full64 -kdb -debug_access+all -sim_res=1ps \
	-Mdir=$(OUT)/obj/csrc $(PLI_OPTS) -cm $(CM_TYPE) -cm_dir $(CM_DIR)
TEST_OPTS := +ntb_random_seed=$(SEED) +TESTNAME=$(TEST_NAME) \
	+NUM_TRANS=$(NUM_TRANS) +VERBOSE=$(VERBOSE)
COV_RUN_OPTS := -cm $(CM_TYPE) -cm_dir $(CM_DIR) -cm_name $(CM_NAME)
RUN_OPTS := -l $(OUT)/sim/$(CM_NAME).log $(TEST_OPTS) $(COV_RUN_OPTS) \
	-ucli -do $(FSDB_DO)
DVE_RUN_OPTS := -l $(OUT)/sim/$(CM_NAME)_dve.log $(TEST_OPTS) \
	$(COV_RUN_OPTS) -gui=dve -ucli -do $(DVE_DO)

# 兼容原用法：make run GUI=verdi。
ifeq ($(GUI),verdi)
RUN_POST := $(VERDI_HOME)/bin/verdi -sv -f $(SIM_FILELIST) \
	-ssf $(FSDB) -top $(TB_TOP) -nologo &
endif

.PHONY: help prepare comp elab run sim verdi dve lint dc all \
	mergecov dvecov verdicov clean

help:
	@echo "make sim     : VCS 编译、运行并生成 FSDB/KDB"
	@echo "make verdi   : 完成仿真后用 filelist+FSDB 打开 Verdi"
	@echo "make dve     : 用 DVE GUI 运行仿真"
	@echo "make lint    : SpyGlass 检查可综合 RTL"
	@echo "make dc      : DC 使用 TSMC28 综合并生成报告"
	@echo "make mergecov: 手动合并 out/cov 下的覆盖率库"
	@echo "make all     : 依次运行 sim、lint、dc"
	@echo "make clean   : 删除本 sim 目录的工具输出"

prepare:
	@mkdir -p $(OUT)/log $(OUT)/obj $(OUT)/sim $(OUT)/spyglass $(CM_ROOT)
	@mkdir -p $(OUT)/dc/reports $(OUT)/dc/outputs $(OUT)/dc/work

comp: prepare
	vlogan $(VLOGAN_OPTS) -l $(OUT)/log/vcomp.log -f $(SIM_FILELIST)

elab: comp
	vcs $(ELAB_OPTS) -l $(OUT)/log/elab.log -top $(TB_TOP) -o $(SIMV)

$(FSDB_DO): prepare
	@echo '# VCS UCLI commands for FSDB dumping' > $@
	@echo 'call {$$fsdbDumpfile("$(FSDB)")}' >> $@
	@echo 'call {$$fsdbDumpvars(0, $(TB_TOP))}' >> $@
	@echo 'run' >> $@

# run 保留为“只运行已有 simv”，方便回归脚本连续更换 test/seed。
run: $(FSDB_DO)
	$(SIMV) $(RUN_OPTS)
	$(RUN_POST)

# sim 是完整的一键流程。
sim: elab $(FSDB_DO)
	$(SIMV) $(RUN_OPTS)

# Verdi 与 VCS 使用同一份 filelist，保证源码、include 和编译顺序一致。
verdi: sim
	$(VERDI_HOME)/bin/verdi -sv -f $(SIM_FILELIST) \
		-ssf $(FSDB) -top $(TB_TOP) -nologo &

dve: elab
	$(SIMV) $(DVE_RUN_OPTS)

lint: prepare
	@cd $(SIM_DIR) && \
		TOP="$(DUT_TOP)" SYN_FILELIST="$(SYN_FILELIST)" \
		SPYGLASS_OUT="$(OUT)/spyglass" \
		spyglass -shell -tcl $(PROJECT_DIR)/scripts/spyglass.tcl

dc: prepare
	@cd $(OUT)/dc && \
		TOP="$(DUT_TOP)" SYN_FILELIST="$(SYN_FILELIST)" \
		SDC_FILE="$(PROJECT_DIR)/constraints/design.sdc" \
		CLOCK_NAME="$(CLOCK_NAME)" CLOCK_PORT="$(CLOCK_PORT)" \
		RESET_PORT="$(RESET_PORT)" \
		NO_INPUT_DELAY_PORTS="$(NO_INPUT_DELAY_PORTS)" \
		CLOCK_PERIOD_NS="$(CLOCK_PERIOD_NS)" \
		INPUT_DELAY_RATIO="$(INPUT_DELAY_RATIO)" \
		OUTPUT_DELAY_RATIO="$(OUTPUT_DELAY_RATIO)" \
		SETUP_UNCERTAINTY_RATIO="$(SETUP_UNCERTAINTY_RATIO)" \
		HOLD_UNCERTAINTY_NS="$(HOLD_UNCERTAINTY_NS)" \
		OUTPUT_LOAD_PF="$(OUTPUT_LOAD_PF)" \
		MAX_TRANSITION_RATIO="$(MAX_TRANSITION_RATIO)" \
		TECH_LIB="$(TECH_LIB)" INPUT_DRIVE_CELL="$(INPUT_DRIVE_CELL)" \
		EXTRA_LINK_LIBS="$(EXTRA_LINK_LIBS)" \
		dc_shell -64bit -f $(PROJECT_DIR)/scripts/dc.tcl \
		-output_log_file $(OUT)/dc/dc.log

all: sim lint dc

mergecov:
	VCS_USE_MALLOC=1 urg -full64 -dir $(COV_INPUTS) -dbname $(MERGED_DBNAME) \
		-report $(COV_REPORT) -format both -show ratios -show tests

dvecov:
	dve -full64 -cov -covdir $(MERGED_CM_DIR)

verdicov:
	$(VERDI_HOME)/bin/verdi -cov -covdir $(MERGED_CM_DIR)

clean:
	rm -rf -- $(OUT) AN.DB DVEfiles ucli.key verdiLog vdCovLog novas.conf novas.rc
