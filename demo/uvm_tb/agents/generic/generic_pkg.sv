`ifndef GENERIC_PKG_SV
`define GENERIC_PKG_SV

package generic_pkg;
  import uvm_pkg::*;
  import vector_mac_params_pkg::*;
  `include "uvm_macros.svh"

  localparam int GENERIC_DATA_W = VECTOR_MAC_DATA_W;
  localparam int GENERIC_ACC_W  = VECTOR_MAC_ACC_W;
  localparam int GENERIC_LEN_W  = VECTOR_MAC_LEN_W;
  localparam int GENERIC_MAX_N  = 16;

  `include "generic_config.sv"
  `include "generic_transaction.sv"
  `include "generic_driver.sv"
  `include "generic_monitor.sv"
  `include "generic_sequencer.sv"
  `include "generic_agent.sv"
endpackage : generic_pkg

`endif
