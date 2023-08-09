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

//initial begin
//lw instr
//memory[0]  =0;
//memory[6]  = 'd6;// example 1 x5
//memory[10] ='h2004;//x9

//end


always_ff @(posedge clk) begin : proc_regiter_files
	if(WE3)
		memory[A3] <= WD3 ;
	end

always_comb begin : proc_RD_x
RD2 = srst ? 0: memory[A2];
RD1 = srst ? 0: memory[A1];
end



endmodule : register_file