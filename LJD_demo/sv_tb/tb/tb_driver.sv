`ifndef TB_DRIVER_SV
`define TB_DRIVER_SV

class tb_driver;
  virtual dut_if #(.DATA_W(DATA_W)) vif;
  mailbox #(tb_transaction) gen2drv;

  int unsigned sent_count;
  bit          done;
  int          verbose;

  function new(virtual dut_if #(.DATA_W(DATA_W)) vif,
               mailbox #(tb_transaction) gen2drv);
    this.vif        = vif;
    this.gen2drv    = gen2drv;
    this.sent_count = 0;
    this.done       = 0;
    this.verbose    = 0;
  endfunction

  task reset_signals();
    vif.in_valid  <= 1'b0;
    vif.a         <= '0;
    vif.b         <= '0;
    vif.out_ready <= 1'b0;
    wait (vif.rst_n === 1'b1);
    repeat (2) @(vif.drv_cb);
    vif.drv_cb.out_ready <= 1'b1;
  endtask

  task drive_one(tb_transaction tr);
    repeat (tr.idle_cycles) @(vif.drv_cb);

    @(vif.drv_cb);
    vif.drv_cb.a        <= tr.a;
    vif.drv_cb.b        <= tr.b;
    vif.drv_cb.in_valid <= 1'b1;

    do begin
      @(vif.drv_cb);
    end while (vif.drv_cb.in_ready !== 1'b1);

    vif.drv_cb.in_valid <= 1'b0;
    sent_count++;
    if (verbose) begin
      $display("[DRV] Sent %s", tr.sprint());
    end
  endtask

  task run();
    tb_transaction tr;

    reset_signals();
    forever begin
      gen2drv.get(tr);
      if (tr == null) begin
        break;
      end
      drive_one(tr);
    end
    done = 1'b1;
    $display("[DRV] Done: sent=%0d", sent_count);
  endtask
endclass

`endif
