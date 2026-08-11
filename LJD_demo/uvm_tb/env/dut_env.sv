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
// File        : dut_env.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Generic UVM environment for module-level verification.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//
// USAGE: Replace generic_agt with your own agents. Wire your own scoreboard, coverage collector, and reference model.
//=======================================================================
`ifndef DUT_ENV_SV
`define DUT_ENV_SV

class dut_env extends uvm_env;

  dut_config cfg;
  dut_virtual_sequencer virt_sqr;
  generic_agent generic_agt;           // Active: driver + monitor
  generic_agent generic_agt_passive;   // Passive: monitor only
  dut_scoreboard scb;
  dut_cov cgm;

  `uvm_component_utils(dut_env)

  function new (string name = "dut_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get configuration from test layer
    if(!uvm_config_db#(dut_config)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal("GETCFG","cannot get config object from config DB")
    end

    // Configure agent modes: active (driver+monitor) vs passive (monitor only)
    cfg.generic_cfg.is_active         = 1;
    cfg.generic_cfg_passive.is_active = 0;

    // Propagate config to children
    uvm_config_db#(dut_config)::set(this, "virt_sqr", "cfg", cfg);
    uvm_config_db#(dut_config)::set(this, "scb", "cfg", cfg);
    uvm_config_db#(dut_config)::set(this, "cgm", "cfg", cfg);
    uvm_config_db#(generic_config)::set(this, "generic_agt", "cfg", cfg.generic_cfg);
    uvm_config_db#(generic_config)::set(this, "generic_agt_passive", "cfg", cfg.generic_cfg_passive);

    // Create components
    virt_sqr = dut_virtual_sequencer::type_id::create("virt_sqr", this);
    generic_agt         = generic_agent::type_id::create("generic_agt", this);
    generic_agt_passive = generic_agent::type_id::create("generic_agt_passive", this);
    scb = dut_scoreboard::type_id::create("scb", this);
    cgm = dut_cov::type_id::create("cgm", this);

    // USER: Create your own components here (reference model, etc.)
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect virtual sequencer handle to active agent sequencer
    virt_sqr.generic_sqr = generic_agt.sequencer;

    // Active agent monitor ? subscribers
    generic_agt.monitor.item_observed_port.connect(scb.item_imp);
    generic_agt.monitor.item_observed_port.connect(cgm.item_imp);

    // Passive agent monitor ? subscribers
    generic_agt_passive.monitor.item_observed_port.connect(scb.item_passive_imp);
    generic_agt_passive.monitor.item_observed_port.connect(cgm.item_passive_imp);

    // USER: Wire additional connections here.
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_type_name(), "end_of_elaboration phase entered", UVM_HIGH)
    `uvm_info(get_type_name(), "end_of_elaboration phase exited", UVM_HIGH)
  endfunction

  function void report_phase(uvm_phase phase);
    string reports = "\n";
    super.report_phase(phase);
    reports = {reports, $sformatf("=============================================== \n")};
    reports = {reports, $sformatf("CURRENT TEST SUMMARY \n")};
    reports = {reports, $sformatf("SEQUENCE CHECK COUNT : %0d \n", cfg.seq_check_count)};
    reports = {reports, $sformatf("SEQUENCE CHECK ERROR : %0d \n", cfg.seq_check_error)};
    reports = {reports, $sformatf("SCOREBOARD CHECK COUNT : %0d \n", cfg.scb_check_count)};
    reports = {reports, $sformatf("SCOREBOARD CHECK ERROR : %0d \n", cfg.scb_check_error)};
    reports = {reports, $sformatf("=============================================== \n")};
    `uvm_info("TEST_SUMMARY", reports, UVM_LOW)
  endfunction

endclass

`endif