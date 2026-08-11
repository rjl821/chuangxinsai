`ifndef DUT_BASE_VIRTUAL_SEQUENCE_SV
`define DUT_BASE_VIRTUAL_SEQUENCE_SV

class dut_base_virtual_sequence extends uvm_sequence;

  dut_config cfg;
  virtual generic_if generic_vif;

  `uvm_object_utils(dut_base_virtual_sequence)
  `uvm_declare_p_sequencer(dut_virtual_sequencer)

  function new(string name = "dut_base_virtual_sequence");
    super.new(name);
  endfunction

  virtual task get_config();
    cfg = p_sequencer.cfg;
    generic_vif = cfg.generic_vif;
  endtask

  virtual task wait_reset_signal_assertted();
    @(negedge generic_vif.rstn);
  endtask

  virtual task wait_reset_signal_released();
    @(posedge generic_vif.rstn);
  endtask

  virtual task wait_cycles(int num = 1);
    repeat(num) @(posedge generic_vif.clk);
  endtask

  virtual task wait_ready_for_stim();
    if (generic_vif.rstn !== 1'b1) begin
      wait_reset_signal_released();
    end
    repeat(4) @(posedge generic_vif.clk);
    `uvm_info(get_type_name(), "Ready for stimulus", UVM_LOW)
  endtask

  // 构造可复现输入向量。
  virtual function void fill_case(generic_transaction tr,
                                  int unsigned n,
                                  int unsigned case_id);
    tr.length = n;
    tr.result = '0;
    tr.output_stall = case_id % 4;
    for (int i = 0; i < GENERIC_MAX_N; i++) begin
      tr.a_data[i] = '0;
      tr.b_data[i] = '0;
    end
    for (int i = 0; i < n; i++) begin
      tr.a_data[i] = $signed(((i * 7 + case_id * 3) % 31) - 15);
      tr.b_data[i] = $signed(((i * 5 + case_id * 9) % 27) - 13);
    end
  endfunction

  // 发送一次完整点积任务。
  virtual task send_vector_case(int unsigned n,
                                int unsigned case_id,
                                string name = "vector_case");
    generic_transaction tr;

    tr = generic_transaction::type_id::create(name);
    start_item(tr, -1, p_sequencer.generic_sqr);
    fill_case(tr, n, case_id);
    finish_item(tr);
    cfg.seq_check_count++;
    `uvm_info(get_type_name(),
              $sformatf("Sent case=%0d length=%0d", case_id, n),
              UVM_LOW)
  endtask

  virtual task body();
    get_config();
    wait_ready_for_stim();
  endtask

endclass

`endif
