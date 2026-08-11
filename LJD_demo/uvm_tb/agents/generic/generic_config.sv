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
// File        : generic_config.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Generic agent configuration.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//
// USAGE: Add your own configuration fields as needed.
//=======================================================================
`ifndef GENERIC_CONFIG_SV
`define GENERIC_CONFIG_SV

class generic_config extends uvm_object;

  // Virtual interface handle
  virtual generic_if vif;

  // Agent role: UVM_ACTIVE (driver+sequencer+monitor) or UVM_PASSIVE (monitor only)
  bit is_active = 1;

  // USER: Add your own configuration fields here

  `uvm_object_utils(generic_config)

  function new(string name = "generic_config");
    super.new(name);
  endfunction : new

endclass : generic_config

`endif