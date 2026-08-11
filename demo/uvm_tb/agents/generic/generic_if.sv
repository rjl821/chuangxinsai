`ifndef GENERIC_IF_SV
`define GENERIC_IF_SV

interface generic_if(input logic clk, input logic rstn);

  import vector_mac_params_pkg::*;

  // 环境参数跟随 DUT。
  localparam int DATA_W = VECTOR_MAC_DATA_W;
  localparam int ACC_W  = VECTOR_MAC_ACC_W;
  localparam int LEN_W  = VECTOR_MAC_LEN_W;

  logic                         start;
  logic [LEN_W:0]               length;
  logic                         start_ready;
  logic signed [DATA_W-1:0]     a_data;
  logic signed [DATA_W-1:0]     b_data;
  logic                         in_valid;
  logic                         in_ready;
  logic signed [ACC_W-1:0]      y_data;
  logic                         y_valid;
  logic                         y_ready;
  logic                         busy;

  initial begin
    start    = 1'b0;
    length   = '0;
    a_data   = '0;
    b_data   = '0;
    in_valid = 1'b0;
    y_ready  = 1'b0;
  end

  // driver 和 monitor 通过 clocking block 访问接口。
  clocking drv_cb @(posedge clk);
    default input #1ps output #1ps;
    output start, length, a_data, b_data, in_valid, y_ready;
    input  start_ready, in_ready, y_data, y_valid, busy;
  endclocking : drv_cb

  clocking mon_cb @(posedge clk);
    default input #1ps output #1ps;
    input start, length, start_ready;
    input a_data, b_data, in_valid, in_ready;
    input y_data, y_valid, y_ready, busy;
  endclocking : mon_cb

endinterface : generic_if

`endif
