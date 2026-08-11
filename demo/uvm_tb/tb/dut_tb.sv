`ifndef DUT_TB_SV
`define DUT_TB_SV

module dut_tb;

  import uvm_pkg::*;
  import vector_mac_params_pkg::*;
  import dut_pkg::*;

  logic clk;
  logic rstn;
  
  string  fsdb_file;

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    rstn = 0;
    repeat(10) @(posedge clk);
    rstn = 1;
    @(posedge clk);
  end

  // interface 连接 UVM 环境和 RTL。
  generic_if generic_if_inst(.clk(clk), .rstn(rstn));

  vector_mac #(
    .DATA_W(VECTOR_MAC_DATA_W),
    .ACC_W (VECTOR_MAC_ACC_W),
    .LEN_W (VECTOR_MAC_LEN_W)
  ) dut (
    .clk         (clk),
    .rst_n       (rstn),
    .start       (generic_if_inst.start),
    .length      (generic_if_inst.length),
    .start_ready (generic_if_inst.start_ready),
    .a_data      (generic_if_inst.a_data),
    .b_data      (generic_if_inst.b_data),
    .in_valid    (generic_if_inst.in_valid),
    .in_ready    (generic_if_inst.in_ready),
    .y_data      (generic_if_inst.y_data),
    .y_valid     (generic_if_inst.y_valid),
    .y_ready     (generic_if_inst.y_ready),
    .busy        (generic_if_inst.busy)
  );

  initial begin
    // 将 virtual interface 注入配置库。
    uvm_config_db#(virtual generic_if)::set(uvm_root::get(), "uvm_test_top", "generic_vif", generic_if_inst);
    uvm_config_db#(virtual generic_if)::set(uvm_root::get(), "uvm_test_top.env.generic_agt", "vif", generic_if_inst);
    run_test();
  end

  property p_result_stable_when_stalled;
    @(posedge clk) disable iff (!rstn)
    generic_if_inst.y_valid && !generic_if_inst.y_ready |=>
      generic_if_inst.y_valid && $stable(generic_if_inst.y_data);
  endproperty
  assert property (p_result_stable_when_stalled)
    else `uvm_error("PROTOCOL", "result changed while output was stalled")

  property p_busy_when_result_valid;
    @(posedge clk) disable iff (!rstn)
    generic_if_inst.y_valid |-> generic_if_inst.busy;
  endproperty
  assert property (p_busy_when_result_valid)
    else `uvm_error("PROTOCOL", "busy must cover the result state")
  
    initial begin
        if (!$value$plusargs("FSDB=%s", fsdb_file)) begin
            fsdb_file = "DUT.fsdb";
        end
        $fsdbDumpfile(fsdb_file);
        $fsdbDumpvars(0, dut_tb);
    end
  
endmodule

`endif
