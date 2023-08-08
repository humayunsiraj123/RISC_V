module instr_mem (
	input [31:0] Addr,    // addr 
	output [31:0] RD // read Data
);

logic [31:0] memory [0:4095];

RD = memory[Addr];

endmodule



