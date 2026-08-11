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
// File        : dut_smoke_test.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Smoke test - starts the smoke virtual sequence.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//=======================================================================
`ifndef DUT_SMOKE_TEST_SV
`define DUT_SMOKE_TEST_SV

class dut_smoke_test extends dut_base_test;

  `uvm_component_utils(dut_smoke_test)

  function new(string name = "dut_smoke_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    dut_smoke_virt_seq seq;
    super.run_phase(phase);
    phase.raise_objection(this);
    seq = dut_smoke_virt_seq::type_id::create("seq");
    seq.start(env.virt_sqr);
    phase.drop_objection(this);
  endtask

endclass

`endif