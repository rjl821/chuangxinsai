//=======================================================================
// COPYRIGHT (C) 2018-2026 RockerIC, Ltd.
// This software and the associated documentation are confidential and
// proprietary to RockerIC, Ltd. Your use or disclosure of this software
// is subject to the terms and conditions of a consulting agreement
// between you, or your company, and RockerIC, Ltd. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//
// VisitUs  : www.rockeric.com
// Support  : support@rockeric.com
//=======================================================================
// File        : sv_dut_dummy.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Minimal SV-template DUT - valid/ready adder.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |
//
// USAGE: Replace this with your own DUT.
//=======================================================================
`ifndef SV_DUT_DUMMY_SV
`define SV_DUT_DUMMY_SV

module sv_dut_dummy #(
  parameter int DATA_W = 32
) (
  input  logic              clk,
  input  logic              rst_n,

  input  logic              in_valid,
  output logic              in_ready,
  input  logic [DATA_W-1:0] a,
  input  logic [DATA_W-1:0] b,

  output logic              out_valid,
  input  logic              out_ready,
  output logic [DATA_W-1:0] result
);

  assign in_ready = !out_valid || out_ready;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      out_valid <= 1'b0;
      result    <= '0;
    end else begin
      if (in_valid && in_ready) begin
        result    <= a + b;
        out_valid <= 1'b1;
      end else if (out_valid && out_ready) begin
        out_valid <= 1'b0;
      end
    end
  end

endmodule

`endif
