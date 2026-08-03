onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_cnn/clk
add wave -noupdate /tb_cnn/rst
add wave -noupdate /tb_cnn/image_ready
add wave -noupdate -radix decimal /tb_cnn/image_addr
add wave -noupdate /tb_cnn/image_rden
add wave -noupdate -radix hexadecimal /tb_cnn/image_i
add wave -noupdate /tb_cnn/image_valid
add wave -noupdate -radix hexadecimal /tb_cnn/filter_addr
add wave -noupdate /tb_cnn/filter_rden
add wave -noupdate -radix hexadecimal /tb_cnn/filter_i
add wave -noupdate /tb_cnn/filter_valid
add wave -noupdate -radix hexadecimal /tb_cnn/fp_out
add wave -noupdate -radix hexadecimal /tb_cnn/cnn_data_o
add wave -noupdate -radix hexadecimal /tb_cnn/cnt_dout
add wave -noupdate /tb_cnn/cnn_valid_o
add wave -noupdate -radix hexadecimal /tb_cnn/latency
add wave -noupdate /tb_cnn/latency_ena
add wave -noupdate /tb_cnn/conv_done
add wave -noupdate -radix hexadecimal /tb_cnn/dut/img_addr
add wave -noupdate /tb_cnn/dut/img_rden
add wave -noupdate -radix unsigned /tb_cnn/dut/cnt_iv
add wave -noupdate /tb_cnn/dut/wr_f4_ena
add wave -noupdate -radix hexadecimal /tb_cnn/dut/f0
add wave -noupdate -radix hexadecimal /tb_cnn/dut/f1
add wave -noupdate -radix hexadecimal /tb_cnn/dut/f2
add wave -noupdate -radix hexadecimal /tb_cnn/dut/f3
add wave -noupdate -radix hexadecimal /tb_cnn/dut/f4
add wave -noupdate -radix hexadecimal /tb_cnn/dut/f5
add wave -noupdate -radix hexadecimal /tb_cnn/dut/f6
add wave -noupdate -radix hexadecimal /tb_cnn/dut/f7
add wave -noupdate -radix hexadecimal /tb_cnn/dut/f8
add wave -noupdate -radix unsigned /tb_cnn/dut/cnt_fv
add wave -noupdate /tb_cnn/dut/shift_ena_pre
add wave -noupdate /tb_cnn/dut/shift_ena
add wave -noupdate /tb_cnn/dut/shift_last
add wave -noupdate -radix hexadecimal /tb_cnn/dut/ram_in
add wave -noupdate -expand /tb_cnn/dut/wren_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/d0
add wave -noupdate -radix hexadecimal /tb_cnn/dut/d1
add wave -noupdate -radix hexadecimal /tb_cnn/dut/d2
add wave -noupdate -radix hexadecimal /tb_cnn/dut/d3
add wave -noupdate -radix hexadecimal /tb_cnn/dut/d4
add wave -noupdate -radix hexadecimal /tb_cnn/dut/d5
add wave -noupdate -radix hexadecimal /tb_cnn/dut/d6
add wave -noupdate -radix hexadecimal /tb_cnn/dut/d7
add wave -noupdate -radix hexadecimal /tb_cnn/dut/d8
add wave -noupdate -divider mult_add
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/d0
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/d1
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/d2
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/d3
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/d4
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/d5
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/d6
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/d7
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/d8
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/f0
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/f1
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/f2
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/f3
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/f4
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/f5
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/f6
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/f7
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/f8
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/clk
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/rst_n
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/start
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/sum_en
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/result
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/dv
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/d0_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/d1_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/d2_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/d3_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/d4_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/d5_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/d6_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/d7_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/d8_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/f0_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/f1_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/f2_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/f3_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/f4_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/f5_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/f6_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/f7_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/f8_d
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/r0
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/r1
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/r2
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/r3
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/r4
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/r5
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/r6
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/r7
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/r8
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/s0
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/s1
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/s2
add wave -noupdate -radix hexadecimal /tb_cnn/dut/mult_add/ss
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3302384 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {3207909 ps} {3393218 ps}
