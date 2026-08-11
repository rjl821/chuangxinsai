`ifndef TB_MONITOR_SV
`define TB_MONITOR_SV

class tb_monitor;
  virtual dut_if #(.DATA_W(DATA_W)) vif;
  mailbox #(tb_transaction) mon2scb;

  tb_transaction req_q[$];
  int unsigned   observed_count;
  int unsigned   error_count;
  int            verbose;

  function new(virtual dut_if #(.DATA_W(DATA_W)) vif,
               mailbox #(tb_transaction) mon2scb);
    this.vif            = vif;
    this.mon2scb        = mon2scb;
    this.observed_count = 0;
    this.error_count    = 0;
    this.verbose        = 0;
  endfunction

  task run();
    tb_transaction tr;

    wait (vif.rst_n === 1'b1);
    forever begin
      @(vif.mon_cb);
      if (vif.rst_n !== 1'b1) begin
        req_q.delete();
      end else begin
        if (vif.mon_cb.in_valid && vif.mon_cb.in_ready) begin
          tr = new(observed_count + req_q.size());
          tr.a = vif.mon_cb.a;
          tr.b = vif.mon_cb.b;
          tr.update_expected();
          req_q.push_back(tr);
        end

        if (vif.mon_cb.out_valid && vif.mon_cb.out_ready) begin
          if (req_q.size() == 0) begin
            error_count++;
            $error("[MON] Output handshake without pending request. result=0x%0h",
                   vif.mon_cb.result);
          end else begin
            tr = req_q.pop_front();
            tr.actual = vif.mon_cb.result;
            mon2scb.put(tr);
            observed_count++;
            if (verbose) begin
              $display("[MON] Observed %s", tr.sprint());
            end
          end
        end
      end
    end
  endtask
endclass

`endif
