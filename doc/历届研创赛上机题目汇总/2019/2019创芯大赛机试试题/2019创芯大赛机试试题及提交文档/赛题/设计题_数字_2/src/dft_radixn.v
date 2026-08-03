
//  File:  dft_radixn.v
`timescale 1ns / 100ps
module dft_radixn
    (
		input               rst_n                   ,
		input               clk                     ,
		//input mode
        input [1:0]         m_mode                  ,
        //input data and valid indicator
		input               dv_i                    ,
		input [7:0]         y_re                    ,
		input [7:0]         y_im                    ,
		input [7:0]         z_re                    ,
		input [7:0]         z_im                    ,
		input [7:0]         q_re                    ,
		input [7:0]         q_im                    ,
		input [7:0]         r_re                    ,
		input [7:0]         r_im                    ,
		input [7:0]         s_re                    ,
		input [7:0]         s_im                    ,
		input [7:0]         w_n_1k_re               ,
		input [7:0]         w_n_1k_im               ,
		input [7:0]         w_n_2k_re               ,
		input [7:0]         w_n_2k_im               ,
		input [7:0]         w_n_3k_re               ,
		input [7:0]         w_n_3k_im               ,
		input [7:0]         w_n_4k_re               ,
		input [7:0]         w_n_4k_im               ,
		//output data and valid indicator
		output reg          dv_o                    ,
		output reg [17:0]   x_k0_re                 ,
		output reg [17:0]   x_k0_im                 ,
		output reg [17:0]   x_k1_re                 ,
		output reg [17:0]   x_k1_im                 ,
		output reg [17:0]   x_k2_re                 ,
		output reg [17:0]   x_k2_im                 ,
		output reg [17:0]   x_k3_re                 ,
		output reg [17:0]   x_k3_im                 ,
		output reg [17:0]   x_k4_re                 ,
		output reg [17:0]   x_k4_im
	);

endmodule

