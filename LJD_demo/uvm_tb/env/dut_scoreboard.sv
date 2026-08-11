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
// File        : dut_scoreboard.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Scoreboard - extends dut_subscriber, overrides write_item()
//               to implement expected vs actual comparison logic.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//
// USAGE: Implement your comparison logic in write_item().
//=======================================================================
`ifndef DUT_SCOREBOARD_SV
`define DUT_SCOREBOARD_SV

class dut_scoreboard extends dut_subscriber;

  `uvm_component_utils(dut_scoreboard)

  function new(string name = "dut_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  //---------------------------------------------------------------------------
  // write_item - active agent monitor callback
  //---------------------------------------------------------------------------
  virtual function void write_item(generic_transaction t);
    // USER: Implement your scoreboard comparison logic here.
    cfg.scb_check_count++;
  endfunction

  //---------------------------------------------------------------------------
  // write_item_passive - passive agent monitor callback
  //---------------------------------------------------------------------------
  virtual function void write_item_passive(generic_transaction t);
    // USER: Implement your passive side comparison logic here.
    // Example: check protocol compliance, collect passive-side data, etc.
  endfunction

endclass

`endif