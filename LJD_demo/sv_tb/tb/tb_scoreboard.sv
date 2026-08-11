`ifndef TB_SCOREBOARD_SV
`define TB_SCOREBOARD_SV

class tb_scoreboard;
  mailbox #(tb_transaction) mon2scb;

  int unsigned pass_count;
  int unsigned error_count;
  bit          done;
  int          verbose;

  function new(mailbox #(tb_transaction) mon2scb);
    this.mon2scb     = mon2scb;
    this.pass_count  = 0;
    this.error_count = 0;
    this.done        = 0;
    this.verbose     = 0;
  endfunction

  task run();
    tb_transaction tr;

    forever begin
      mon2scb.get(tr);
      if (tr == null) begin
        break;
      end

      if (tr.actual === tr.expected) begin
        pass_count++;
        if (verbose) begin
          $display("[SCB] PASS %s", tr.sprint());
        end
      end else begin
        error_count++;
        $error("[SCB] FAIL %s", tr.sprint());
      end
    end
    done = 1'b1;
  endtask

  function void report();
    $display("");
    $display("===============================================");
    $display("SV TB SUMMARY");
    $display("SCOREBOARD PASS  : %0d", pass_count);
    $display("SCOREBOARD ERROR : %0d", error_count);
    $display("===============================================");
  endfunction
endclass

`endif
