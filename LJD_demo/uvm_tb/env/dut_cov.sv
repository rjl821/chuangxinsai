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
// File        : dut_cov.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Coverage collector - extends dut_subscriber, overrides
//               write_item() to sample covergroups.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//
// USAGE: Override write_item() with your own covergroup sampling logic.
//=======================================================================
`ifndef DUT_COV_SV
`define DUT_COV_SV

class dut_cov extends dut_subscriber;

  `uvm_component_utils(dut_cov)

  function new(string name = "dut_cov", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  //---------------------------------------------------------------------------
  // write_item - active agent monitor callback
  //---------------------------------------------------------------------------
  virtual function void write_item(generic_transaction t);
    // USER: Sample your covergroups here (active monitor data).
  endfunction

  //---------------------------------------------------------------------------
  // write_item_passive - passive agent monitor callback
  //---------------------------------------------------------------------------
  virtual function void write_item_passive(generic_transaction t);
    // USER: Sample your covergroups here (passive monitor data).
  endfunction

endclass

`endif