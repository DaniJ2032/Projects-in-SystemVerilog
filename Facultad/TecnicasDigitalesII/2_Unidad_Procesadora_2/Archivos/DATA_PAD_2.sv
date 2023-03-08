/*DATA PATH UNIDAD PROCESADORA 2*/

/*UNIDAD PROCESADORA (UNION DE TODOS LOS BLOQUES)*/

module cpu #(parameter N = 4)
(
	input logic  clk,                //Entrada de Clock
	input logic  [13:0] ctrl_word,   //Palabra de control 14 bits
	input logic  [N-1:0] DATA_in,    //Bus de Datos de entrada
	input logic  CONSTAN_in,    	   //Constante de entrada
	output logic [N-1:0] STATE_flags,//Salida de las banderas
	output logic [N-1:0] DATA_out,    //Datos de salida
	output logic [N-1:0] ADRS_out    //Registro de salida
);

	logic [1:0] A,B,D; //Declaro las variables de 2 bit
	logic MB_S, MD_S, Write;
	logic [4:0] FS; //Declaro la bariable 4 bit
	logic [3:0] regA, regB, UNIT_out ,flags, MB_out, MD_out; //registros de destinos
	
/*Asignacion en forma corta (de manera concatenada)*/

			//FS,A,B,D,MB_S,MD_S,WRITE
	assign {FS,A,B,D,MB_S,MD_S,Write} = ctrl_word[13:0];

/*Instansacion del modulo RamPort2*/
//Los datos se pasan en orden a los que se los declaro en el modulo ram3port
	RamPort2 RAM_FILE(clk, Write, A, B, D, regA, regB, MD_out);

/*Instansacion de la ALU*/	
	
		always_comb
		case(MB_S)
			1'b0: MB_out = regB;
			1'b1: MB_out = CONSTAN_in;
		endcase 	
		
		always_comb
		case(MD_S)
			1'b0: MD_out = UNIT_out;
			1'b1: MD_out = DATA_in;
		endcase
		
		assign DATA_out = MB_out; //Salida de datos
		assign ADRS_out = regA; //Salida de los Registros

/*Instansiacion del modulo unit_fuction*/			
	unit_fuction UNIT_FILE (FS, regA, MB_out, UNIT_out, flags);
	
		always_ff@(posedge clk)  //Actualizo el estado de las banderas
			STATE_flags <= flags;
			
endmodule 












