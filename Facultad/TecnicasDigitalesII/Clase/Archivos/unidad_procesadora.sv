/*Fusion de la Unidad Porcesadora*/


module datapath2 ( 
	input logic  clock,	
	input logic [15:0] ctrl_word,
	input logic [3:0]	data_in,
	output logic [3:0] out_flags,
	output logic [15:0] data_out);


logic [2:0] A, B, D, H;
logic [3:0] F;
logic [3:0] regA, regB;
logic [3:0] result_alu, bit_estado;

///*assign A ctrl_word [15:13]
//assign B ctrl_word [12:10]
//assign D ctrl_word [9:7]*/
//
//assign {A,B,D,F,H} = ctrl_word;
//
//
///*Instansacion de la ram*/
//ram3port reg_file(clk, (D!=0), A, B, D, regA, regB, data_out);
//
///*Instancia de la ALU*/
//
//assign busA = ((A!=0) ? regA : data_in);
//assign busA = ((B!=0) ? regB : data_in);
//
//alu alu_unit( busA, busB, F, result_alu, bit_estado);  




endmodule 