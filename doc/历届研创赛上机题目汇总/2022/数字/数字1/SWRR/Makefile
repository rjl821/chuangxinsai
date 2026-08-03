#########################################################################
#    This Makefile is made for swrr.
###############################################################################
#SHELL :=/bin/csh
export
.EXPORT_ALL_VARIABLES:
IRUN_WAVE_ARGS = -input ./ncsim.tcl
IUS_OS64_OPT    := -64 
DUT := swrr.v
TB1 := case1.sv
TB2 := case2.sv
TB3 := case3.sv
TB4 := case4.sv
TB5 := case5.sv
IRUN_BASE_ARGS += \
	-access +rwc \
	-top testbench \ 



.PHONY :  runw  cmpcase1 cmpcase2 cmpcase3 cmpcase4 cmpcase5 \

cmpcase1: 
	xrun $(IUS_OS64_OPT) $(DUT) $(IRUN_BASE_ARGS) $(TB1) -c
cmpcase2:
	xrun $(IUS_OS64_OPT) $(DUT) $(IRUN_BASE_ARGS)  $(TB2) -c
cmpcase3:
	xrun $(IUS_OS64_OPT) $(DUT) $(IRUN_BASE_ARGS) $(TB3) -c
cmpcase4:
	xrun $(IUS_OS64_OPT) $(DUT) $(IRUN_BASE_ARGS) $(TB4) -c
cmpcase5:
	xrun $(IUS_OS64_OPT) $(DUT) $(IRUN_BASE_ARGS) $(TB5) -c
#runw:build run

runw:
	xrun $(IUS_OS64_OPT) -R $(IRUN_WAVE_ARGS) 
