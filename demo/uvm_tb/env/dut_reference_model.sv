`ifndef DUT_REFERENCE_MODEL_SV
`define DUT_REFERENCE_MODEL_SV

class dut_reference_model extends dut_subscriber;

  uvm_analysis_port #(generic_transaction) expected_port;

  `uvm_component_utils(dut_reference_model)

  function new(string name = "dut_reference_model", uvm_component parent);
    super.new(name, parent);
    expected_port = new("expected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  virtual function void write_input(generic_transaction t);
    generic_transaction exp;

    exp = generic_transaction::type_id::create("exp");
    exp.copy(t);
    predict(t, exp);

    `uvm_info(get_type_name(),
              $sformatf("REF: length=%0d expected_result=%0d",
                        t.length, $signed(exp.result)),
              UVM_HIGH)
    expected_port.write(exp);
  endfunction

  // 参考模型计算有符号点积。
  virtual function void predict(generic_transaction input_tr,
                                generic_transaction expected_tr);
    longint signed acc;
    longint signed aval;
    longint signed bval;

    acc = 0;
    for (int i = 0; i < input_tr.length; i++) begin
      aval = $signed(input_tr.a_data[i]);
      bval = $signed(input_tr.b_data[i]);
      acc += aval * bval;
    end
    expected_tr.result = acc;
  endfunction

endclass

`endif
