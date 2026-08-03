//  File:  dft_radixn.v
`timescale 1ns / 100ps
module mult_axb
    (
		input                   rst_n               ,
		input                   clk                 ,
		input signed[7:0]       data_a              ,
		input signed[7:0]       data_b              ,
		output reg signed[15:0] res
	);


    always @ (negedge rst_n, posedge clk)
    begin
        if (~rst_n) begin
            res <= 16'd0;
        end
        else begin
            res <= data_a*data_b;
        end
    end

endmodule

