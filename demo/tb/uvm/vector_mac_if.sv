interface vector_mac_if #(
    parameter int DATA_W = vector_mac_params_pkg::VECTOR_MAC_DATA_W,
    parameter int ACC_W  = vector_mac_params_pkg::VECTOR_MAC_ACC_W,
    parameter int LEN_W  = vector_mac_params_pkg::VECTOR_MAC_LEN_W
) (input logic clk);
    logic                         rst_n;
    logic                         start;
    logic [LEN_W:0]               length;
    logic                         start_ready;
    logic signed [DATA_W-1:0]     a_data;
    logic signed [DATA_W-1:0]     b_data;
    logic                         in_valid;
    logic                         in_ready;
    logic signed [ACC_W-1:0]      y_data;
    logic                         y_valid;
    logic                         y_ready;
    logic                         busy;
endinterface
