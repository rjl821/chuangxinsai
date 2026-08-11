`ifndef DUT_ENV_SV
`define DUT_ENV_SV

class dut_env extends uvm_env;

  dut_config cfg;
  dut_virtual_sequencer virt_sqr;
  generic_agent generic_agt;
  dut_reference_model ref_model;
  dut_scoreboard scb;

  `uvm_component_utils(dut_env)

  function new (string name = "dut_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(dut_config)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal("GETCFG","cannot get config object from config DB")
    end

    // 当前使用一个主动 agent。
    cfg.generic_cfg.is_active = 1;

    uvm_config_db#(dut_config)::set(this, "virt_sqr", "cfg", cfg);
    uvm_config_db#(dut_config)::set(this, "ref_model", "cfg", cfg);
    uvm_config_db#(dut_config)::set(this, "scb", "cfg", cfg);
    uvm_config_db#(generic_config)::set(this, "generic_agt", "cfg", cfg.generic_cfg);

    virt_sqr = dut_virtual_sequencer::type_id::create("virt_sqr", this);
    generic_agt = generic_agent::type_id::create("generic_agt", this);
    ref_model = dut_reference_model::type_id::create("ref_model", this);
    scb = dut_scoreboard::type_id::create("scb", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // 连接序列、参考模型和 scoreboard。
    virt_sqr.generic_sqr = generic_agt.sequencer;
    generic_agt.monitor.request_observed_port.connect(ref_model.input_imp);
    ref_model.expected_port.connect(scb.expected_imp);
    generic_agt.monitor.result_observed_port.connect(scb.output_imp);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_type_name(), "end_of_elaboration phase entered", UVM_HIGH)
    `uvm_info(get_type_name(), "end_of_elaboration phase exited", UVM_HIGH)
  endfunction

  function void report_phase(uvm_phase phase);
    string reports = "\n";
    super.report_phase(phase);
    reports = {reports, $sformatf("=============================================== \n")};
    reports = {reports, $sformatf("CURRENT TEST SUMMARY \n")};
    reports = {reports, $sformatf("SEQUENCE CHECK COUNT : %0d \n", cfg.seq_check_count)};
    reports = {reports, $sformatf("SEQUENCE CHECK ERROR : %0d \n", cfg.seq_check_error)};
    reports = {reports, $sformatf("SCOREBOARD CHECK COUNT : %0d \n", cfg.scb_check_count)};
    reports = {reports, $sformatf("SCOREBOARD CHECK ERROR : %0d \n", cfg.scb_check_error)};
    reports = {reports, $sformatf("=============================================== \n")};
    `uvm_info("TEST_SUMMARY", reports, UVM_LOW)
  endfunction

endclass

`endif
