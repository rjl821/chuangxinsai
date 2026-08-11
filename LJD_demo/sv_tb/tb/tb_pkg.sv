`ifndef TB_PKG_SV
`define TB_PKG_SV

package tb_pkg;
  `include "tb_defs.svh"

  localparam int DATA_W = `TB_DATA_W;
  typedef bit   [DATA_W-1:0] data_t;
  typedef logic [DATA_W-1:0] data4_t;

  `include "tb_transaction.sv"
  `include "tb_generator.sv"
  `include "tb_driver.sv"
  `include "tb_monitor.sv"
  `include "tb_scoreboard.sv"
  `include "tb_env.sv"
  `include "tb_tests.sv"
endpackage

`endif
