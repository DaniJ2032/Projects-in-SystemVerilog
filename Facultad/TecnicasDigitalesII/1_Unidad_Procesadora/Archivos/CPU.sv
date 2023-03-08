/*UNIDAD PROCESADORA (UNION DE TODOS LOS BLOQUES)*/

module cpu(

	input logic  clk, //Entrada de Clock
	input logic  [15:0] ctrl_word, //Palabra de control
	input logic  [3:0] DATA_in, // Bus de Datos de entrada
	output logic [3:0] STATE_flags, //Salida de las banderas
	output logic [3:0] DATA_out //Datos de salida
);

/*NOTA: Vea que con "[3:0] DATA_in" lo que se hace es declarar un "Bus externo de ingreso de datos"
el cual nos permitira trabajar con datos externos o simplemente con lo almacenado en el registro
aparte esto nos soluciona el problema del modulo ram3port donde no se considera el caso cuando 
a1,a2,a3 son iguale a 0, en ese caso se deberia tomar datos de entrada, en este modulo solucionamos
dicho problema*/

	logic [2:0] A,B,D,H; //Declaro las variables de 3 bit
	logic [3:0] F; //Declaro la bariable 4 bit
	logic [3:0] regA, regB, busA, BusB, ALU_out ,flags; //registros de destinos

/*Asignacion de la palabra de control a las variables*/
//	assign A = ctrl_word[15:13];
//	assign B = ctrl_cord[12:10];
//	assign D = ctrl_word[9:7];
//	assign F = ctrl_cord[6:3];
//	assign H = ctrl_word[2:10];
	
/*Asignacion en forma corta (de manera concatenada)*/

	assign {A,B,D,F,H} = ctrl_word[15:0];

/*Instansacion del modulo ram3port*/
/*Los datos se pasan en orden a los que se los declaro en el modulo ram3port
 *clk: paso el clock
 *(D!=0): de esta forma nos aseguramos de ver cuando actualizar el reg destino we3 por eso si D = 0 
 *no se actualiza el reg estino pero si es diferente de 0 si se actualizada
 *A,B,D: se los asignamos a a1,a2,a3
 *regA y regB: almacenamos los registros de salida de ram3port osea D1,D2 en ese orden
 *DATA_out: como el DATA_out es el mismo que usamos para volver a meter al archivo de la ram osea
 *almacenar el dato de la operacion de salida en algun reg ents podemos poner directamente 
 * DATA_out, porque sino se tendria que declrar otra variable y asignar DATA_out y de esta manera
 *es mas corto*/	
	ram3port REF_FILE(clk, (D!=0), A, B, D, regA, regB, DATA_out);

/*Instansacion de la ALU*/	
	
	/*Con las sig lineas nos aseguramos de manera externa de que si regA y regB son !=0 ents sus 
	valores los almacenamos en busA y busB antes de entrar en al ALU pero si alguno de ellos es 0
	entonces en busA o busB tomaremos los datos de entrada DATA_in*/
	assign busA = ((A!=0) ? regA : DATA_in);	
	assign busB = ((B!=0) ? regB : DATA_in);
	
/*en el ultimo parametro que se pasamos no se podria usar"STATE_flags" por el echo de que lo que
delcaramos en el modulo cpu es un registro y no se lo puede modificar sin tener en cuenta el reloj
por eso mismo declraramos una variable aparte y abajo en un always_ff y tranformo STATE_flags en
un registro asignsandole un ff y dejandolo sujeto a un clock*/	
	alu ALU_UNIT(busA, busB, F, ALU_out, flags);
	
		always_ff@(posedge clk) 
			STATE_flags <= flags;
	
/*Instansacion del shifter*/	
	
 shifter SHIFTER_UNIT(ALU_out,H, DATA_out);	
	

endmodule 