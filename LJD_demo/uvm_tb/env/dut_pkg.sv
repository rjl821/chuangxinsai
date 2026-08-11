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
// File        : dut_pkg.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Top-level UVM package for the verification environment.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//
// USAGE: Replace the `include list with your own component files. This file defines the compile-order dependency chain.
//=======================================================================
`ifndef DUT_PKG_SV
`define DUT_PKG_SV

package dut_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import generic_pkg::*;

  // Configuration
  `include "dut_config.sv"

  // Environment components
  `include "dut_subscriber.sv"
  `include "dut_scoreboard.sv"
  `include "dut_cov.sv"
  `include "dut_virtual_sequencer.sv"
  `include "dut_env.sv"

  // Sequence library
  `include "dut_seq_lib.svh"

  // Test library
  `include "dut_tests.svh"

endpackage

`endif