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
// File        : dut_smoke_virt_seq.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Smoke test virtual sequence - end-to-end sanity check.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//
// USAGE: Replace with your own test sequence. This template sends simple random transactions through the generic agent and checks pass.
//=======================================================================
`ifndef DUT_SMOKE_VIRT_SEQ_SV
`define DUT_SMOKE_VIRT_SEQ_SV

class dut_smoke_virt_seq extends dut_base_virtual_sequence;

  `uvm_object_utils(dut_smoke_virt_seq)

  function new(string name = "dut_smoke_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    generic_transaction tr;

    super.body();  // get config + wait reset

    // Send a simple transaction through the generic agent
    `uvm_info(get_type_name(), "Starting smoke sequence...", UVM_LOW)

    // Send a few random data values
    for (int i = 0; i < 5; i++) begin
      `uvm_do_on_with(tr, p_sequencer.generic_sqr, {
        data_in == 32'hA5A5_0000 + i;
      })
      `uvm_info(get_type_name(), $sformatf("Transaction %0d: data_in=0x%08h", i, tr.data_in), UVM_LOW)
    end

    // Wait a few cycles for DUT to process
    wait_cycles(10);

    `uvm_info(get_type_name(), "Smoke test completed", UVM_LOW)
  endtask

endclass

`endif