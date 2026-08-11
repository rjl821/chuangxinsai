#############################
# User variables
#############################
export LC_ALL := C
export LANG := C
export LANGUAGE :=

TB        = dut_tb
SEED      = 1
GUI      ?= 0
COV      ?= 1
VERB     ?= UVM_LOW
OUT      ?= out
TESTNAME ?= dut_smoke_test

DFILES   += -f ./dut_top.f
VFILES   += ../agents/generic/generic_if.sv \
            ../agents/generic/generic_pkg.sv \
            ../env/dut_pkg.sv \
            ../tb/dut_tb.sv

VCOMP_INC = +incdir+../agents/generic \
            +incdir+.. \
            +incdir+../cfg \
            +incdir+../env \
            +incdir+../tb \
            +incdir+../tests \
            +incdir+../seq_lib \
            +incdir+../../rtl

VCOMP    = vlogan -full64 -ntb_opts uvm-1.2 -sverilog -timescale=1ns/1ps -debug_access+class -debug_region+lib -nc -l $(OUT)/log/vcomp.log $(VCOMP_INC)
ELAB     = vcs -full64 -ntb_opts uvm-1.2 -debug_acc+all -Mdir=$(OUT)/obj/csrc -l $(OUT)/log/elab.log -sim_res=1ps
RUN      = $(OUT)/obj/$(TB).simv -l $(OUT)/sim/$(CM_NAME).log +ntb_random_seed=$(SEED) +UVM_TESTNAME=$(TESTNAME) +UVM_VERBOSITY=$(VERB)
COV_OPTS = -full64 -dir $(CM_DIR)
CM_DIR  ?= $(OUT)/cov.vdb
CM_NAME ?= $(TESTNAME)_$(SEED)
SIMRUNFILE = dut_sim_run.do
VERDIRUNFILE = $(OUT)/obj/verdi_run.do
VERDI_HOME ?= $(shell which verdi 2>/dev/null | xargs dirname 2>/dev/null | xargs dirname 2>/dev/null)

ifeq ($(GUI),1)
RUN += -gui=dve -ucli -do $(SIMRUNFILE)
endif

ifeq ($(GUI),verdi)
VCOMP += -P $(VERDI_HOME)/share/PLI/VCS/LINUX64/novas.tab \
         $(VERDI_HOME)/share/PLI/VCS/LINUX64/pli.a
ELAB  += -P $(VERDI_HOME)/share/PLI/VCS/LINUX64/novas.tab \
         $(VERDI_HOME)/share/PLI/VCS/LINUX64/pli.a
RUN   += -ucli -do $(VERDIRUNFILE)
endif

ifeq ($(COV),1)
ELAB  += -cm line+cond+fsm+tgl+branch -cm_dir $(CM_DIR) -cm_hier dut_cov_hier.config
RUN   += -cm line+cond+fsm+tgl+branch -covg_cont_on_error -cm_dir $(CM_DIR) -cm_name $(CM_NAME)
endif

prepare:
	mkdir -p $(OUT)/work
	mkdir -p $(OUT)/log
	mkdir -p $(OUT)/sim
	mkdir -p $(OUT)/obj

$(VERDIRUNFILE): prepare FORCE
	@echo '# Verdi FSDB dumping script' > $@
	@echo 'call {$$fsdbDumpfile("$(OUT)/sim/$(CM_NAME).fsdb")}' >> $@
	@echo 'call {$$fsdbDumpvars(0, $(TB))}' >> $@
	@echo 'run' >> $@

FORCE:

comp: prepare
	$(VCOMP)
	$(VCOMP) $(DFILES) $(VFILES)

elab: comp
	$(ELAB) -top $(TB) -o $(OUT)/obj/$(TB).simv

ifeq ($(GUI),verdi)
RUN_DEPS = $(VERDIRUNFILE)
RUN_POST = verdi -ssf $(OUT)/sim/$(CM_NAME).fsdb -nologo &
endif

run: $(RUN_DEPS)
	$(RUN)
	$(RUN_POST)

mergecov:
	urg -format both $(COV_OPTS) -show ratios

dvecov:
	dve $(COV_OPTS)

verdicov:
	verdi -cov -covdir $(CM_DIR)

htmlcov:
	firefox urgReport/dashboard.html

clean:
	rm -rf $(OUT) 64 AN.DB DVEfiles csrc *.simv *.simv.daidir *.simv.vdb ucli.key vdCovLog vhdl_objs_dir
	rm -rf .shadow *.log* *.conf *.vpd *.h urgReport *.fsdb work.lib++ verdiLog 64 *.tar.gz stack.info*
	rm -rf *.vdb eman* *_cosim *.slave_transaction_tra novas.rc .restartSimSession.tcl.old .inter.vpd.uvm
