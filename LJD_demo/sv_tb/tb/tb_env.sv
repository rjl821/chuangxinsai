`ifndef TB_ENV_SV
`define TB_ENV_SV

class tb_env;
  virtual dut_if #(.DATA_W(DATA_W)) vif;

  mailbox #(tb_transaction) gen2drv;
  mailbox #(tb_transaction) mon2scb;

  tb_generator  gen;
  tb_driver     drv;
  tb_monitor    mon;
  tb_scoreboard scb;

  function new(virtual dut_if #(.DATA_W(DATA_W)) vif);
    int plus_num;
    int plus_verbose;

    this.vif = vif;

    gen2drv = new();
    mon2scb = new();

    gen = new(gen2drv);
    drv = new(vif, gen2drv);
    mon = new(vif, mon2scb);
    scb = new(mon2scb);

    if ($value$plusargs("NUM_TRANS=%d", plus_num)) begin
      if (plus_num < 0) begin
        $fatal(1, "[ENV] NUM_TRANS must be >= 0, got %0d", plus_num);
      end
      gen.num_random = plus_num;
    end

    if ($value$plusargs("VERBOSE=%d", plus_verbose)) begin
      drv.verbose = plus_verbose;
      mon.verbose = plus_verbose;
      scb.verbose = plus_verbose;
    end
  endfunction

  task run();
    $display("[ENV] Run start");

    fork
      gen.run();
      drv.run();
      mon.run();
      scb.run();
    join_none

    wait (drv.done);
    wait (mon.observed_count == drv.sent_count);
    mon2scb.put(null);
    wait (scb.done);

    disable fork;

    scb.report();
    if ((scb.error_count + mon.error_count) != 0) begin
      $display("");
      $display("TEST_REPORT :: FAILED");
      $fatal(1, "[ENV] Test failed: monitor_error=%0d scoreboard_error=%0d",
             mon.error_count, scb.error_count);
    end else begin
      $display("");
      $display("TEST_REPORT :: PASSED");
    end
  endtask
endclass

`endif
