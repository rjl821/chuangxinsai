`timescale 1ns/1ps
module swrr (
    input           clk_sys     ,
    input           rst_n       ,
    input           start       ,
    input   [7:0]   data_in0    ,
    input   [7:0]   data_in1    ,
    input   [7:0]   data_in2    ,
    input   [7:0]   data_in3    ,
    input   [7:0]   data_in4    ,
    input   [7:0]   data_in5    ,
    input   [7:0]   data_in6    ,
    input   [7:0]   data_in7    ,
    input   [7:0]   data_in8    ,
    input   [7:0]   data_in9    ,
    output  [3:0]   value_out   ,
    output          value_valid 
);
    //wire    [7:0]       data_in0        ;
    //wire    [7:0]       data_in1        ;
    //wire    [7:0]       data_in2        ;
    //wire    [7:0]       data_in3        ;
    //wire    [7:0]       data_in4        ;
    //wire    [7:0]       data_in5        ;
    //wire    [7:0]       data_in6        ;
    //wire    [7:0]       data_in7        ;
    //wire    [7:0]       data_in8        ;
    //wire    [7:0]       data_in9        ;
    //wire    [3:0]       value_out       ;

    //internal signal
    reg     [7:0]       wei_init_ch[15:0];
    reg     [7:0]       wei_cs_ch[15:0]  ;
	reg		[7:0]		wei_sum			;
    //reg     [3:0]       ch_sel          ;
    reg                 start_r1        ;
    reg                 start_r2        ;
    reg                 start_pos       ;
    reg                 swrr_vld        ;
    reg     [7:0]       swrr_cnt        ;
    reg     [7:0]       swrr_num        ;
    reg     [3:0]       swrr_q[0:99]    ;
    reg                 swrr_valid_r    ;
    reg                 swrr_valid_r1   ;	
    reg     [3:0]       swrr_ch_r       ;
    reg     [7:0]       swrr_ch_num     ;
    reg     [7:0]       max_comp1[7:0];
    reg     [3:0]       num_comp1[7:0];
    reg     [7:0]       max_comp2[3:0];
    reg     [3:0]       num_comp2[3:0];
    reg     [7:0]       max_comp3[1:0];
    reg     [3:0]       num_comp3[1:0];
    reg     [7:0]       max_comp4;
    reg     [3:0]       num_comp4;
    wire    [7:0]       data_i[15:0]    ;
    
    task max_sel;

        input [7:0] ch1_wei_in;
        input [3:0] ch1_num_in;
        input [7:0] ch2_wei_in;
        input [3:0] ch2_num_in;
        output reg [7:0] max_wei_out;
        output reg [3:0] max_num_out;

        begin
        case({ch1_wei_in[7],ch2_wei_in[7]})
            2'b00:begin
                if(ch1_wei_in[6:0] >= ch2_wei_in[6:0])begin
                    max_wei_out = ch1_wei_in;
                    max_num_out = ch1_num_in;
                end
                else begin
                    max_wei_out = ch2_wei_in;
                    max_num_out = ch2_num_in;
                end
            end
            2'b01:begin
                max_wei_out = ch1_wei_in;
                max_num_out = ch1_num_in;
            end
            2'b10:begin
                max_wei_out = ch2_wei_in;
                max_num_out = ch2_num_in;
            end
            2'b11:begin
                max_wei_out = ch1_wei_in;
                max_num_out = ch1_num_in;
            end
            default:begin
                max_wei_out = ch1_wei_in;
                max_num_out = ch1_num_in;
            end
        endcase
        end
    endtask

    assign data_i[0]    = data_in0;
    assign data_i[1]    = data_in1;
    assign data_i[2]    = data_in2;
    assign data_i[3]    = data_in3;
    assign data_i[4]    = data_in4;
    assign data_i[5]    = data_in5;
    assign data_i[6]    = data_in6;
    assign data_i[7]    = data_in7;
    assign data_i[8]    = data_in8;
    assign data_i[9]    = data_in9;
    assign data_i[10]   = 8'b0;
    assign data_i[11]   = 8'b0;
    assign data_i[12]   = 8'b0;
    assign data_i[13]   = 8'b0;
    assign data_i[14]   = 8'b0;
    assign data_i[15]   = 8'b0;

    assign swrr_rlt = |{|wei_cs_ch[0],|wei_cs_ch[1],|wei_cs_ch[2],|wei_cs_ch[3],
                        |wei_cs_ch[4],|wei_cs_ch[5],|wei_cs_ch[6],|wei_cs_ch[7],
                        |wei_cs_ch[8],|wei_cs_ch[9],|wei_cs_ch[10],|wei_cs_ch[11],
                        |wei_cs_ch[12],|wei_cs_ch[13],|wei_cs_ch[14],|wei_cs_ch[15]}?1'b0:1'b1;

    always @(posedge clk_sys or negedge rst_n) begin
        if (!rst_n) begin
            start_r1    <= 1'b0;
            start_r2    <= 1'b0;
            start_pos   <= 1'b0;
        end
        else begin
            start_r1    <= start;
            start_r2    <= start_r1;
            start_pos   <= start_r1 & (~start_r2);
        end
    end

    always @(posedge clk_sys or negedge rst_n) begin
        if (!rst_n) begin
            swrr_vld <= 1'b0;
        end
        else if (start_pos)begin
            swrr_vld <= 1'b1;
        end
        else if (swrr_rlt)begin
            swrr_vld <= 1'b0;
        end
        else begin
            swrr_vld <= swrr_vld;
        end
    end

    always @(posedge clk_sys or negedge rst_n) begin
        if (!rst_n) begin
            swrr_cnt <= 8'b0;
        end
        else if (swrr_vld)begin
            if (swrr_cnt == 8'h5) begin
                swrr_cnt <= 8'h0;
            end
            else begin
                swrr_cnt <= swrr_cnt + 8'b1;
            end
        end
        else begin
            swrr_cnt <= 8'b0;
        end
    end

    genvar i;
    generate
        for (i=0;i<16 ;i=i+1) begin:init_loop
            always @(posedge clk_sys or negedge rst_n) begin
                if(!rst_n) begin
                    wei_init_ch[i]  <=  8'h0;
                end
                else if(start_pos) begin
                    wei_init_ch[i]  <=  data_i[i];
                end
                else begin
                    wei_init_ch[i]  <=  wei_init_ch[i];
                end  
            end
        end
    endgenerate

    always @(posedge clk_sys or negedge rst_n) begin
        if(!rst_n) begin
            wei_sum  <=  8'h0;
        end
        else if(start_pos) begin
            wei_sum  <=  data_i[0]+data_i[1]+data_i[2]+data_i[3]+data_i[4]+data_i[5]+data_i[6]+data_i[7]+data_i[8]+data_i[9];
        end
    end
	

    generate
        for (i=0;i<16 ;i=i+1) begin:cs_loop
            always @(posedge clk_sys or negedge rst_n) begin
                if(!rst_n) begin
                    wei_cs_ch[i]  <=  8'h0;
                end
                else if(start_pos) begin
                    wei_cs_ch[i]  <=  data_i[i];
                end
                else if (swrr_vld)begin
                    if (swrr_cnt == 8'h4) begin
                        if (i == num_comp4) begin
                            wei_cs_ch[i]  <=  wei_cs_ch[i] - wei_sum;
                        end
                        else begin
                            wei_cs_ch[i] <= wei_cs_ch[i];
                        end
                    end
                    else if (swrr_cnt == 8'h5) begin
                        wei_cs_ch[i] <= wei_cs_ch[i] +wei_init_ch[i];
                    end
                end  
            end
        end
    endgenerate

	genvar k;
    generate
        for (k=0;k<8 ;k=k+1) begin:comp1_loop
            always @(posedge clk_sys) begin
                if (swrr_vld && (swrr_cnt==8'b0)) begin
                    max_sel(wei_cs_ch[2*k],2*k,wei_cs_ch[2*k+1],2*k+1,max_comp1[k],num_comp1[k]);
                end
            end
        end
    endgenerate

    genvar j;
    generate
        for (j=0;j<4 ;j=j+1) begin:comp2_loop
            always @(posedge clk_sys) begin
                if(swrr_vld && (swrr_cnt == 8'h1))begin
                    max_sel(max_comp1[2*j],num_comp1[2*j],max_comp1[2*j+1],num_comp1[2*j+1],max_comp2[j],num_comp2[j]);
                end
            end
        end
    endgenerate
    
    genvar m;
    generate
        for (m=0;m<2 ;m=m+1) begin:comp3_loop
            always @(posedge clk_sys) begin
                if(swrr_vld && (swrr_cnt == 8'h2))begin
                    max_sel(max_comp2[2*m],num_comp2[2*m],max_comp2[2*m+1],num_comp2[2*m+1],max_comp3[m],num_comp3[m]);
                end
            end
        end
    endgenerate

    always @(posedge clk_sys) begin
        if(swrr_vld && (swrr_cnt == 8'h3))begin
            max_sel(max_comp3[0],num_comp3[0],max_comp3[1],num_comp3[1],max_comp4,num_comp4);
        end
    end

    always @(posedge clk_sys or negedge rst_n) begin
        if (!rst_n) begin
            swrr_num <= 8'b0;
        end
        else if(swrr_cnt == 8'h4)begin
            swrr_q[swrr_num] <= num_comp4;
            swrr_num <= swrr_num + 8'b1;
        end
        else if (start_pos)begin
            swrr_num <= 8'b0;
        end
    end

    always @(posedge clk_sys or negedge rst_n) begin
        if (!rst_n) begin
            swrr_valid_r <= 1'b0;
			swrr_valid_r1<= 1'b0;
        end
        else if (swrr_vld && swrr_rlt)begin
            swrr_valid_r <= 1'b1;
        end
		else begin
			swrr_valid_r1<= swrr_valid_r;
		end
    end

    always @(posedge clk_sys or negedge rst_n) begin
        if (!rst_n) begin
            swrr_ch_num <= 8'b0;
        end
        else if (swrr_valid_r)begin
            if ((swrr_num-1) == swrr_ch_num) begin
                swrr_ch_num <= 8'h0;
            end
            else begin
                swrr_ch_num <= swrr_ch_num + 8'b1;
            end
        end
        else begin
            swrr_ch_num <= 8'b0;
        end
    end
    always @(posedge clk_sys or negedge rst_n) begin
        if (!rst_n) begin
            swrr_ch_r <= 4'b0; 
        end
        else begin
            swrr_ch_r <= swrr_q[swrr_ch_num];
        end
    end

    assign value_out = swrr_ch_r;
    assign value_valid = swrr_valid_r1;




endmodule
