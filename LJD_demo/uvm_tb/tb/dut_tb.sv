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
// File        : dut_tb.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Top-level testbench - clock, reset, interface instantiation,
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//
// USAGE: Replace dut_dummy with your own DUT. Add/remove interfaces as needed.
//=======================================================================
`ifndef DUT_TB_SV
`define DUT_TB_SV

module dut_tb;

  import uvm_pkg::*;
  import dut_pkg::*;

  //---------------------------------------------------------------------------
  // Clock and Reset
  //---------------------------------------------------------------------------
  logic clk;
  logic rstn;

  // 400 MHz clock (2.5ns period)
  initial begin
    clk = 0;
    forever #1.25 clk = ~clk;
  end

  // Reset sequence
  initial begin
    rstn = 0;
    repeat(10) @(posedge clk);
    rstn = 1;
    @(posedge clk);
  end

  //---------------------------------------------------------------------------
  // Interface instantiation
  //---------------------------------------------------------------------------
  generic_if generic_if_inst(.clk(clk), .rstn(rstn));

  //---------------------------------------------------------------------------
  // DUT instantiation
  //---------------------------------------------------------------------------
  dut_dummy dut (
    .clk_i     (clk),
    .rstn_i    (rstn),
    .sig_in    (generic_if_inst.sig_in),
    .sig_out   (generic_if_inst.sig_out)
  );

  //---------------------------------------------------------------------------
  // Configuration database setup
  //---------------------------------------------------------------------------
  initial begin
    // Set vif for test layer
    uvm_config_db#(virtual generic_if)::set(uvm_root::get(), "uvm_test_top", "generic_vif", generic_if_inst);

    // Per-agent vif - both active and passive agents share the same interface
    uvm_config_db#(virtual generic_if)::set(uvm_root::get(), "uvm_test_top.env.generic_agt",         "vif", generic_if_inst);
    uvm_config_db#(virtual generic_if)::set(uvm_root::get(), "uvm_test_top.env.generic_agt_passive", "vif", generic_if_inst);

    // Launch the test
    run_test();
  end

endmodule

`endif