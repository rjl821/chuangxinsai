`ifndef DUT_SMOKE_TEST_SV
`define DUT_SMOKE_TEST_SV

class dut_smoke_test extends dut_base_test;

  `uvm_component_utils(dut_smoke_test)

  function new(string name = "dut_smoke_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    dut_smoke_virt_seq seq;
    super.run_phase(phase);
    phase.raise_objection(this);
    seq = dut_smoke_virt_seq::type_id::create("seq");
    seq.start(env.virt_sqr);
    phase.drop_objection(this);
  endtask

endclass

`endif
