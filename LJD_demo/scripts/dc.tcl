# 固定 DC 流程。换设计时只修改对应 sim/Makefile 顶部的用户配置区。
set TOP              $::env(TOP)
set SYN_FILELIST     $::env(SYN_FILELIST)
set SDC_FILE         $::env(SDC_FILE)
set TECH_LIB         $::env(TECH_LIB)
set EXTRA_LINK_LIBS  $::env(EXTRA_LINK_LIBS)

# 约束参数全部由 Makefile 传入，供 design.sdc 使用。
set CLOCK_NAME              $::env(CLOCK_NAME)
set CLOCK_PORT              $::env(CLOCK_PORT)
set RESET_PORT              $::env(RESET_PORT)
set NO_INPUT_DELAY_PORTS    $::env(NO_INPUT_DELAY_PORTS)
set CLOCK_PERIOD_NS         $::env(CLOCK_PERIOD_NS)
set INPUT_DELAY_RATIO       $::env(INPUT_DELAY_RATIO)
set OUTPUT_DELAY_RATIO      $::env(OUTPUT_DELAY_RATIO)
set SETUP_UNCERTAINTY_RATIO $::env(SETUP_UNCERTAINTY_RATIO)
set HOLD_UNCERTAINTY_NS     $::env(HOLD_UNCERTAINTY_NS)
set OUTPUT_LOAD_PF          $::env(OUTPUT_LOAD_PF)
set MAX_TRANSITION_RATIO    $::env(MAX_TRANSITION_RATIO)
set INPUT_DRIVE_CELL        $::env(INPUT_DRIVE_CELL)

set_app_var sh_continue_on_error false
define_design_lib WORK -path work
set_svf default.svf

set_app_var search_path [concat $search_path [file dirname $TECH_LIB]]
set_app_var target_library [list $TECH_LIB]
set_app_var link_library [concat "*" [list $TECH_LIB] $EXTRA_LINK_LIBS]

# filelist 中的相对路径以 filelist 所在目录为基准。
set RUN_DIR [pwd]
cd [file dirname $SYN_FILELIST]
analyze -format sverilog -vcs "-f $SYN_FILELIST"
cd $RUN_DIR
elaborate $TOP
current_design $TOP
link
check_design

source $SDC_FILE
check_timing
compile_ultra
change_names -rules verilog -hierarchy

# 综合质量、约束和设计完整性报告。
report_qor                       > reports/qor.rpt
report_area -hierarchy           > reports/area.rpt
report_power                     > reports/power.rpt
report_resources                 > reports/resources.rpt
report_reference                 > reports/references.rpt
report_clock                     > reports/clocks.rpt
report_port -verbose             > reports/ports.rpt
check_design                     > reports/check_design.rpt
check_timing                     > reports/check_timing.rpt
report_constraint -max_delay -min_delay -max_transition -max_capacitance \
    -all_violators > reports/constraints.rpt

# 全局 setup/hold，以及按起点和终点分类的 setup 路径。
set ALL_INPUTS  [all_inputs]
set ALL_OUTPUTS [all_outputs]
set REG_OUTPUTS [all_registers -output_pins]
set REG_INPUTS  [all_registers -data_pins]

report_timing -delay_type max -max_paths 10 \
    > reports/timing_max.rpt
report_timing -delay_type min -max_paths 10 \
    > reports/timing_min.rpt
report_timing -delay_type max -from $ALL_INPUTS -to $REG_INPUTS -max_paths 10 \
    > reports/timing_in2reg.rpt
report_timing -delay_type max -from $REG_OUTPUTS -to $REG_INPUTS -max_paths 10 \
    > reports/timing_reg2reg.rpt
report_timing -delay_type max -from $REG_OUTPUTS -to $ALL_OUTPUTS -max_paths 10 \
    > reports/timing_reg2out.rpt
report_timing -delay_type max -from $ALL_INPUTS -to $ALL_OUTPUTS -max_paths 10 \
    > reports/timing_in2out.rpt

# 映射后交付文件。
write -format ddc -hierarchy -output outputs/${TOP}.ddc
write -format verilog -hierarchy -output outputs/${TOP}_mapped.v
write_sdc outputs/${TOP}_mapped.sdc
write_sdf outputs/${TOP}_mapped.sdf

exit
