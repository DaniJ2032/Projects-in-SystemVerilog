//MODULO_UNIDAD_FUNCIONAL

module unit_fuction #(parameter N = 4)
( 

	input logic  [N:0]   FS,		//Entradas de seleccion  
	input logic  [N-1:0] A, 		//Entrada de registro A.
	input logic  [N-1:0] B, 		//Entrada de registro B.
	output logic [N-1:0] F, 		//Salida Unidad Funcional
	output logic [N-1:0] Out_Flag //Salidas de Bandera	
);
//TABLA DE UNIDAD FUNCIONAL
// ______________________________________________
//|	  SELECCION        |    F = A + y + Cin    |
//|  MF              Cin |                       |
//|_ S4  S3  S2  S1  S0 _|_     SALIDA UNIT		 |
//===============================================|
//|   0   0   0   0   0  |         F=A           |
//|   0   0   0   0   1  |         F=A+1         |
//|   0   0   0   1   0  |  		  F=A+B         |	         
//|   0   0   0   1   1  |         F=A+B+1 ARIT. | 
//|   0   0	  1	0   0	 |	        F=A+~B        |
//|   0   0   1   0   1  |         F=A+~B+1      |
//|   0   0	  1	1   0  |         F=A-1         |
//|   0   0   1   1   1  |         F=~B          |
//================================================
//|   0   1	  0   0   0  |         F=A&B         |
//|   0   1   0   1   1  |         F=A|B         | 
//|   0   1   1   0   0  |         F=A^B         |
//|   0   1   1   1   1  |         F=~B   LOGIC. |
//================================================ 
//|   1   ?   0   0   ?	 |         F=B           |
//|   1   ?   0   1   ?  |         F=SHL B       |
//|   1   ?   1   0   ?  |         F=SHR B       |
//|   1   ?   1   1   ?  |			  F=0    Shift. |	
//|______________________________________________|

	logic Cin, Cout;			  //Variables para el carry
	logic [3:0] Y, Sum;       //Variables para op
	logic neg,zero,over,carr; //Banderas de las ALU
	assign Cin = FS[0]; 		  //Cin asignado al bit LSB de FS[]	
	
	/*con always_comb cambios de (B)*/															 
   always_comb
		casex (FS[2:1])   //	S2, S1
			2'b00:	Y = 4'b0;
			2'b01:	Y = B;
			2'b10:	Y = ~B;										  
			2'b11:	Y = 4'b1;
		endcase
      
	assign {Cout,Sum} = A + Y + Cin;	
	
	/*Always para la parte de oper logica y shifter del reg B*/
	always_comb
		casex(FS[4:1])
			//OP Arit y logic the ALU
			4'b00??: F =  Sum;  
			4'b0100: F = A & B;
			4'b0101: F = A | B;
			4'b0110: F = A ^ B;
			4'b0111: F = ~A;
			//OP shifert the UNIT Function an B
			4'b1?00: F = B; //Sin corrimiento solo transferencia directa
			4'b1?01: F = {B[3:1],1'b0}; //Corrimiento a la Izq SHL			
			4'b1?10: F = {1'b0,B[2:0]}; //Corrimiento a la Der SHR
			4'b1?11: F = 1'b0; //Salida del registro todo a cero
		 endcase		
	
/*******ASIGNACION DE LAS BANDERAS DE LA ALU*******/	
	assign carr = (FS[3] == 1'b0) & Cout;
	assign over = (FS[3] == 1'b0) & ~(A[3] ^ B[3] ^ FS[0]) & (A[3] ^ Sum[3]); 
	assign neg = F[3];																					
	assign zero = (F == 4'b0);
	assign Out_Flag = {over,neg,zero,carr};	
/*************************************************/
	
endmodule




	
