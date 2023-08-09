module register_file(
	input clk,
	input srst,
	input[4:0]A1,
	input[4:0]A2,
	input[4:0]A3,
	input[31:0]WD3,
	input WE3,
	output logic [31:0]RD1,
	output logic [31:0]RD2

	);

logic[31:0] memory[31:0];

always_ff @(posedge clk) begin : proc_regiter_files
	if(srst) begin
		memory[A3] <= 0;
	end else begin
		memory[A3] <= WE3 ? WD3 :'0 ;
	end
end

always_comb begin : proc_RD_x
RD2 = srst ? 0: memory[A2];
RD1 = srst ? 0: memory[A1];
end



endmodule : register_file