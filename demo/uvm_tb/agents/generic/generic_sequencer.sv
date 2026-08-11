`ifndef GENERIC_SEQUENCER_SV
`define GENERIC_SEQUENCER_SV

class generic_sequencer extends uvm_sequencer #(generic_transaction);

  `uvm_component_utils(generic_sequencer)

  function new(string name = "generic_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : generic_sequencer

`endif
