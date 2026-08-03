# Reading C:/intelFPGA/16.1/modelsim_ae/tcl/vsim/pref.tcl
#cd C:/01_Work/00_New/01_CNN/20_Question/lab_solution_v2/sim
vlib work
vlog -reportprogress 300 -work work tb_cnn.sv
vlog -reportprogress 300 -work work ../src/*.v
#vlog -reportprogress 300 -work work C:/01_Work/00_New/01_CNN/20_Question/lab_solution_v2/src/hyperpipe.v
#vlog -reportprogress 300 -work work C:/01_Work/00_New/01_CNN/20_Question/lab_solution_v2/src/cnn.v
#vlog -reportprogress 300 -work work C:/01_Work/00_New/01_CNN/20_Question/lab_solution_v2/src/mult_add_3x3.v
vsim -gui -L 220model_ver -L altera_mf_ver -L altera_ver work.tb_cnn
do wave.do
run 60us

