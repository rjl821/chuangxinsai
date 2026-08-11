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
// File        : dut_dummy.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Minimal DUT - registered pass-through.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//
// USAGE: Replace this with your own DUT.
//=======================================================================
`ifndef DUT_DUMMY_SV
`define DUT_DUMMY_SV

module dut_dummy (
  input  logic        clk_i,
  input  logic        rstn_i,
  input  logic [31:0] sig_in,
  output logic [31:0] sig_out
);

  // Simple registered pass-through
  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i)
      sig_out <= 32'h0;
    else
      sig_out <= sig_in;
  end

endmodule

`endif