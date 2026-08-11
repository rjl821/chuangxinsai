`timescale 1ns/1ps

module tb_vector_mac_uvm;
    import uvm_pkg::*;
    import vector_mac_params_pkg::*;
    import vector_mac_uvm_pkg::*;

    logic clk = 1'b0;
    real clock_period_ns;
    string fsdb_file;

    initial begin
        if (!$value$plusargs("CLOCK_PERIOD_NS=%f", clock_period_ns)) begin
            clock_period_ns = 10.0;
        end
        forever #(clock_period_ns / 2.0) clk = ~clk;
    end

    vector_mac_if vif (.clk(clk));

    vector_mac #(
        .DATA_W(VECTOR_MAC_DATA_W),
        .ACC_W (VECTOR_MAC_ACC_W),
        .LEN_W (VECTOR_MAC_LEN_W)
    ) dut (
        .clk         (clk),
        .rst_n       (vif.rst_n),
        .start       (vif.start),
        .length      (vif.length),
        .start_ready (vif.start_ready),
        .a_data      (vif.a_data),
        .b_data      (vif.b_data),
        .in_valid    (vif.in_valid),
        .in_ready    (vif.in_ready),
        .y_data      (vif.y_data),
        .y_valid     (vif.y_valid),
        .y_ready     (vif.y_ready),
        .busy        (vif.busy)
    );

    initial begin
        vif.rst_n    = 1'b0;
        vif.start    = 1'b0;
        vif.length   = '0;
        vif.a_data   = '0;
        vif.b_data   = '0;
        vif.in_valid = 1'b0;
        vif.y_ready  = 1'b0;
        repeat (4) @(posedge clk);
        @(negedge clk);
        vif.rst_n = 1'b1;
    end

    initial begin
        if (!$value$plusargs("FSDB=%s", fsdb_file)) begin
            fsdb_file = "vector_mac_uvm.fsdb";
        end
        $fsdbDumpfile(fsdb_file);
        $fsdbDumpvars(0, tb_vector_mac_uvm);
    end

    initial begin
        uvm_config_db#(virtual vector_mac_if)::set(null, "uvm_test_top", "vif", vif);
        run_test();
    end

    property p_result_stable_when_stalled;
        @(posedge clk) disable iff (!vif.rst_n)
        vif.y_valid && !vif.y_ready |=> vif.y_valid && $stable(vif.y_data);
    endproperty
    assert property (p_result_stable_when_stalled)
        else `uvm_error("PROTOCOL", "result changed while output was stalled")

    property p_busy_when_result_valid;
        @(posedge clk) disable iff (!vif.rst_n) vif.y_valid |-> vif.busy;
    endproperty
    assert property (p_busy_when_result_valid)
        else `uvm_error("PROTOCOL", "busy must cover the result state")

    initial begin
        #20000ns;
        `uvm_fatal("TIMEOUT", "simulation exceeded 20000 ns")
    end
endmodule
