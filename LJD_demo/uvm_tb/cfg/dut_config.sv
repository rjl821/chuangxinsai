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
// File        : dut_config.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Generic UVM configuration object for module-level verification
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//
// USAGE: Replace generic_vif with your own interface handle. Add your own enable_* switches as needed.
//=======================================================================
`ifndef DUT_CONFIG_SV
`define DUT_CONFIG_SV

class dut_config extends uvm_object;

  // Virtual interface handle - replace with your own interface
  virtual generic_if generic_vif;

  // Sub-configurations
  generic_config generic_cfg;           // Active agent (driver + monitor)
  generic_config generic_cfg_passive;   // Passive agent (monitor only)

  // Check counters
  int scb_check_count;                // Scoreboard comparison pass count
  int scb_check_error;                // Scoreboard comparison fail count
  int seq_check_count;                // Sequence comparison pass count
  int seq_check_error;                // Sequence comparison fail count

  // Feature switches
  bit enable_cov = 1;                 // Enable coverage collection
  bit enable_scb = 1;                 // Enable scoreboard

  // Simulation control
  int unsigned timeout = 1000000;     // Timeout value (in simulation time units)
  int unsigned test_error_count = 0;  // Test error counter
  bit test_is_passed = 1;             // Test pass/fail flag

  `uvm_object_utils(dut_config)

  function new (string name = "dut_config");
    super.new(name);
    generic_cfg         = generic_config::type_id::create("generic_cfg");
    generic_cfg_passive = generic_config::type_id::create("generic_cfg_passive");
  endfunction

endclass

`endif