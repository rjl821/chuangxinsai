`ifndef TB_GENERATOR_SV
`define TB_GENERATOR_SV

class tb_generator;
  mailbox #(tb_transaction) gen2drv;
  int unsigned num_random;
  int unsigned next_id;

  function new(mailbox #(tb_transaction) gen2drv);
    this.gen2drv    = gen2drv;
    this.num_random = `TB_DEFAULT_NUM_TRANS;
    this.next_id    = 0;
  endfunction

  function tb_transaction make_item(data_t a, data_t b, int unsigned idle = 0);
    tb_transaction tr = new(next_id++);
    tr.a           = a;
    tr.b           = b;
    tr.idle_cycles = idle;
    tr.update_expected();
    return tr;
  endfunction

  task send_directed();
    gen2drv.put(make_item('0, '0));
    gen2drv.put(make_item(data_t'(1), data_t'(1)));
    gen2drv.put(make_item({DATA_W{1'b1}}, data_t'(1)));
    gen2drv.put(make_item(data_t'(32'h55aa_0001), data_t'(32'h0000_00ff)));
    gen2drv.put(make_item(data_t'(32'ha5a5_5a5a), data_t'(32'h0101_1010)));
  endtask

  task send_random();
    tb_transaction tr;

    for (int unsigned i = 0; i < num_random; i++) begin
      tr = new(next_id++);
      if (!tr.randomize()) begin
        $fatal(1, "[GEN] Randomization failed at item %0d", i);
      end
      gen2drv.put(tr);
    end
  endtask

  task run();
    $display("[GEN] Start: directed + %0d random transactions", num_random);
    send_directed();
    send_random();
    gen2drv.put(null);
    $display("[GEN] Done: total=%0d", next_id);
  endtask
endclass

`endif
