`ifndef DUT_CONFIG_SV
`define DUT_CONFIG_SV

class dut_config extends uvm_object;

  // Virtual interface handle - replace with your own interface
  virtual generic_if generic_vif;

  // Sub-configurations
  generic_config generic_cfg;           // Active agent (driver + monitor)
  // generic_config generic_cfg_passive; // Optional passive agent (monitor only)

  // Check counters
  int scb_check_count;                // Scoreboard comparison pass count
  int scb_check_error;                // Scoreboard comparison fail count
  int seq_check_count;                // Sequence comparison pass count
  int seq_check_error;                // Sequence comparison fail count

  // Feature switches
  bit enable_scb = 1;                 // Enable scoreboard

  // Simulation control
  int unsigned timeout = 1000000;     // Timeout value (in simulation time units)
  int unsigned test_error_count = 0;  // Test error counter
  bit test_is_passed = 1;             // Test pass/fail flag

  `uvm_object_utils(dut_config)

  function new (string name = "dut_config");
    super.new(name);
    generic_cfg = generic_config::type_id::create("generic_cfg");
    // generic_cfg_passive = generic_config::type_id::create("generic_cfg_passive");
  endfunction

endclass

`endif
