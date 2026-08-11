`timescale 1ns/1ps
`include "tb_defs.svh"

interface dut_if #(
  parameter int DATA_W = `TB_DATA_W
) (
  input logic clk,
  input logic rst_n
);

  logic              in_valid;
  logic              in_ready;
  logic [DATA_W-1:0] a;
  logic [DATA_W-1:0] b;
  logic              out_valid;
  logic              out_ready;
  logic [DATA_W-1:0] result;

  clocking drv_cb @(posedge clk);
    default input #1step output #1step;
    input  in_ready;
    output in_valid;
    output a;
    output b;
    output out_ready;
  endclocking

  clocking mon_cb @(posedge clk);
    default input #1step output #1step;
    input in_valid;
    input in_ready;
    input a;
    input b;
    input out_valid;
    input out_ready;
    input result;
  endclocking

endinterface
