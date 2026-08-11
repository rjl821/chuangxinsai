`ifndef DUT_SCOREBOARD_SV
`define DUT_SCOREBOARD_SV

`uvm_analysis_imp_decl(_expected)

class dut_scoreboard extends dut_subscriber;

  uvm_analysis_imp_expected #(generic_transaction, dut_scoreboard) expected_imp;
  // 预期和实际按顺序比较。
  generic_transaction expected_q[$];
  generic_transaction output_q[$];

  `uvm_component_utils(dut_scoreboard)

  function new(string name = "dut_scoreboard", uvm_component parent);
    super.new(name, parent);
    expected_imp = new("expected_imp", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  virtual function void write_expected(generic_transaction t);
    expected_q.push_back(copy_transaction(t, "expected_tr"));
    compare_pending();
  endfunction

  virtual function void write_output(generic_transaction t);
    output_q.push_back(copy_transaction(t, "output_tr"));
    compare_pending();
  endfunction

  virtual function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    if ((expected_q.size() != 0) || (output_q.size() != 0)) begin
      cfg.scb_check_error++;
      `uvm_error("SCB_UNMATCHED",
                 $sformatf("Unmatched transactions remain: expected=%0d output=%0d",
                           expected_q.size(), output_q.size()))
    end
  endfunction

  virtual function generic_transaction copy_transaction(generic_transaction t,
                                                        string name);
    generic_transaction tr;
    tr = generic_transaction::type_id::create(name);
    tr.copy(t);
    return tr;
  endfunction

  virtual function void compare_pending();
    generic_transaction exp;
    generic_transaction act;

    while ((expected_q.size() != 0) && (output_q.size() != 0)) begin
      exp = expected_q.pop_front();
      act = output_q.pop_front();
      compare_transaction(exp, act);
    end
  endfunction

  virtual function void compare_transaction(generic_transaction exp,
                                            generic_transaction act);
    cfg.scb_check_count++;

    if (act.result !== exp.result) begin
      cfg.scb_check_error++;
      `uvm_error("SCB_CMP",
                 $sformatf("Output mismatch: length=%0d exp=%0d act=%0d",
                           exp.length, $signed(exp.result), $signed(act.result)))
    end
    else begin
      `uvm_info("SCB_CMP",
                $sformatf("Output matched: length=%0d result=%0d",
                          exp.length, $signed(act.result)),
                UVM_LOW)
    end
  endfunction

endclass

`endif
