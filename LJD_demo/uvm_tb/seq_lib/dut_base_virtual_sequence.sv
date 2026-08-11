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
// File        : dut_base_virtual_sequence.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Base virtual sequence providing common utility tasks.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//
// USAGE: Extend this class for your test sequences. Add your own register setup / data generation helpers.
//=======================================================================
`ifndef DUT_BASE_VIRTUAL_SEQUENCE_SV
`define DUT_BASE_VIRTUAL_SEQUENCE_SV

class dut_base_virtual_sequence extends uvm_sequence;

  dut_config cfg;
  virtual generic_if generic_vif;

  `uvm_object_utils(dut_base_virtual_sequence)
  `uvm_declare_p_sequencer(dut_virtual_sequencer)

  function new(string name = "dut_base_virtual_sequence");
    super.new(name);
  endfunction

  //---------------------------------------------------------------------------
  // get_config - pull configuration and virtual interfaces from the sequencer
  //---------------------------------------------------------------------------
  virtual task get_config();
    cfg = p_sequencer.cfg;
    generic_vif = cfg.generic_vif;
  endtask

  //---------------------------------------------------------------------------
  // wait_reset_signal_assertted / released
  //---------------------------------------------------------------------------
  virtual task wait_reset_signal_assertted();
    @(negedge generic_vif.rstn);
  endtask

  virtual task wait_reset_signal_released();
    @(posedge generic_vif.rstn);
  endtask

  //---------------------------------------------------------------------------
  // wait_cycles
  //---------------------------------------------------------------------------
  virtual task wait_cycles(int num = 1);
    repeat(num) @(posedge generic_vif.clk);
  endtask

  //---------------------------------------------------------------------------
  // wait_ready_for_stim - wait for reset release then settle
  //---------------------------------------------------------------------------
  virtual task wait_ready_for_stim();
    wait_reset_signal_released();
    repeat(20) @(posedge generic_vif.clk);
    `uvm_info(get_type_name(), "Ready for stimulus", UVM_LOW)
  endtask

  //---------------------------------------------------------------------------
  // compare_data - self-checking helper
  //---------------------------------------------------------------------------
  virtual function void compare_data(bit [31:0] act, bit [31:0] exp, string name = "data");
    cfg.seq_check_count++;
    if (act !== exp) begin
      cfg.seq_check_error++;
      `uvm_error("SEQ_CMP", $sformatf("%s mismatch: exp=0x%08h, act=0x%08h", name, exp, act))
    end
  endfunction

  //---------------------------------------------------------------------------
  // body - base sequence just waits for reset
  //---------------------------------------------------------------------------
  virtual task body();
    get_config();
    wait_ready_for_stim();
  endtask

endclass

`endif