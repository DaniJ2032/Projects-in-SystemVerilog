//MODULO_UNIDAD_FUNCIONAL

module shifter #(parameter N = 4)
( 

	input logic  [N:0]   FS, //Entradas de seleccion  
	input logic  [N-1:0] A, //Entrada de registro A.
	input logic  [N-1:0] B, //Entrada de registro B.
	output logic [N-1:0] F, //Salida Unidad Funcional
	output logic [N-1:0] Out_Flag //Salidas de Bandera	
);
//TABLA DE UNIDAD FUNCIONAL
// ________________________________________________________
//|_selección       _|_  entrada _|_   F = A + y + cin   _|
//|_ S3  S2  S1  S0 _|_    y     _|_   cin=0     cin=1   _|
//|   0   0          | solo ceros |    F=A       F=A+1    |
//|   0   1          |     B      |    F=A+B     F=A+B+1  |
//|   1   0          |    /B      |    F=A+/B    F=A+/B+1 |
//|_  1   1         _|_solo unos _|_   F=A-1     F=A     _| 

	logic Cin, Cout;
	logic [3:0] Y, Sum;
	logic neg,zero,over,carr; //Banderas de las ALU
	assign Cin = FS[0]; //	
	
	/*con always_comb cambios de (B)*/															 
   always_comb
		casex (FS[2:1])
			2'b00:	Y = 4'b0;
			2'b01:	Y = B;
			2'b10:	Y = ~B;										  
			2'b11:	Y = 4'b1;
		endcase

	assign {Cout,Sum} = A + Y + Cin;	
	
	/*Always para la parte de oper log y shifeter en reg B*/
	always_comb
		casex(FS[3:1])
			//OP Arit y logic the ALU
			4'b00??: F =  sum;  
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
	assign over = (FS[3] == 1'b0) & ~(A[3] ^ B[3] ^ FS[0]) & (A[3] ^ sum[3]);
	assign neg = FSl[3];	
	assign zero = (F == 4'b0);
	assign Out_Flag = {over,neg,zero,carr};	
/************************************/

	
endmodule	
