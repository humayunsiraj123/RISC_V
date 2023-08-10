module data_memory
(
	input clk,
	input srst,
	input WE,
	input [31:0]A,
	input [31:0]WD,
	output logic [31:0]RD
	);
	logic [31:0] mem [4096:0] ;
initial begin
	foreach(mem[i]) begin
		mem[i]=i;
	end
end

	always @(posedge clk) begin 
		mem[A] <= WE ? WD :0;
	end

	always@(*) begin : proc_
	 	RD = srst? 0: mem[A];
	end

endmodule