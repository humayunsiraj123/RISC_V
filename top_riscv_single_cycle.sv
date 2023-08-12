module top_riscv_single_cycle(
	input clk,
	input srt
	);

typedef enum logic[6:0] {
    LW     = 7'b0000011,
    SW     = 7'b0100011,
    BEQ    = 7'b1100011,
    I_TYPE = 7'b0010011,//itype instruction
    R_TYPE = 7'b0110011,
    JAL    = 7'b1101111} instr_e;
    instr_e instr_name;


	logic [31:0] instr;
	logic zero;
	logic jump;
	logic branch;
	logic [1:0] result_src;
	logic mem_w;
	logic alu_src;
	logic [1:0] imm_src;
	logic reg_w;
	logic pc_src;
	logic [2:0] alu_control;
controller i_controller (
	.instr      (instr      ),
	.zero       (zero       ),
	.jump       (jump       ),
	.branch     (branch     ),
	.result_src (result_src ),
	.mem_w      (mem_w      ),
	.alu_src    (alu_src    ),
	.imm_src    (imm_src    ),
	.reg_w      (reg_w      ),
	.pc_src     (pc_src     ),
	.alu_control(alu_control)
);


	logic srst;
	logic [31:0] read_data;
	logic [31:0] write_data;
	logic [31:0] ALUresult;
	logic [31:0] pc;
datapath i_datapath (
	.clk        (clk        ),
	.srst       (srst       ),
	.branch     (branch     ),
	.result_src (result_src ),
	.mem_w      (mem_w      ),
	.alu_src    (alu_src    ),
	.imm_src    (imm_src    ),
	.reg_w      (reg_w      ),
	.pc_src     (pc_src     ),
	.alu_control(alu_control),
	.instr      (instr      ),
	.read_data  (read_data  ),
	.write_data (write_data ),
	.ALUresult  (ALUresult  ),
	.pc         (pc         ),
	.zero       (zero       )
);


	logic [31:0] Addr;
	logic [31:0] RD;
instr_mem i_instr_mem (.Addr(Addr), .RD(RD));


	logic WE;
	logic [31:0] A;
	logic [31:0] WD;
data_memory i_data_memory (.clk(clk), .srst(srst), .WE(WE), .A(A), .WD(WD), .RD(RD));


endmodule : top_riscv_single_cycle