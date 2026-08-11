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
// File        : dut_subscriber.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Subscriber base class - centralizes all TLM analysis port
//               declarations. Scoreboard, coverage, and reference model
//               extend this class and override the write_*() functions.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//
// USAGE: Add one `uvm_analysis_imp_decl/_*` pair and write_*() function for each analysis port your environment needs.
//=======================================================================
`ifndef DUT_SUBSCRIBER_SV
`define DUT_SUBSCRIBER_SV

class dut_subscriber extends uvm_component;

  //---------------------------------------------------------------------------
  // USER: Declare one _decl macro per analysis port suffix.
  //       Name the port after the data source (e.g. _apb, _sram, _dma).
  //---------------------------------------------------------------------------
  `uvm_analysis_imp_decl(_item)
  `uvm_analysis_imp_decl(_item_passive)

  //---------------------------------------------------------------------------
  // USER: Declare one analysis imp per data source.
  //       Use matching suffix for the write function name.
  //---------------------------------------------------------------------------
  uvm_analysis_imp_item #(generic_transaction, dut_subscriber) item_imp;
  uvm_analysis_imp_item_passive #(generic_transaction, dut_subscriber) item_passive_imp;

  dut_config cfg;

  `uvm_component_utils(dut_subscriber)

  function new(string name = "dut_subscriber", uvm_component parent);
    super.new(name, parent);
    item_imp         = new("item_imp", this);
    item_passive_imp = new("item_passive_imp", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(dut_config)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal("GETCFG", "cannot get config object from config DB")
    end
  endfunction

  //---------------------------------------------------------------------------
  // USER: Implement write_*() for each port. Override in child classes.
  //       Default implementation is empty (no-op).
  //---------------------------------------------------------------------------
  virtual function void write_item(generic_transaction t);
    // Default: no-op. Override in child class.
  endfunction

  virtual function void write_item_passive(generic_transaction t);
    // Default: no-op. Override in child class.
  endfunction

endclass

`endif