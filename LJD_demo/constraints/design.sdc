# =============================================================================
# 通用单时钟约束。所有端口名和数值都在两个 sim/Makefile 顶部配置。
# 这里的比例和负载是教学模板，实际项目应按接口时序预算替换。
# =============================================================================

create_clock -name $CLOCK_NAME -period $CLOCK_PERIOD_NS [get_ports $CLOCK_PORT]

set_clock_uncertainty -setup \
    [expr {$CLOCK_PERIOD_NS * $SETUP_UNCERTAINTY_RATIO}] [get_clocks $CLOCK_NAME]
set_clock_uncertainty -hold $HOLD_UNCERTAINTY_NS [get_clocks $CLOCK_NAME]

set_input_delay [expr {$CLOCK_PERIOD_NS * $INPUT_DELAY_RATIO}] \
    -clock $CLOCK_NAME \
    [remove_from_collection [all_inputs] [get_ports $NO_INPUT_DELAY_PORTS]]
set_output_delay [expr {$CLOCK_PERIOD_NS * $OUTPUT_DELAY_RATIO}] \
    -clock $CLOCK_NAME [all_outputs]

# 异步复位不作为普通同步数据路径分析。
set_false_path -from [get_ports $RESET_PORT]

set_driving_cell -lib_cell $INPUT_DRIVE_CELL \
    [remove_from_collection [all_inputs] [get_ports $NO_INPUT_DELAY_PORTS]]
set_load $OUTPUT_LOAD_PF [all_outputs]
set_max_transition [expr {$CLOCK_PERIOD_NS * $MAX_TRANSITION_RATIO}] [current_design]
