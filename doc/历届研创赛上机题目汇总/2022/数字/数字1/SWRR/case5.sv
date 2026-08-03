`timescale 1ns/1ps
module testbench;
  logic         clk_sys;
  logic         rst_n;
  logic         start;
  logic  [7:0]  data_in0;
  logic  [7:0]  data_in1;
  logic  [7:0]  data_in2;
  logic  [7:0]  data_in3;
  logic  [7:0]  data_in4;
  logic  [7:0]  data_in5;
  logic  [7:0]  data_in6;
  logic  [7:0]  data_in7;
  logic  [7:0]  data_in8;
  logic  [7:0]  data_in9;
  logic  [3:0]  value_out;
  logic         value_valid;
  int           chnl_wgt_org[9:0];
  int 			chnl_wgt[9:0];
  int           total;
  int 			max[$];
  int 			max_index[$];
  int			vld_cmp[$];
  int			all_chnl_vld[$];

  swrr dut(
     .clk_sys     (clk_sys    )
    ,.rst_n       (rst_n      )
    ,.start       (start      ) 
    ,.data_in0    (data_in0   ) 
    ,.data_in1    (data_in1   )  
    ,.data_in2    (data_in2   )  
    ,.data_in3    (data_in3   )
    ,.data_in4    (data_in4   )
    ,.data_in5    (data_in5   )
    ,.data_in6    (data_in6   )
    ,.data_in7    (data_in7   )
    ,.data_in8    (data_in8   )
    ,.data_in9    (data_in9   )
    ,.value_out   (value_out  )
    ,.value_valid (value_valid)
  );
  
  // clock generation
  initial begin 
    clk_sys <= 0;
    forever begin
      #5 clk_sys <= !clk_sys;
    end
  end
  
  // reset trigger
  initial begin 
    #10 rst_n <= 0;
    start <= 0;
    repeat(10) @(posedge clk_sys);
    rst_n <= 1;
  end

// use task chnl_init to send weights of channels
task chnl_init (input int n, 
   output [7:0]  data_in0,
   output [7:0]  data_in1,
   output [7:0]  data_in2,
   output [7:0]  data_in3,
   output [7:0]  data_in4,
   output [7:0]  data_in5,
   output [7:0]  data_in6,
   output [7:0]  data_in7,
   output [7:0]  data_in8,
   output [7:0]  data_in9
 );
  if(n == 0) begin
    data_in0 = 8'd9;
    data_in1 = 8'd9;
    data_in2 = 8'd9;
    data_in3 = 8'd9;
    data_in4 = 8'd9;
    data_in5 = 8'd9;
    data_in6 = 8'd9;
    data_in7 = 8'd9;
    data_in8 = 8'd9;
    data_in9 = 8'd9;
    end
  else if(n == 1) begin
    data_in0 = 8'd10;
    data_in1 = 8'd10;
    data_in2 = 8'd10;
    data_in3 = 8'd10;
    data_in4 = 8'd10;
    data_in5 = 8'd10;
    data_in6 = 8'd10;
    data_in7 = 8'd10;
    data_in8 = 8'd1;
    data_in9 = 8'd10;
  end
	else if(n == 2) begin
    data_in0 = 8'd2;
    data_in1 = 8'd2;
    data_in2 = 8'd3;
    data_in3 = 8'd4;
    data_in4 = 8'd6;
    data_in5 = 8'd7;
    data_in6 = 8'd8;
    data_in7 = 8'd9;
    data_in8 = 8'd1;
    data_in9 = 8'd10;
  end
  else if(n == 3) begin
    data_in0 = 8'd0;
    data_in1 = 8'd0;
    data_in2 = 8'd0;
    data_in3 = 8'd0;
    data_in4 = 8'd0;
    data_in5 = 8'd0;
    data_in6 = 8'd0;
    data_in7 = 8'd0;
    data_in8 = 8'd0;
    data_in9 = 8'd0;
  end
  else if(n == 4) begin 
    data_in0 = $urandom_range(10,0);
    data_in1 = $urandom_range(10,0);
    data_in2 = $urandom_range(10,0);
    data_in3 = $urandom_range(10,0);
    data_in4 = $urandom_range(10,0);
    data_in5 = $urandom_range(10,0);
    data_in6 = $urandom_range(10,0);
    data_in7 = $urandom_range(10,0);
    data_in8 = $urandom_range(10,0);
    data_in9 = $urandom_range(10,0);
  end
  else $display("channel initial with wrong number.");
endtask


// use the dynamic array to send weights of channels
initial begin 
  @(posedge rst_n); 
  repeat(5) @(posedge clk_sys);
  //send weight to every data_in with choice
  chnl_init(4, data_in0, data_in1, data_in2, data_in3, data_in4, data_in5, data_in6, data_in7, data_in8, data_in9);
  chnl_wgt[0] = data_in0 ;
  chnl_wgt[1] = data_in1 ;
  chnl_wgt[2] = data_in2 ;
  chnl_wgt[3] = data_in3 ;
  chnl_wgt[4] = data_in4 ;
  chnl_wgt[5] = data_in5 ;
  chnl_wgt[6] = data_in6 ;
  chnl_wgt[7] = data_in7 ;
  chnl_wgt[8] = data_in8 ;
  chnl_wgt[9] = data_in9 ;
  //calculate the total of weight value
  total = chnl_wgt[0]+chnl_wgt[1]+chnl_wgt[2]+chnl_wgt[3]+chnl_wgt[4]+chnl_wgt[5]+chnl_wgt[6]+chnl_wgt[7]+chnl_wgt[8]+chnl_wgt[9];
  foreach (chnl_wgt[i]) chnl_wgt_org[i] = chnl_wgt[i];
  repeat(2) @(posedge clk_sys);
  // start loop
  start <= 1;
  
  //compare the queue at negedge
  repeat(2000) begin
    @(posedge clk_sys) begin
      compval(value_out, value_valid, total, chnl_wgt, chnl_wgt_org);
    end
  end
  $display("Pass!");
  $finish;
end





task compval (
  input  logic  [3:0]  value_out,
  input  logic         value_valid,
  input  int		   total,
  input  int           chnl_wgt[9:0],
  inout  int           chnl_wgt_org [9:0]
  );
    if(value_valid == 1) begin
      value_out = int'(value_out);
      //find the channel number of the max weight value, then get a queue named max 
	  max = chnl_wgt_org.max();
      //find the index of channel with max weight value, then get a queue named max_index
      max_index = chnl_wgt_org.find_index with(item == max[0]);
      //find all the element in max_index which is equal to the value_out, then get a queue named vld_cmp 
      vld_cmp = max_index.find with(item == value_out);
      //if vld_cmp.size == 0, it means no item match the value_out,it's error and finish the sim!
      if (vld_cmp.size == 0)  begin
		$display("Failtime is %t",$realtime);
		foreach(chnl_wgt_org[i]) $display("current weight is %0d ", chnl_wgt_org[i]);
		foreach(max_index[i]) $display("output num is %0d", max_index[i]);
		$display("Fail!");
        $finish;
        end
      else begin
          chnl_wgt_org[value_out] -=  total ;
            foreach(chnl_wgt_org[i]) chnl_wgt_org[i] += chnl_wgt[i];
        end
    end

endtask

endmodule