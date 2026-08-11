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
// File        : generic_sequencer.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Generic sequencer - minimal, no user changes needed.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//=======================================================================
`ifndef GENERIC_SEQUENCER_SV
`define GENERIC_SEQUENCER_SV

class generic_sequencer extends uvm_sequencer #(generic_transaction);

  `uvm_component_utils(generic_sequencer)

  function new(string name = "generic_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : generic_sequencer

`endif