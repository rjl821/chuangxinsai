`ifndef GENERIC_TRANSACTION_SV
`define GENERIC_TRANSACTION_SV

class generic_transaction extends uvm_sequence_item;

  // 一次 transaction 对应一次点积任务。
  rand int unsigned                         length;
  rand bit signed [GENERIC_DATA_W-1:0]      a_data [GENERIC_MAX_N];
  rand bit signed [GENERIC_DATA_W-1:0]      b_data [GENERIC_MAX_N];
       bit signed [GENERIC_ACC_W-1:0]       result;
  rand int unsigned                         output_stall;

  constraint c_length {
    length <= GENERIC_MAX_N;
  }

  constraint c_output_stall {
    output_stall inside {[0:4]};
  }

  `uvm_object_utils(generic_transaction)

  function new(string name = "generic_transaction");
    super.new(name);
  endfunction : new

  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field("length",       length,       32, UVM_DEC);
    printer.print_field("result",       result, GENERIC_ACC_W, UVM_DEC);
    printer.print_field("output_stall", output_stall, 32, UVM_DEC);
    for (int i = 0; i < GENERIC_MAX_N; i++) begin
      if (i < length) begin
        printer.print_field($sformatf("a_data[%0d]", i), a_data[i], GENERIC_DATA_W, UVM_DEC);
        printer.print_field($sformatf("b_data[%0d]", i), b_data[i], GENERIC_DATA_W, UVM_DEC);
      end
    end
  endfunction : do_print

  // 拷贝数组，避免队列对象被覆盖。
  virtual function void do_copy(uvm_object rhs);
    generic_transaction tr;
    if (!$cast(tr, rhs)) begin
      `uvm_fatal("BADCAST", "do_copy: rhs is not generic_transaction")
    end
    super.do_copy(rhs);
    length       = tr.length;
    result       = tr.result;
    output_stall = tr.output_stall;
    for (int i = 0; i < GENERIC_MAX_N; i++) begin
      a_data[i] = tr.a_data[i];
      b_data[i] = tr.b_data[i];
    end
  endfunction : do_copy

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    generic_transaction tr;
    if (!$cast(tr, rhs)) begin
      `uvm_error("BADCAST", "do_compare: rhs is not generic_transaction")
      return 0;
    end
    if (!super.do_compare(rhs, comparer)) begin
      return 0;
    end
    if ((length != tr.length) || (result !== tr.result)) begin
      return 0;
    end
    for (int i = 0; i < GENERIC_MAX_N; i++) begin
      if ((i < length) &&
          ((a_data[i] !== tr.a_data[i]) || (b_data[i] !== tr.b_data[i]))) begin
        return 0;
      end
    end
    return 1;
  endfunction : do_compare

endclass : generic_transaction

`endif
