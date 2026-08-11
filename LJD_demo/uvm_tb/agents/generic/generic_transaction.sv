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
// File        : generic_transaction.sv
// Created     : 2026-02-05
// Version     : 1.0
//
// Description : Generic transaction template.
//
// Revision History:
// Date       Version      Change Description
// ----------------------------------------------------------------------
//          |            |                 
//
// USAGE: Replace the placeholder fields below with your own data members. Update do_print/do_copy/do_compare to match your new fields.
//=======================================================================
`ifndef GENERIC_TRANSACTION_SV
`define GENERIC_TRANSACTION_SV

class generic_transaction extends uvm_sequence_item;

  //=======================================================================
  // USER: Replace these placeholder fields with your own
  //=======================================================================
  rand bit [31:0] data_in;    // Input data (driven to DUT)
       bit [31:0] data_out;   // Output data (sampled from DUT)

  `uvm_object_utils(generic_transaction)

  function new(string name = "generic_transaction");
    super.new(name);
  endfunction : new

  //-----------------------------------------------------------------------
  // do_print
  //-----------------------------------------------------------------------
  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field("data_in",  data_in,  32, UVM_HEX);
    printer.print_field("data_out", data_out, 32, UVM_HEX);
  endfunction : do_print

  //-----------------------------------------------------------------------
  // do_copy
  //-----------------------------------------------------------------------
  virtual function void do_copy(uvm_object rhs);
    generic_transaction tr;
    if (!$cast(tr, rhs)) begin
      `uvm_fatal("BADCAST", "do_copy: rhs is not generic_transaction")
    end
    super.do_copy(rhs);
    data_in  = tr.data_in;
    data_out = tr.data_out;
  endfunction : do_copy

  //-----------------------------------------------------------------------
  // do_compare
  //-----------------------------------------------------------------------
  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    generic_transaction tr;
    if (!$cast(tr, rhs)) begin
      `uvm_error("BADCAST", "do_compare: rhs is not generic_transaction")
      return 0;
    end
    return (super.do_compare(rhs, comparer) &&
            (data_in  === tr.data_in)  &&
            (data_out === tr.data_out));
  endfunction : do_compare

endclass : generic_transaction

`endif