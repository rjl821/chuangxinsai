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
// File        : generic_if.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Generic interface template for rapid agent development.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//
// USAGE: Replace the placeholder signals below with your own DUT interface signals. Update the clocking blocks to match your protocol timing.
//=======================================================================
`ifndef GENERIC_IF_SV
`define GENERIC_IF_SV

interface generic_if(input logic clk, input logic rstn);

  import generic_pkg::*;

  //=======================================================================
  // USER: Replace these placeholder signals with your own
  //=======================================================================
  logic [31:0] sig_in;     // Input signal from agent
  logic [31:0] sig_out;    // Output signal to agent

  //=======================================================================
  // USER: Define your clocking blocks below
  //=======================================================================
  clocking drv_cb @(posedge clk);
    default input #1ps output #1ps;
    output sig_in;
    input  sig_out;
  endclocking : drv_cb

  clocking mon_cb @(posedge clk);
    default input #1ps output #1ps;
    input sig_in, sig_out;
  endclocking : mon_cb

endinterface : generic_if

`endif