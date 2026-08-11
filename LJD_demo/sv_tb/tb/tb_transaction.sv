`ifndef TB_TRANSACTION_SV
`define TB_TRANSACTION_SV

class tb_transaction;
  rand data_t       a;
  rand data_t       b;
  rand int unsigned idle_cycles;

  int unsigned id;
  data_t       expected;
  data4_t      actual;

  constraint c_idle_cycles {
    idle_cycles inside {[0:3]};
  }

  function new(int unsigned id = 0);
    this.id          = id;
    this.a           = '0;
    this.b           = '0;
    this.expected    = '0;
    this.actual      = 'x;
    this.idle_cycles = 0;
  endfunction

  virtual function data_t calc_expected(data_t lhs, data_t rhs);
    return lhs + rhs;
  endfunction

  function void post_randomize();
    expected = calc_expected(a, b);
  endfunction

  function void update_expected();
    expected = calc_expected(a, b);
  endfunction

  function tb_transaction clone();
    tb_transaction tr = new(id);
    tr.a           = a;
    tr.b           = b;
    tr.idle_cycles = idle_cycles;
    tr.expected    = expected;
    tr.actual      = actual;
    return tr;
  endfunction

  function string sprint();
    return $sformatf("id=%0d a=0x%0h b=0x%0h exp=0x%0h act=0x%0h idle=%0d",
                     id, a, b, expected, actual, idle_cycles);
  endfunction
endclass

`endif
