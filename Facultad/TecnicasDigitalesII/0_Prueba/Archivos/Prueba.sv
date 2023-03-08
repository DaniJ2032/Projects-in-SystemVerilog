module comp_logic(
	input logic [4:0] a,b,
	output logic [4:0] f
	
);

//Operaciones logicas

assign f[0] = a[0] & b[0];
assign f[1] = a[1] | b[1];
assign f[2] = a[2] ^ b[2];
assign f[3] = ~(a[3] & b[3]);
assign f[4] = ~(a[4] | b[4]);

endmodule