`ifndef DUT_RW_VIRT_SEQ_SV
`define DUT_RW_VIRT_SEQ_SV

class dut_rw_virt_seq extends dut_base_virtual_sequence;

  `uvm_object_utils(dut_rw_virt_seq)

  function new(string name = "dut_rw_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    int unsigned n;

    super.body();

    `uvm_info(get_type_name(), "Starting vector_mac randomized sequence", UVM_LOW)
    for (int i = 0; i < 12; i++) begin
      n = $urandom_range(0, GENERIC_MAX_N);
      send_vector_case(n, i + 10, $sformatf("random_case_%0d", i));
    end
    wait_cycles(4);
    `uvm_info(get_type_name(), "Randomized sequence completed", UVM_LOW)
  endtask

endclass

`endif
