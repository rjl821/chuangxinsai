module cnn (
		input				clk					,
        input				rst_n               ,
		//Input image interface                 
		input				image_ready			,
        output 				image_rden_o  		,
        output [12:0]		image_addr_o  		,
        input [7:0]			image_i     		,
        input				image_valid			,
        //Fiter input	                        
        output reg			filter_rden_o 		,
        output reg [3:0]	filter_addr_o 		,
        input [7:0]			filter_i    		,
        input				filter_valid		,
        //CNN output 	                        
        output reg			cnn_valid_o 		,
        output reg [19:0]	cnn_data_o  		
    );

//----------------------Insert your design code here--------------------------------



endmodule