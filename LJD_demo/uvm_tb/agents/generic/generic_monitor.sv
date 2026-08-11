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
// File        : generic_monitor.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Generic monitor template.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//
// USAGE: Replace the run_phase() body with your own monitoring logic. Collect observed transactions and send via item_observed_port.
//=======================================================================
`ifndef GENERIC_MONITOR_SV
`define GENERIC_MONITOR_SV

class generic_monitor extends uvm_monitor;

  generic_config cfg;
  uvm_analysis_port #(generic_transaction) item_observed_port;

  `uvm_component_utils(generic_monitor)

  function new(string name = "generic_monitor", uvm_component parent);
    super.new(name, parent);
    item_observed_port = new("item_observed_port", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // NOTE: cfg is assigned directly by the parent agent in its build_phase.
    // No uvm_config_db::get needed here.
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    generic_transaction tr;
    // USER: Implement your monitor logic here.
    // Placeholder: sample sig_in and sig_out on every clock
    forever begin
      @(cfg.vif.mon_cb);
      tr = generic_transaction::type_id::create("tr");
      tr.data_in  = cfg.vif.mon_cb.sig_in;
      tr.data_out = cfg.vif.mon_cb.sig_out;
      `uvm_info(get_type_name(), $sformatf("MON: sig_in=0x%08h sig_out=0x%08h", tr.data_in, tr.data_out), UVM_HIGH)
      item_observed_port.write(tr);
    end
  endtask : run_phase

endclass : generic_monitor

`endif