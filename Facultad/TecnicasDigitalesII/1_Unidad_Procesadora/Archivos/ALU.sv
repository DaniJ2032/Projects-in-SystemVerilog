/*Delcaracion de un modulo ALU [CON COMENTARIOS]*/

/********TABLA DE LA ALU*********/

module alu(
				
	input logic [3:0] a,b,
	input logic [3:0] alu_control,
	output logic [3:0] result,
	output logic [3:0] alu_flags
);

	logic Cin, Cout;
	logic [3:0] y, sum;
	logic neg,zero,over,carr; //Banderas de las ALU
	assign Cin = alu_control[0];	

	
		
	/*if ternario ejemplo*/
	/*assign y = alu_Control[2] ? (alu_Control[1] ? {N {1'b1}}
															: ~b )
													  
									  : (alu_Control[1] ? b 
															 : {N {1'b0}} );*/	
	/*con always_comb cambios de (b)*/															 
   always_comb
		casex (alu_control[2:1])
			2'b00:	y = 4'b0;
			2'b01:	y = b;
			2'b10:	y = ~b;										  
			2'b11:	y = 4'b1;
		endcase
	
/*Como esta suma puede dar acarreo para no perderla concatenamos {Cout,sum} de esta manera se podra rescatar el bit de acarreo
la funcionalidad de esto es q Cout a ser de 1 bit es el bit MSB y los otros 4 bits de Sum son los LSB el concatenado nos ayuda a 
crear una especie de "variable" de 5bits.
NOTA: es muy importnte EL ORDEN DEL CONCATENADO en este caso Cout esta primero por ser una variable de 1bit y a su vez por la facilidad
que dara a la hora de rescatar el bit de acarreo, si se hubiese puesto sum primero se hubiese almacenado en sum en su MSB pero el resto de la suma
quedaria dividida entre 3 bits de sum y 1 bit de Cout lo cual lo hace mas complicado a la hora de obtener los datos.*/

	assign {Cout,sum} = a + y + Cin;	
	
	
	/*Always para la parte de oper log*/
	always_comb
		casex(alu_control[3:1])
/*aca lo que se hace es solo comprar el bit MSB de alu_control los otros dos los colocamos con "??" porque se los descarta ya que 
fueron comparados en el always de arriba y solo nos importa el bit MSB de alu_control ya que el mismo nos indica si las operaciones 
seran aritmetica o logicas*/		
			3'b0??: result =  sum;  
			3'b100: result = a & b;
			3'b101: result = a | b;
			3'b110: result = a ^ b;
			3'b111: result = ~a;
		 endcase	
		 
/*******ASIGNACION DE LAS BANDERAS DE LA ALU*******/
	
/*estamos verificamos si estamos en una "operacion aritmetica" el bit 3 de alu_control nos dira si es op aritmetica o logica, en caso 
de que este en 0 en la variable "carr" le asigno lo que dice "Cout", puede ser medio contradictorio porq carry va a salir con un valor 
ya sea 0 si es que no hubo carry o 0 indicando que estamos en una operacion logica lo cual genera confucion. En una arquitectura mas
compleja si la operacion viene de una operacion logica la bandera de cary no se modificara*/	
	
	assign carr = (alu_control[3] == 1'b0) & Cout;

/*Para el Overflow vemos los casos en que si tenemos una suma y ambas variables poseen el mismo signo o en el calos de que estemos en
una resta y ambos sean de signo opuesto, esto podria llegar a causar un overflow lo cual es una "condicion necesaria pero no suficiente"
una cosa mas que teniamos en cuenta que si a la hora de sumar el bit de signo no daba positivo (0) y nos daba un (1) ents estabamos
ante un overflow*/	
	assign over = (alu_control[3] == 1'b0) & ~(a[3] ^ b[3] ^ alu_control[0]) & (a[3] ^ sum[3]);
	

/*Basta con fijarse en el bit MSB donde si es 0 no sera negativo el numero peor si es 1 nos indicara que si lo es*/	
	assign neg = alu_control[3];	
/*	Basta con comprar el resultado con 0, en caso de que todos los bit sean cero se coloca un 1 en zero de lo contrrario sera un 0*/	
	assign zero = (result == 4'b0);
	
/*Por ultimo concatenamos las banderas a la salida*/
	assign alu_flags = {over,neg,zero,carr};	
	
/************************************/

	
endmodule	