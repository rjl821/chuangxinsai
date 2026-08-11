`ifndef GENERIC_DRIVER_SV
`define GENERIC_DRIVER_SV

class generic_driver extends uvm_driver #(generic_transaction);

  generic_config cfg;

  `uvm_component_utils(generic_driver)

  function new(string name = "generic_driver", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

  // 按 DUT 协议驱动命令、数据和结果握手。
  virtual task run_phase(uvm_phase phase);
    cfg.vif.drv_cb.start    <= 1'b0;
    cfg.vif.drv_cb.length   <= '0;
    cfg.vif.drv_cb.a_data   <= '0;
    cfg.vif.drv_cb.b_data   <= '0;
    cfg.vif.drv_cb.in_valid <= 1'b0;
    cfg.vif.drv_cb.y_ready  <= 1'b0;

    forever begin
      seq_item_port.get_next_item(req);
      @(cfg.vif.drv_cb);

      while (cfg.vif.rstn !== 1'b1) begin
        @(cfg.vif.drv_cb);
      end

      while (cfg.vif.drv_cb.start_ready !== 1'b1) begin
        @(cfg.vif.drv_cb);
      end

      cfg.vif.drv_cb.length <= req.length[GENERIC_LEN_W:0];
      cfg.vif.drv_cb.start  <= 1'b1;
      @(cfg.vif.drv_cb);
      cfg.vif.drv_cb.start  <= 1'b0;

      for (int i = 0; i < req.length; i++) begin
        cfg.vif.drv_cb.a_data   <= req.a_data[i];
        cfg.vif.drv_cb.b_data   <= req.b_data[i];
        cfg.vif.drv_cb.in_valid <= 1'b1;
        do begin
          @(cfg.vif.drv_cb);
        end while (cfg.vif.drv_cb.in_ready !== 1'b1);
      end
      cfg.vif.drv_cb.in_valid <= 1'b0;

      while (cfg.vif.drv_cb.y_valid !== 1'b1) begin
        @(cfg.vif.drv_cb);
      end
      repeat (req.output_stall) begin
        @(cfg.vif.drv_cb);
      end
      cfg.vif.drv_cb.y_ready <= 1'b1;
      @(cfg.vif.drv_cb);
      cfg.vif.drv_cb.y_ready <= 1'b0;

      `uvm_info(get_type_name(),
                $sformatf("DRV: length=%0d result_accepted=0x%010h",
                          req.length, cfg.vif.drv_cb.y_data),
                UVM_MEDIUM)
      seq_item_port.item_done();
    end
  endtask : run_phase

endclass : generic_driver

`endif
