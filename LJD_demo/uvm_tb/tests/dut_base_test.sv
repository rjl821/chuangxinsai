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
// File        : dut_base_test.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Base test class - all tests extend this.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//
// USAGE: Extend this class, override run_phase() to start your sequences.
//=======================================================================
`ifndef DUT_BASE_TEST_SV
`define DUT_BASE_TEST_SV

virtual class dut_base_test extends uvm_test;

  dut_env env;
  dut_config cfg;

  // NOTE: No uvm_component_utils - this is an abstract base class

  function new(string name = "dut_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create configuration and sub-configs
    cfg = dut_config::type_id::create("cfg");

    // Get virtual interface from testbench (set via uvm_config_db in dut_tb.sv)
    if(!uvm_config_db#(virtual generic_if)::get(this, "", "generic_vif", cfg.generic_vif)) begin
      `uvm_fatal("GETVIF", "Cannot get generic_vif from config DB")
    end

    // Propagate vif to sub-configs (both agents share the same interface)
    cfg.generic_cfg.vif         = cfg.generic_vif;
    cfg.generic_cfg_passive.vif = cfg.generic_vif;

    // Set config for env
    uvm_config_db#(dut_config)::set(this, "env", "cfg", cfg);

    // Create env
    env = dut_env::type_id::create("env", this);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_root uvm_top;
    super.end_of_elaboration_phase(phase);
    uvm_top = uvm_root::get();
    uvm_top.set_timeout(cfg.timeout * 1ns);
    `uvm_info(get_type_name(), $sformatf("Timeout set to %0d ns", cfg.timeout), UVM_LOW)
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.phase_done.set_drain_time(this, 10us);
  endtask

  virtual function void report_phase(uvm_phase phase);
    uvm_report_server svr;
    super.report_phase(phase);
    svr = uvm_report_server::get_server();
    if (svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) > 0) begin
      cfg.test_is_passed = 0;
      cfg.test_error_count = svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR);
      `uvm_info(get_type_name(), "\n\nTEST_REPORT :: FAILED \n", UVM_LOW)
    end
    else begin
      cfg.test_is_passed = 1;
      `uvm_info(get_type_name(), "\n\nTEST_REPORT :: PASSED \n", UVM_LOW)
    end
  endfunction

endclass

`endif