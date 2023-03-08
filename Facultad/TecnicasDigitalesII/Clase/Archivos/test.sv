module test();

	logic clk;
	logic [15:0] control;
	logic [3:0]  datain, dataout;
	logic [3:0]  banderas;
	
datapath2 dat(clk, control, datain, banderas, dataput);

	initial begin //genera una funcion secuencial de lo que se declare dentro de el
		
		control = 16'b000_000_001_0000_000;
		datain  = 4'b0011;
	   clk = 0;	
		#10;
	   clk = 1;	
		#10;		
		
		control = 16'b001_000_010_0000_000;
		datain  = 4'b1010;
	   clk = 0;	
		#10;
	   clk = 1;	
		#10;	
	
		control = 16'b001_010_011_0010_000;
		datain  = 4'b1010;
	   clk = 0;	
		#10;
	   clk = 1;	
		#10;	
	end
	
endmodule 
	