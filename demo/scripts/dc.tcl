# 固定的 Design Compiler 流程。顶层、filelist、时钟和库都在 Makefile 中配置。
set TOP              $::env(TOP)
set SYN_FILELIST     $::env(SYN_FILELIST)
set SDC_FILE         $::env(SDC_FILE)
set TECH_LIB         $::env(TECH_LIB)
set EXTRA_LINK_LIBS  $::env(EXTRA_LINK_LIBS)
set CLOCK_PERIOD_NS  $::env(CLOCK_PERIOD_NS)
set INPUT_DRIVE_CELL $::env(INPUT_DRIVE_CELL)

# 下面这些约束值也都在 Makefile 顶部修改。
set CLOCK_NAME             $::env(CLOCK_NAME)
set CLOCK_PORT             $::env(CLOCK_PORT)
set ASYNC_RESET_PORT       $::env(ASYNC_RESET_PORT)
set NO_INPUT_DELAY_PORTS   $::env(NO_INPUT_DELAY_PORTS)
set INPUT_DELAY_RATIO      $::env(INPUT_DELAY_RATIO)
set OUTPUT_DELAY_RATIO     $::env(OUTPUT_DELAY_RATIO)
set SETUP_UNCERTAINTY_RATIO $::env(SETUP_UNCERTAINTY_RATIO)
set HOLD_UNCERTAINTY_NS    $::env(HOLD_UNCERTAINTY_NS)
set OUTPUT_LOAD_PF         $::env(OUTPUT_LOAD_PF)
set MAX_TRANSITION_RATIO   $::env(MAX_TRANSITION_RATIO)

set_app_var sh_continue_on_error false
define_design_lib WORK -path work
set_svf default.svf

set_app_var search_path [concat $search_path [file dirname $TECH_LIB]]
set_app_var target_library [list $TECH_LIB]
set_app_var link_library [concat "*" [list $TECH_LIB] $EXTRA_LINK_LIBS]

# DC Presto 不展开 filelist 中的环境变量。先用 Tcl 对同一份 filelist
# 做变量替换，再让 analyze 读取生成在 build/dc 下的副本。
set RUN_DIR [pwd]
set DEMO_ROOT $::env(DEMO_ROOT)
set FILELIST_IN [open $SYN_FILELIST r]
set FILELIST_TEXT [read $FILELIST_IN]
close $FILELIST_IN
set RESOLVED_FILELIST [file join $RUN_DIR rtl_resolved.f]
set FILELIST_OUT [open $RESOLVED_FILELIST w]
puts -nonewline $FILELIST_OUT \
    [subst -nocommands -nobackslashes $FILELIST_TEXT]
close $FILELIST_OUT
if {![analyze -format sverilog -vcs "-f $RESOLVED_FILELIST"]} {
    error "DC analyze failed while reading $SYN_FILELIST"
}
elaborate $TOP
current_design $TOP
link
check_design

source $SDC_FILE
check_timing
compile_ultra
change_names -rules verilog -hierarchy

# 综合质量报告。
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

# 时序报告。max 是 setup，min 是 hold；其余四份按路径类型分类。
# 先保存集合，避免部分 DC 版本把命令替换结果误当成多个 -from/-to 参数。
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

# 可交付文件。
write -format ddc -hierarchy -output outputs/${TOP}.ddc
write -format verilog -hierarchy -output outputs/${TOP}_mapped.v
write_sdc outputs/${TOP}_mapped.sdc
write_sdf outputs/${TOP}_mapped.sdf

exit
