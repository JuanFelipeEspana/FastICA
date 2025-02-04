//parallel_add CBX_SINGLE_OUTPUT_FILE="ON" MSW_SUBTRACT="NO" PIPELINE=1 REPRESENTATION="UNSIGNED" RESULT_ALIGNMENT="LSB" SHIFT=1 SIZE=12 WIDTH=36 WIDTHR=36 aclr clken clock data result
//VERSION_BEGIN 18.1 cbx_mgl 2018:09:12:14:15:07:SJ cbx_stratixii 2018:09:12:13:04:09:SJ cbx_util_mgl 2018:09:12:13:04:09:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 2018  Intel Corporation. All rights reserved.
//  Your use of Intel Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Intel Program License 
//  Subscription Agreement, the Intel Quartus Prime License Agreement,
//  the Intel FPGA IP License Agreement, or other applicable license
//  agreement, including, without limitation, that your use is for
//  the sole purpose of programming logic devices manufactured by
//  Intel and sold by Intel or its authorized distributors.  Please
//  refer to the applicable agreement for further details.



//synthesis_resources = parallel_add 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  mg9kg
	( 
	aclr,
	clken,
	clock,
	data,
	result) /* synthesis synthesis_clearbox=1 */;
	input   aclr;
	input   clken;
	input   clock;
	input   [431:0]  data;
	output   [35:0]  result;

	wire  [35:0]   wire_mgl_prim1_result;

	parallel_add   mgl_prim1
	( 
	.aclr(aclr),
	.clken(clken),
	.clock(clock),
	.data(data),
	.result(wire_mgl_prim1_result));
	defparam
		mgl_prim1.msw_subtract = "NO",
		mgl_prim1.pipeline = 1,
		mgl_prim1.representation = "UNSIGNED",
		mgl_prim1.result_alignment = "LSB",
		mgl_prim1.shift = 1,
		mgl_prim1.size = 12,
		mgl_prim1.width = 36,
		mgl_prim1.widthr = 36;
	assign
		result = wire_mgl_prim1_result;
endmodule //mg9kg
//VALID FILE
