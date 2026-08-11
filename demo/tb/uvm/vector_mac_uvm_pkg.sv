package vector_mac_uvm_pkg;
    import uvm_pkg::*;
    import vector_mac_params_pkg::*;
    `include "uvm_macros.svh"

    localparam int DATA_W = VECTOR_MAC_DATA_W;
    localparam int ACC_W  = VECTOR_MAC_ACC_W;
    localparam int LEN_W  = VECTOR_MAC_LEN_W;
    localparam int MAX_N  = 16;

    class vector_mac_base_test extends uvm_test;
        `uvm_component_utils(vector_mac_base_test)

        virtual vector_mac_if vif;
        int unsigned test_count;
        int unsigned sampled_length;

        covergroup length_cg;
            option.per_instance = 1;
            cp_length: coverpoint sampled_length {
                bins zero     = {0};
                bins one      = {1};
                bins middle[] = {[2:MAX_N-1]};
                bins maximum  = {MAX_N};
            }
        endgroup

        function new(string name = "vector_mac_base_test", uvm_component parent = null);
            super.new(name, parent);
            length_cg = new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db#(virtual vector_mac_if)::get(this, "", "vif", vif)) begin
                `uvm_fatal("NOVIF", "vector_mac_if was not set by tb_vector_mac_uvm")
            end
        endfunction

        task automatic run_case(input int unsigned n, input int case_id);
            logic signed [DATA_W-1:0] vec_a [0:MAX_N-1];
            logic signed [DATA_W-1:0] vec_b [0:MAX_N-1];
            logic signed [ACC_W-1:0] expected;
            bit drive_this_cycle;
            int i;
            int sent;
            int stall_cycles;

            sampled_length = n;
            length_cg.sample();
            expected = '0;
            for (i = 0; i < n; i++) begin
                vec_a[i] = $signed(((i * 7 + case_id * 3) % 31) - 15);
                vec_b[i] = $signed(((i * 5 + case_id * 9) % 27) - 13);
                expected = expected + vec_a[i] * vec_b[i];
            end

            while (!vif.start_ready) @(posedge vif.clk);
            @(negedge vif.clk);
            vif.length = n;
            vif.start  = 1'b1;
            @(negedge vif.clk);
            vif.start  = 1'b0;

            sent = 0;
            while (sent < n) begin
                drive_this_cycle = ($urandom_range(0, 3) != 0);
                if (drive_this_cycle) begin
                    vif.a_data  = vec_a[sent];
                    vif.b_data  = vec_b[sent];
                    vif.in_valid = 1'b1;
                end else begin
                    vif.in_valid = 1'b0;
                end
                @(posedge vif.clk);
                if (vif.in_valid && vif.in_ready) sent++;
                @(negedge vif.clk);
            end
            vif.in_valid = 1'b0;

            wait (vif.y_valid === 1'b1);
            stall_cycles = $urandom_range(1, 4);
            repeat (stall_cycles) @(posedge vif.clk);
            if ($signed(vif.y_data) !== expected) begin
                `uvm_error("MISMATCH", $sformatf(
                    "case=%0d n=%0d expected=%0d actual=%0d",
                    case_id, n, expected, $signed(vif.y_data)))
            end else begin
                `uvm_info("PASS", $sformatf(
                    "case=%0d n=%0d result=%0d", case_id, n, $signed(vif.y_data)),
                    UVM_LOW)
            end
            test_count++;

            @(negedge vif.clk);
            vif.y_ready = 1'b1;
            @(negedge vif.clk);
            vif.y_ready = 1'b0;
        endtask

        task wait_for_reset();
            wait (vif.rst_n === 1'b1);
            @(posedge vif.clk);
        endtask

        function void report_phase(uvm_phase phase);
            uvm_report_server report_server;
            super.report_phase(phase);
            report_server = uvm_report_server::get_server();
            if (report_server.get_severity_count(UVM_ERROR) == 0 &&
                report_server.get_severity_count(UVM_FATAL) == 0) begin
                `uvm_info("TEST", $sformatf("TEST PASS: %0d cases", test_count), UVM_NONE)
            end
        endfunction
    endclass

    class vector_mac_smoke_test extends vector_mac_base_test;
        `uvm_component_utils(vector_mac_smoke_test)

        function new(string name = "vector_mac_smoke_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            phase.raise_objection(this);
            wait_for_reset();
            run_case(0, 0);
            run_case(1, 1);
            run_case(8, 2);
            run_case(MAX_N, 3);
            phase.drop_objection(this);
        endtask
    endclass

    class vector_mac_boundary_test extends vector_mac_base_test;
        `uvm_component_utils(vector_mac_boundary_test)

        function new(string name = "vector_mac_boundary_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            phase.raise_objection(this);
            wait_for_reset();
            run_case(0, 0);
            run_case(1, 1);
            run_case(MAX_N, 2);
            phase.drop_objection(this);
        endtask
    endclass

    class vector_mac_random_test extends vector_mac_base_test;
        `uvm_component_utils(vector_mac_random_test)

        function new(string name = "vector_mac_random_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            phase.raise_objection(this);
            wait_for_reset();
            for (int case_id = 0; case_id < 20; case_id++) begin
                run_case($urandom_range(0, MAX_N), case_id);
            end
            phase.drop_objection(this);
        endtask
    endclass
endpackage
