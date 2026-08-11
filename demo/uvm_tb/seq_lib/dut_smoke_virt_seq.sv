`ifndef DUT_SMOKE_VIRT_SEQ_SV
`define DUT_SMOKE_VIRT_SEQ_SV

class dut_smoke_virt_seq extends dut_base_virtual_sequence;

  `uvm_object_utils(dut_smoke_virt_seq)

  function new(string name = "dut_smoke_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    super.body();

    `uvm_info(get_type_name(), "Starting vector_mac smoke sequence", UVM_LOW)
    send_vector_case(0,             0, "smoke_len0");
    send_vector_case(1,             1, "smoke_len1");
    send_vector_case(8,             2, "smoke_len8");
    send_vector_case(GENERIC_MAX_N, 3, "smoke_len_max");
    wait_cycles(4);
    `uvm_info(get_type_name(), "Smoke test completed", UVM_LOW)
  endtask

endclass

`endif
