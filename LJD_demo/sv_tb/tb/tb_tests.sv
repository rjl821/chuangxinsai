`ifndef TB_TESTS_SV
`define TB_TESTS_SV

class tb_base_test;
  virtual dut_if #(.DATA_W(DATA_W)) vif;
  tb_env env;

  function new(virtual dut_if #(.DATA_W(DATA_W)) vif);
    this.vif = vif;
  endfunction

  virtual task run();
    env = new(vif);
    env.run();
  endtask
endclass

class tb_smoke_test extends tb_base_test;
  function new(virtual dut_if #(.DATA_W(DATA_W)) vif);
    super.new(vif);
  endfunction
endclass

class tb_directed_test extends tb_base_test;
  function new(virtual dut_if #(.DATA_W(DATA_W)) vif);
    super.new(vif);
  endfunction

  virtual task run();
    env = new(vif);
    env.gen.num_random = 0;
    env.run();
  endtask
endclass

function tb_base_test create_test(string testname,
                                  virtual dut_if #(.DATA_W(DATA_W)) vif);
  tb_smoke_test    smoke;
  tb_directed_test directed;

  case (testname)
    "tb_smoke_test": begin
      smoke = new(vif);
      return smoke;
    end
    "tb_directed_test": begin
      directed = new(vif);
      return directed;
    end
    default: begin
      return null;
    end
  endcase
endfunction

`endif
