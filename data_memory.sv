module data_memory
(
	input clk,
	input srst,
	input WE,
	input [31:0]A,
	input [31:0]WD,
	output logic [31:0]RD
	);
	logic [31:0] mem [0:1023];

	always_ff @(posedge clk) begin 
		if(srst) begin
			mem <= 0;
		end else begin
			mem[A] <= WE ? WD :0;
		end
	end

	assign RD = srst? 0:mem[A];

endmodule