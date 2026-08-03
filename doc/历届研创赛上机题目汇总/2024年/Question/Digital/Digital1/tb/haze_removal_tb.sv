`timescale 1ns / 1ps
module haze_removal_tb();

//`define Modelsim_Sim
 `define Vivado_Sim

//--------------------------------------------------------------------------------
`ifdef Modelsim_Sim
localparam	PIC_INPUT_PATH  	= 	"..\\pic\\duck.bmp"			;
localparam	PIC_OUTPUT_PATH 	= 	"..\\pic\\outcom.bmp"  		;
`endif
//--------------------------------------------------------------------------------
`ifdef Vivado_Sim
localparam	PIC_INPUT_PATH  	= 	"D:/CLAHE/FPGA-CLAHE-main/6.Pic/CLAHE8(1).bmp"			;
localparam	PIC_OUTPUT_PATH 	= 	"D:/CLAHE/FPGA-CLAHE-main/6.Pic/CLAHE12.bmp"  		;
`endif

localparam	PIC_WIDTH  			=	500							;
localparam	PIC_HEIGHT 			=	500 						    ;

reg         cmos_clk   = 0;
reg         cmos_rst_n = 0;

wire        cmos_vsync              ;
wire        cmos_href               ;
wire        cmos_clken              ;
wire [23:0] cmos_data               ;

wire        haze_removal_vsync      ;
wire        haze_removal_hsync      ;
wire        haze_removal_de         ;
wire [7:0] haze_removal_data       ;

parameter cmos0_period = 6.67;

always#(cmos0_period/2) cmos_clk = ~cmos_clk;
initial #(20*cmos0_period) cmos_rst_n = 1;

//--------------------------------------------------
//Camera Simulation

sim_cmos #(
		.PIC_PATH		(PIC_INPUT_PATH			)
	,	.IMG_HDISP 		(PIC_WIDTH 				)
	,	.IMG_VDISP 		(PIC_HEIGHT				)
)u_sim_cmos0(
        .clk            (cmos_clk	    		)
    ,   .rst_n          (cmos_rst_n     		)
	,   .CMOS_VSYNC     (cmos_vsync     		)
	,   .CMOS_HREF      (cmos_href      		)
	,   .CMOS_CLKEN     (cmos_clken     		)
	,   .CMOS_DATA      (cmos_data      		)
	,   .X_POS          ()
	,   .Y_POS          ()
);

       wire                 tem_YCbCr_vsync            ;
        wire                 tem_YCbCr_hsync            ;
        wire                 tem_YCbCr_de               ;
        wire    [7 : 0]     tem_Y_data                 ;
        wire    [7 : 0]     tem_Cb_data                ;
        wire    [7 : 0]     tem_Cr_data                ;
reg [7:0]   per_frame_href_r;
reg [7:0]   per_frame_vsync_r;
reg [7:0]   per_frame_clken_r;
reg [7:0]   tem_Cr_data_r[73:0];
reg [7:0]   tem_Cb_data_r[73:0];
integer i;
always@(posedge cmos_clk or negedge cmos_rst_n)begin
    if(!cmos_rst_n)begin
        for(i = 0; i< 74; i = i + 1)begin
           tem_Cr_data_r       [ i ]   <=    0;
            tem_Cb_data_r       [ i ]   <=    0;
        end
    end
    else begin
        tem_Cr_data_r        [ 0 ]          <=    tem_Cr_data                    ;
        tem_Cb_data_r        [ 0 ]          <=    tem_Cb_data                     ;
        for(i = 1; i< 74; i = i + 1)begin
           tem_Cr_data_r           [ i ]             <=     tem_Cr_data_r    [ i - 1 ]  ;
            tem_Cb_data_r           [ i ]             <=     tem_Cb_data_r    [ i - 1 ]  ;
        end
    end
end

VIP_RGB888_YCbCr444 u_rgb_ycncr_haze(
                //global clock
                .clk                    (cmos_clk                            ),
                .rst_n                  (cmos_rst_n                           ),

                //Image data prepred to be processd
                .pre_frame_vsync        (cmos_vsync                ),
                .pre_frame_href         (cmos_href                 ),

                .pre_img_red            (cmos_data[16+:8]               ),
                .pre_img_green          (cmos_data[ 8+:8]               ),
                .pre_img_blue           (cmos_data[ 0+:8]               ),
                
                //Image data has been processd
                .post_frame_vsync       (tem_YCbCr_vsync                ),
                .post_frame_href        (tem_YCbCr_hsync                ),

                .post_img_Y             (tem_Y_data                     ),
                .post_img_Cb            (tem_Cb_data                    ),
                .post_img_Cr            (tem_Cr_data                    )
        ); 
//--------------------------------------------------
//Image Processing
CLAHE #(
	 	.IMG_HDISP	        (PIC_WIDTH				)
	,	.IMG_VDISP			(PIC_HEIGHT				)
)CLAHE(
		.clk               	(cmos_clk	            )
	,	.rst_n             	(cmos_rst_n             )
	//处理前数�?????	
	,	.per_frame_vsync   	(~tem_YCbCr_vsync       )
	,	.per_frame_href    	(tem_YCbCr_hsync          )

	,	.per_img_Y          (tem_Y_data            )
	//处理后的数据
	,	.post_frame_vsync  	(haze_removal_vsync		)
	,	.post_frame_href   	(haze_removal_hsync		)

	,	.post_img          	(haze_removal_data      )
);
wire post_frame_vsync;
wire post_frame_href;
wire post_frame_clken;
wire [23:0] post_img1;
ycbcr_to_rgb u_ycbcr_to_rgb(
                .clk              (cmos_clk                                 ),

                .i_v_sync                   (~haze_removal_vsync                ),
                .i_h_sync                   (haze_removal_hsync                ),

                .i_y_8b               (haze_removal_data[7:0]                            ),
                .i_cr_8b              (tem_Cr_data_r [ 73 ]                 ),
                .i_cb_8b              (tem_Cb_data_r [ 73 ]                 ),

                .o_v_sync                  (post_frame_vsync                    ),
                .o_h_sync                  (post_frame_href                     ),
                .o_r_8b                  (post_img1 [23:16]                  ),
                .o_g_8b                (post_img1 [ 15:8]                  ),
                .o_b_8b                 (post_img1 [  7:0]                  )
        );
//--------------------------------------------------
//Video saving 
video_to_pic #(
		.PIC_PATH       (PIC_OUTPUT_PATH		)
	,	.START_FRAME    (3                      )
	,	.IMG_HDISP      (PIC_WIDTH 				)
	,	.IMG_VDISP      (PIC_HEIGHT				)
)u_video_to_pic0(
	 	.clk            (cmos_clk	            )
	,	.rst_n          (cmos_rst_n             )
	,	.video_vsync    (post_frame_vsync		)
	,	.video_hsync    (post_frame_href		)
	,	.video_data     (post_img1      )
);







endmodule