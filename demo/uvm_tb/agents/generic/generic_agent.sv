`ifndef GENERIC_AGENT_SV
`define GENERIC_AGENT_SV

class generic_agent extends uvm_agent;

  generic_config       cfg;
  generic_driver       driver;
  generic_monitor      monitor;
  generic_sequencer    sequencer;

  `uvm_component_utils(generic_agent)

  function new(string name = "generic_agent", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(generic_config)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal("GETCFG", "Cannot get generic_config from config DB")
    end
    monitor = generic_monitor::type_id::create("monitor", this);
    monitor.cfg = cfg;
    if (cfg.is_active) begin
      driver    = generic_driver::type_id::create("driver", this);
      sequencer = generic_sequencer::type_id::create("sequencer", this);
      driver.cfg = cfg;
    end
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (cfg.is_active) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass : generic_agent

`endif
