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
// File        : dut_virtual_sequencer.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Virtual sequencer holding handles to agent sequencers.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//
// USAGE: Add handles for each of your agent sequencers.
//=======================================================================
`ifndef DUT_VIRTUAL_SEQUENCER_SV
`define DUT_VIRTUAL_SEQUENCER_SV

class dut_virtual_sequencer extends uvm_sequencer;

  dut_config cfg;
  generic_sequencer generic_sqr;

  // USER: Add your own agent sequencer handles here

  `uvm_component_utils(dut_virtual_sequencer)

  function new (string name = "dut_virtual_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(dut_config)::get(this,"","cfg", cfg)) begin
      `uvm_fatal("GETCFG","cannot get config object from config DB")
    end
  endfunction

endclass

`endif