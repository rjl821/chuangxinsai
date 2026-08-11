`ifndef DUT_SUBSCRIBER_SV
`define DUT_SUBSCRIBER_SV

`uvm_analysis_imp_decl(_input)
`uvm_analysis_imp_decl(_output)

class dut_subscriber extends uvm_component;

  //---------------------------------------------------------------------------
  // USER: Declare one _decl macro per analysis port suffix.
  //       Name the port after the data source (e.g. _apb, _sram, _dma).
  //---------------------------------------------------------------------------

  //---------------------------------------------------------------------------
  // USER: Declare one analysis imp per data source.
  //       Use matching suffix for the write function name.
  //---------------------------------------------------------------------------
  uvm_analysis_imp_input #(generic_transaction, dut_subscriber) input_imp;
  uvm_analysis_imp_output #(generic_transaction, dut_subscriber) output_imp;

  dut_config cfg;

  `uvm_component_utils(dut_subscriber)

  function new(string name = "dut_subscriber", uvm_component parent);
    super.new(name, parent);
    input_imp  = new("input_imp", this);
    output_imp = new("output_imp", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(dut_config)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal("GETCFG", "cannot get config object from config DB")
    end
  endfunction

  //---------------------------------------------------------------------------
  // USER: Implement write_*() for each port. Override in child classes.
  //       Default implementation is empty (no-op).
  //---------------------------------------------------------------------------
  virtual function void write_input(generic_transaction t);
    // Default: no-op. Override in child class.
  endfunction

  virtual function void write_output(generic_transaction t);
    // Default: no-op. Override in child class.
  endfunction

endclass

`endif
