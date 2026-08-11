`ifndef DUT_PKG_SV
`define DUT_PKG_SV

package dut_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import generic_pkg::*;

  // Configuration
  `include "dut_config.sv"

  // Environment components
  `include "dut_subscriber.sv"
  `include "dut_reference_model.sv"
  `include "dut_scoreboard.sv"
  `include "dut_virtual_sequencer.sv"
  `include "dut_env.sv"

  // Sequence library
  `include "dut_seq_lib.svh"

  // Test library
  `include "dut_tests.svh"

endpackage

`endif
