`timescale 1ns/1ps

// Self-checking testbench.  It deliberately inserts bubbles on the input and
// back-pressure on the output so that the protocol, not only arithmetic, is
// verified.  A contest project should extend this into constrained-random and
// coverage-driven verification when the interface becomes more complicated.
module tb_vector_mac;
    import vector_mac_params_pkg::*;

    localparam int DATA_W = VECTOR_MAC_DATA_W;
    localparam int ACC_W  = VECTOR_MAC_ACC_W;
    localparam int LEN_W  = VECTOR_MAC_LEN_W;
    localparam int MAX_N  = 16;

    logic clk = 1'b0;
    logic rst_n;
    logic start;
    logic [LEN_W:0] length;
    logic start_ready;
    logic signed [DATA_W-1:0] a_data;
    logic signed [DATA_W-1:0] b_data;
    logic in_valid;
    logic in_ready;
    logic signed [ACC_W-1:0] y_data;
    logic y_valid;
    logic y_ready;
    logic busy;

    logic signed [DATA_W-1:0] vec_a [0:MAX_N-1];
    logic signed [DATA_W-1:0] vec_b [0:MAX_N-1];
    logic signed [ACC_W-1:0] expected;
    integer test_count;
    integer error_count;
    integer cycle_count;
    integer seed;
    integer random_case;
    real    clock_period_ns;
    string  fsdb_file;
    string  test_name;

    covergroup length_cg with function sample(int sampled_length);
        option.per_instance = 1;
        cp_length: coverpoint sampled_length {
            bins zero     = {0};
            bins one      = {1};
            bins middle[] = {[2:MAX_N-1]};
            bins maximum  = {MAX_N};
        }
    endgroup

    length_cg length_cov = new();

    // Makefile passes the same CLOCK_PERIOD_NS to simulation and DC, so changing
    // one Makefile variable keeps the testbench clock and SDC clock consistent.
    initial begin
        if (!$value$plusargs("CLOCK_PERIOD_NS=%f", clock_period_ns)) begin
            clock_period_ns = 10.0;
        end
        forever #(clock_period_ns / 2.0) clk = ~clk;
    end

    vector_mac #(
        .DATA_W(DATA_W),
        .ACC_W (ACC_W),
        .LEN_W (LEN_W)
    ) dut (
        .clk,
        .rst_n,
        .start,
        .length,
        .start_ready,
        .a_data,
        .b_data,
        .in_valid,
        .in_ready,
        .y_data,
        .y_valid,
        .y_ready,
        .busy
    );

    // The Makefile links the Verdi PLI. The plusarg keeps the output location
    // configurable and avoids writing generated data in rtl/.
    initial begin
        if (!$value$plusargs("FSDB=%s", fsdb_file)) begin
            fsdb_file = "vector_mac.fsdb";
        end
        $fsdbDumpfile(fsdb_file);
        $fsdbDumpvars(0, tb_vector_mac);
    end

    // Verify one task. Values are generated deterministically from case_id;
    // the reference result is calculated before any RTL transaction occurs.
    task automatic run_case(input integer n, input integer case_id);
        integer i;
        integer sent;
        integer stall_cycles;
        logic drive_this_cycle;
        begin
            length_cov.sample(n);
            expected = '0;
            for (i = 0; i < n; i = i + 1) begin
                // Small signed operands make waveform inspection convenient.
                vec_a[i] = $signed(((i * 7 + case_id * 3) % 31) - 15);
                vec_b[i] = $signed(((i * 5 + case_id * 9) % 27) - 13);
                expected = expected + vec_a[i] * vec_b[i];
            end

            while (!start_ready) @(posedge clk);
            @(negedge clk);
            length = n;
            start  = 1'b1;
            @(negedge clk);
            start  = 1'b0;

            // Randomly leave input cycles empty. Data remains stable for a
            // complete cycle whenever valid is asserted.
            sent = 0;
            while (sent < n) begin
                drive_this_cycle = ($urandom_range(0, 3) != 0);
                if (drive_this_cycle) begin
                    a_data  = vec_a[sent];
                    b_data  = vec_b[sent];
                    in_valid = 1'b1;
                end else begin
                    in_valid = 1'b0;
                end
                @(posedge clk);
                if (in_valid && in_ready) sent = sent + 1;
                @(negedge clk);
            end
            in_valid = 1'b0;

            // Hold result acceptance low for 1..4 cycles. The assertions below
            // check that valid and data remain stable throughout this stall.
            wait (y_valid === 1'b1);
            stall_cycles = $urandom_range(1, 4);
            repeat (stall_cycles) @(posedge clk);

            if ($signed(y_data) !== expected) begin
                $error("case %0d failed: n=%0d expected=%0d actual=%0d",
                       case_id, n, expected, $signed(y_data));
                error_count = error_count + 1;
            end else begin
                $display("[PASS] case=%0d length=%0d result=%0d",
                         case_id, n, $signed(y_data));
            end
            test_count = test_count + 1;

            @(negedge clk);
            y_ready = 1'b1;
            @(negedge clk);
            y_ready = 1'b0;
        end
    endtask

    // Protocol properties are especially valuable when the algorithm is
    // replaced: they protect interface behavior during datapath refactoring.
    property p_result_stable_when_stalled;
        @(posedge clk) disable iff (!rst_n)
        y_valid && !y_ready |=> y_valid && $stable(y_data);
    endproperty
    assert property (p_result_stable_when_stalled)
        else $error("result changed while output was stalled");

    property p_busy_when_result_valid;
        @(posedge clk) disable iff (!rst_n) y_valid |-> busy;
    endproperty
    assert property (p_busy_when_result_valid)
        else $error("busy must cover the result state");

    always @(posedge clk) begin
        cycle_count <= cycle_count + 1;
        if (cycle_count > 2000) $fatal(1, "simulation timeout");
    end

    initial begin
        if (!$value$plusargs("ntb_random_seed=%d", seed)) seed = 2026;
        if (!$value$plusargs("TEST_NAME=%s", test_name)) begin
            test_name = "sv_smoke_test";
        end
        void'($urandom(seed));

        rst_n       = 1'b0;
        start       = 1'b0;
        length      = '0;
        a_data      = '0;
        b_data      = '0;
        in_valid    = 1'b0;
        y_ready     = 1'b0;
        test_count  = 0;
        error_count = 0;
        cycle_count = 0;

        repeat (4) @(posedge clk);
        @(negedge clk);
        rst_n = 1'b1;

        $display("Running TEST_NAME=%s SEED=%0d", test_name, seed);
        case (test_name)
            "sv_smoke_test": begin
                run_case(0, 0);
                run_case(1, 1);
                run_case(8, 2);
                run_case(16, 3);
            end
            "sv_boundary_test": begin
                run_case(0, 0);
                run_case(1, 1);
                run_case(MAX_N, 2);
            end
            "sv_random_test": begin
                for (random_case = 0; random_case < 20; random_case++) begin
                    run_case($urandom_range(0, MAX_N), random_case);
                end
            end
            default: begin
                $fatal(1, "Unknown TEST_NAME=%s; valid tests: sv_smoke_test, sv_boundary_test, sv_random_test", test_name);
            end
        endcase

        if (error_count == 0) begin
            $display("TEST PASS: %0d/%0d cases passed", test_count, test_count);
        end else begin
            $fatal(1, "TEST FAIL: %0d errors in %0d cases", error_count, test_count);
        end
        #20;
        $finish;
    end

endmodule
