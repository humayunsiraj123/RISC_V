module pc_reg (
	input               clk    , // Clock
	input               srst   , // Asynchronous reset active low
	input        [31:0] pc_next,
	output logic [31:0] pc
);

	always_ff @(posedge clk) begin : proc_program_counter
		if(srst) begin
			pc <= 0;
		end else begin
			pc <= pc_next ;
		end
	end
	
endmodule