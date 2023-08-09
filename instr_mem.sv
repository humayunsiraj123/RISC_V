module instr_mem (
	input [31:0] Addr,    // addr 
	output logic [31:0] RD // read Data
);

logic [31:0] memory [0:4095];

always_comb begin : proc_instr_mem

RD = memory[Addr];
end

endmodule



