/*Modulo de Corrimiento "shifter"*/

module shifter(

	input logic  [3:0] D, //Registro de datos de entrada
	input logic  [2:0] S, //Registro de seleccion de oper.
	output logic [3:0] Y //registro de salida de corrimiento
);

/*Consigna 2.A Y 2.B*/
//	always_comb
//		case (S)
//			/*Corrimiento Logico*/
//			3'b000: Y = D; //Sin corrimiento solo transferencia directa
//			3'b001: Y = {D[3:1],1'b0}; //con el concatenado lo que hago es tomar los 3 bit MSB de D y el LSB le asigno un 0 (Y = [D3,D2,D1,0]) 
//			3'b010: Y = {1'b0,D[2:0]}; //mismo principio que el corrimiento a la izq (Y = [0,D2,D1,D0])
//			3'b011: Y = 1'b0; //Salida del registro todo a cero
//			/*Rotacion Logica*/
//			3'b100: Y = D; //Sin Rotacion 
//			3'b101: Y = {D[2:0],D[3:3]}; //Rotacion de un bit (Y = [D2,D1,D0,D3])
//			3'b110: Y = {D[1:0],D[3:2]}; //Rotacion de 2 bit (Y = [D1,D0,D3,D2]) 
//			3'b111: Y = {D[0:0],D[3:1]}; //Rotacion de 3 bit (Y = [D0,D3,D2,D1])			
//		endcase

/*Consigna para la 3ra version del shifter*/
	always_comb
		case (S)
			/*Corrimiento Logico*/
			3'b000: Y = D; //Sin corrimiento solo transferencia directa
			3'b001: Y = {D[3:1],1'b0}; //Corrimiento a la Izq SHL
			3'b010: Y = {1'b0,D[2:0]}; //Corrimiento a la Der SHR
			3'b011: Y = 1'b0; //Salida del registro todo a cero
			/*Rotacion Logica*/
			3'b100: Y = D; //Sin Rotacion 
			3'b101: Y = {D[2:0],D[3]}; //Rotacion a la izq ROL (Y = [D2,D1,D0,D3])
			3'b110: Y = {D[0],D[3:1]}; //Rotacion a la der ROR (Y = [D0,D3,D2,D1]) 
			3'b111: Y = D; //Sin Rotacion		
		endcase

		
endmodule 