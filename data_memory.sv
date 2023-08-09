module data_memory
(
	input clk,
	input srst,
	input WE,
	input [31:0]A,
	input [31:0]WD,
	output logic [31:0]RD
	);
	logic [31:0] mem [1023:0] ;

	always_ff @(posedge clk) begin 
		mem[A] <= WE ? WD :0;
	end

	always_comb begin : proc_
	 	RD = srst? 0:mem[A];
	end

endmodule