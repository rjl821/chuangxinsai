`ifndef GENERIC_CONFIG_SV
`define GENERIC_CONFIG_SV

class generic_config extends uvm_object;

  // Virtual interface handle
  virtual generic_if vif;

  // Agent role: UVM_ACTIVE (driver+sequencer+monitor) or UVM_PASSIVE (monitor only)
  bit is_active = 1;

  // USER: Add your own configuration fields here

  `uvm_object_utils(generic_config)

  function new(string name = "generic_config");
    super.new(name);
  endfunction : new

endclass : generic_config

`endif
