module instr_mem (
	input [31:0] Addr,    // addr 
	output [31:0] RD // read Data
);

logic [31:0] memory [0:4095];

RD = memory[Addr];

endmodule



module extende (
	input [11:0]imm ,
	output [31:0]imm_ext// Clock Enable
);

assign B = A[11] ? {{'1},A}:{{'0},A};

endmodule