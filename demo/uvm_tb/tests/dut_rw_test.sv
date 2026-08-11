`ifndef DUT_RW_TEST_SV
`define DUT_RW_TEST_SV

class dut_rw_test extends dut_base_test;

  `uvm_component_utils(dut_rw_test)

  function new(string name = "dut_rw_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    dut_rw_virt_seq seq;
    super.run_phase(phase);
    phase.raise_objection(this);
    seq = dut_rw_virt_seq::type_id::create("seq");
    seq.start(env.virt_sqr);
    phase.drop_objection(this);
  endtask

endclass

`endif
