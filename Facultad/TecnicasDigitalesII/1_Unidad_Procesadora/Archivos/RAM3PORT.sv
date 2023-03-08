/*Modulo de Archivo de Registros*/

/*Con este modulo lo que se hace es sintetizar:
*****************************
*"Archivo de registros"
*"Selec, de Regis Destino"
*"Slec Bus A" y "Selec Bus B"
*****************************
*ya que desde el punto de vista de programacion tener los 4 modulos por separado no es eficiciente solo se los representa por
*separado a modo de diagrama de bloque pero en realidad es todo un solo modulo a la hora de sintetizarlo.*/

module ram3port(
	
	input  logic clk, //señal de reloj
	input  logic we3, //habilitacion para escritura en un registro
	input  logic [2:0] a1,a2,a3, //a1,a2,a3 indican que numero de registro vamos a utilizar en total se tienen 7 reg y con 3bit lo selec 
	output logic [3:0] d1,d2, //d1 y d2 son nuestros puertos de salida y se seleccionan como a1 -> d1 y a2 -> d2
	input  logic [3:0] d3 //con este registro d3 y a3, indico en que registro voy a guardar un dato, por eso el reg d3 es de entrada
								 //y lo usamos para escritura								 
);

	logic [3:0] mem [7:0]; //Internamente declaramos una memoria de variables de 4bit y estan enum de mem[0] a mem[7], 8 en total1
//Otra manera de declarar la memoria seria:

	//logic [M-1:0] mem[2**N-1:0]; donde M = 4 Y N = 3	

	
	//asignamos las salidas pertenecientes a d1 y d2
	assign d1 = mem[a1];
	assign d2 = mem[a2];
	
	//Guardado de datos
	always_ff @(posedge clk) //En System Verilog para evitar ambiguedades a la hora del sintetizado existen 3 always en este caso el 		
									 // "always_ff" indica un combinacional secuencial y por eso se lo almacena en flip flop		
		if(we3) mem[a3] <= d3; //cuando tenetemos la señal we3 habilita el guardo el contenido de d3 en el reg mem[] en la posicion a3  							 

endmodule
		