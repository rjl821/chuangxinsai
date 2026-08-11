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
// File        : generic_driver.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Generic driver template.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//
// USAGE: Replace the run_phase() body with your own drive logic. Use cfg.vif.drv_cb to access the interface clocking block.
//=======================================================================
`ifndef GENERIC_DRIVER_SV
`define GENERIC_DRIVER_SV

class generic_driver extends uvm_driver #(generic_transaction);

  generic_config cfg;

  `uvm_component_utils(generic_driver)

  function new(string name = "generic_driver", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // NOTE: cfg is assigned directly by the parent agent in its build_phase.
    // No uvm_config_db::get needed here.
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    // USER: Implement your driver logic here.
    // Example:
    //   forever begin
    //     seq_item_port.get_next_item(req);
    //     `uvm_info(get_type_name(), $sformatf("Driving: %s", req.sprint()), UVM_HIGH)
    //     @(cfg.vif.drv_cb);
    //     cfg.vif.drv_cb.sig_in <= req.data_in;
    //     seq_item_port.item_done();
    //   end
    //
    // Placeholder: drive random data on sig_in every few cycles
    forever begin
      seq_item_port.get_next_item(req);
      @(cfg.vif.drv_cb);
      cfg.vif.drv_cb.sig_in <= req.data_in;
      `uvm_info(get_type_name(), $sformatf("DRV: sig_in=0x%08h", req.data_in), UVM_MEDIUM)
      seq_item_port.item_done();
    end
  endtask : run_phase

endclass : generic_driver

`endif