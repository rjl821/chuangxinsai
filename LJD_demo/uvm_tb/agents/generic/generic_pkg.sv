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
// File        : generic_pkg.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Generic agent package - includes all generic agent files.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//
// USAGE: No changes needed. Add includes if you add new agent files.
//=======================================================================
`ifndef GENERIC_PKG_SV
`define GENERIC_PKG_SV

package generic_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "generic_config.sv"
  `include "generic_transaction.sv"
  `include "generic_driver.sv"
  `include "generic_monitor.sv"
  `include "generic_sequencer.sv"
  `include "generic_agent.sv"
endpackage : generic_pkg

`endif