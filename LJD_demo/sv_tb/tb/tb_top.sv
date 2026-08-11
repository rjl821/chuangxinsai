`timescale 1ns/1ps
`include "tb_defs.svh"

module tb_top;
  import tb_pkg::*;

  logic clk;
  logic rst_n;

  string       testname;
  tb_base_test test;

  dut_if #(.DATA_W(DATA_W)) vif (
    .clk   (clk),
    .rst_n (rst_n)
  );

  sv_dut_dummy #(.DATA_W(DATA_W)) dut (
    .clk       (clk),
    .rst_n     (rst_n),
    .in_valid  (vif.in_valid),
    .in_ready  (vif.in_ready),
    .a         (vif.a),
    .b         (vif.b),
    .out_valid (vif.out_valid),
    .out_ready (vif.out_ready),
    .result    (vif.result)
  );

  initial begin
    clk = 1'b0;
    forever #(`TB_CLK_PERIOD_NS/2.0) clk = ~clk;
  end

  initial begin
    rst_n = 1'b0;
    repeat (`TB_RESET_CYCLES) @(posedge clk);
    rst_n = 1'b1;
  end

  initial begin
    if ($test$plusargs("DUMP")) begin
      $dumpfile("out/sim/tb_top.vcd");
      $dumpvars(0);
    end
  end

  initial begin
    repeat (`TB_TIMEOUT_CYCLES) @(posedge clk);
    $fatal(1, "[TB_TOP] Timeout after %0d cycles", `TB_TIMEOUT_CYCLES);
  end

  initial begin
    testname = "tb_smoke_test";
    void'($value$plusargs("TESTNAME=%s", testname));

    wait (rst_n === 1'b1);
    repeat (2) @(posedge clk);

    test = create_test(testname, vif);
    if (test == null) begin
      $fatal(1, "[TB_TOP] Unknown TESTNAME=%s", testname);
    end

    $display("[TB_TOP] Running TESTNAME=%s", testname);
    test.run();
    $finish;
  end
endmodule
