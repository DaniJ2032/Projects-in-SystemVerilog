/*RAMPORT_CPU_2*/

/*Modulo de Archivo de Registros*/

module RamPort2#(parameter N = 2, M = 4)
(
	input  logic clk, 								//señal de reloj
	input  logic Write, 								//habilitacion para escritura en un registro
	input  logic [N-1:0] A_adr,B_adr,D_adr, 
	output logic [M-1:0] A_dat,B_dat, 			
	input  logic [M-1:0] D_dat 					
																						 
);

//RAM de 4 posiciones con 4 bit cada uno [R0] -> [R3] y uso 2 bits para seleccion de memoria

 logic [M-1:0] mem[2**N-1:0];
 
 
	//asignamos las salidas pertenecientes a A_dat y B_dat
	assign A_dat = mem[A_adr];						
	assign B_dat = mem[B_adr];
	
	//Guardado de datos
	always_ff @(posedge clk) 
									 
		if(Write) mem[D_adr] <= D_dat; //Esperamos un pulsod e relog para escribir en los registros  							 

endmodule
		
		
		