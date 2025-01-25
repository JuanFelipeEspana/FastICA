//lpm_add_sub CBX_SINGLE_OUTPUT_FILE="ON" LPM_HINT="ONE_INPUT_IS_CONSTANT=NO,CIN_USED=NO" LPM_REPRESENTATION="UNSIGNED" LPM_TYPE="LPM_ADD_SUB" LPM_WIDTH=0 add_sub dataa datab result
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



//synthesis_resources = lpm_add_sub 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  mgrvg
	( 
	add_sub,
	dataa,
	datab,
	result) /* synthesis synthesis_clearbox=1 */;
	input   add_sub;
	input   dataa;
	input   datab;
	output   result;

	wire  wire_mgl_prim1_result;

	lpm_add_sub   mgl_prim1
	( 
	.add_sub(add_sub),
	.dataa(dataa),
	.datab(datab),
	.result(wire_mgl_prim1_result));
	defparam
		mgl_prim1.lpm_representation = "UNSIGNED",
		mgl_prim1.lpm_type = "LPM_ADD_SUB",
		mgl_prim1.lpm_width = 0,
		mgl_prim1.lpm_hint = "ONE_INPUT_IS_CONSTANT=NO,CIN_USED=NO";
	assign
		result = wire_mgl_prim1_result;
endmodule //mgrvg
//VALID FILE
