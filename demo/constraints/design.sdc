# =============================================================================
# 通用单时钟 SDC。所有可替换项都在 Makefile 顶部，不需要修改本文件。
# 这些数值是教学示例，不是流片约束；实际项目要根据接口协议和时序预算确定。
# =============================================================================

# 创建主时钟。CLOCK_NAME、CLOCK_PORT 和 CLOCK_PERIOD_NS 来自 Makefile。
create_clock -name $CLOCK_NAME -period $CLOCK_PERIOD_NS [get_ports $CLOCK_PORT]

# 为外部组合逻辑、走线和时钟不确定性预留时间。
set_clock_uncertainty -setup \
    [expr {$CLOCK_PERIOD_NS * $SETUP_UNCERTAINTY_RATIO}] [get_clocks $CLOCK_NAME]
set_clock_uncertainty -hold $HOLD_UNCERTAINTY_NS [get_clocks $CLOCK_NAME]
set_input_delay [expr {$CLOCK_PERIOD_NS * $INPUT_DELAY_RATIO}] \
    -clock $CLOCK_NAME \
    [remove_from_collection [all_inputs] [get_ports $NO_INPUT_DELAY_PORTS]]
set_output_delay [expr {$CLOCK_PERIOD_NS * $OUTPUT_DELAY_RATIO}] \
    -clock $CLOCK_NAME [all_outputs]

# 异步复位不作为普通同步数据路径分析；实际芯片仍需检查 recovery/removal。
set_false_path -from [get_ports $ASYNC_RESET_PORT]

# 用标准单元描述输入驱动能力，用电容描述输出负载。
set_driving_cell -lib_cell $INPUT_DRIVE_CELL \
    [remove_from_collection [all_inputs] [get_ports $NO_INPUT_DELAY_PORTS]]
set_load $OUTPUT_LOAD_PF [all_outputs]

# 限制设计中网络的最大转换时间，避免映射出过慢的边沿。
set_max_transition [expr {$CLOCK_PERIOD_NS * $MAX_TRANSITION_RATIO}] [current_design]
