`ifndef DUT_VIRTUAL_SEQUENCER_SV
`define DUT_VIRTUAL_SEQUENCER_SV

class dut_virtual_sequencer extends uvm_sequencer;

  dut_config cfg;
  generic_sequencer generic_sqr;

  // USER: Add your own agent sequencer handles here

  `uvm_component_utils(dut_virtual_sequencer)

  function new (string name = "dut_virtual_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(dut_config)::get(this,"","cfg", cfg)) begin
      `uvm_fatal("GETCFG","cannot get config object from config DB")
    end
  endfunction

endclass

`endif
