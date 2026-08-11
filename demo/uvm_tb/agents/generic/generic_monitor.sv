`ifndef GENERIC_MONITOR_SV
`define GENERIC_MONITOR_SV

class generic_monitor extends uvm_monitor;

  generic_config cfg;
  // 请求给参考模型，结果给 scoreboard。
  uvm_analysis_port #(generic_transaction) request_observed_port;
  uvm_analysis_port #(generic_transaction) result_observed_port;

  `uvm_component_utils(generic_monitor)

  function new(string name = "generic_monitor", uvm_component parent);
    super.new(name, parent);
    request_observed_port = new("request_observed_port", this);
    result_observed_port  = new("result_observed_port", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    generic_transaction tr;
    generic_transaction req_tr;
    generic_transaction rsp_tr;
    int unsigned sample_count;

    tr = null;
    sample_count = 0;

    forever begin
      @(cfg.vif.mon_cb);

      if (cfg.vif.rstn !== 1'b1) begin
        tr = null;
        sample_count = 0;
        continue;
      end

      // 从命令握手开始采集一次任务。
      if ((cfg.vif.mon_cb.start === 1'b1) &&
          (cfg.vif.mon_cb.start_ready === 1'b1)) begin
        tr = generic_transaction::type_id::create("tr");
        tr.length = cfg.vif.mon_cb.length;
        tr.result = '0;
        sample_count = 0;
        `uvm_info(get_type_name(),
                  $sformatf("MON: command length=%0d", tr.length),
                  UVM_HIGH)
        if (tr.length == 0) begin
          req_tr = copy_transaction(tr, "request_tr");
          request_observed_port.write(req_tr);
        end
      end

      if ((tr != null) &&
          (cfg.vif.mon_cb.in_valid === 1'b1) &&
          (cfg.vif.mon_cb.in_ready === 1'b1)) begin
        if (sample_count < GENERIC_MAX_N) begin
          tr.a_data[sample_count] = cfg.vif.mon_cb.a_data;
          tr.b_data[sample_count] = cfg.vif.mon_cb.b_data;
        end
        sample_count++;
        if (sample_count == tr.length) begin
          req_tr = copy_transaction(tr, "request_tr");
          request_observed_port.write(req_tr);
        end
      end

      // 结果握手后发送实际输出。
      if ((tr != null) &&
          (cfg.vif.mon_cb.y_valid === 1'b1) &&
          (cfg.vif.mon_cb.y_ready === 1'b1)) begin
        tr.result = cfg.vif.mon_cb.y_data;
        rsp_tr = copy_transaction(tr, "result_tr");
        result_observed_port.write(rsp_tr);
        `uvm_info(get_type_name(),
                  $sformatf("MON: result length=%0d y_data=%0d",
                            tr.length, $signed(tr.result)),
                  UVM_HIGH)
        tr = null;
        sample_count = 0;
      end
    end
  endtask : run_phase

  virtual function generic_transaction copy_transaction(generic_transaction t,
                                                        string name);
    generic_transaction tr_copy;
    tr_copy = generic_transaction::type_id::create(name);
    tr_copy.copy(t);
    return tr_copy;
  endfunction

endclass : generic_monitor

`endif
