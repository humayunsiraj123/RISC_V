module extend (
	input  [31:0] imm    ,
	input  [1:0 ]      imm_src,
	output [31:0] imm_ext  // Clock Enable
);

	logic [11:0] A;
	always_comb begin : proc_immediate_extend
		A = imm_src[0] ? {imm[31:25],imm[11:7]}:imm[31:20];//selecting immedaite src as for lw instrutcion immediate is				// instr[31:0] while in SW instr [31:25]and[11:7]
		B = A[11] ? {{'1},A}:{{'0},A};
	end

endmodule