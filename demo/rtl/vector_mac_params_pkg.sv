package vector_mac_params_pkg;
    // Centralized design defaults. Override the module parameters at an
    // instance when a specific integration needs different widths.
    localparam int VECTOR_MAC_DATA_W = 16;
    localparam int VECTOR_MAC_ACC_W  = 40;
    localparam int VECTOR_MAC_LEN_W  = 8;
endpackage
