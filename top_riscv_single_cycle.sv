module top_riscv_single_cycle (
	input clk,
	input srst
);

	typedef enum logic[6:0] {
		LW     = 7'b0000011,
		SW     = 7'b0100011,
		BEQ    = 7'b1100011,
		I_TYPE = 7'b0010011,//itype instruction
		R_TYPE = 7'b0110011,
		JAL    = 7'b1101111} instr_e;
	instr_e instr_name;


	// logic [31:0] instr      ;
	// logic        zero       ;
	// logic        jump       ;
	// logic        branch     ;
	// logic [ 1:0] result_src ;
	// logic        mem_w      ;
	// logic        alu_src    ;
	// logic [ 1:0] imm_src    ;
	// logic        reg_w      ;
	// logic        pc_src     ;
	// logic [ 2:0] alu_control;
 //  	logic [6:0] opcode ;
	
	// logic [31:0] read_data ;
	// logic [31:0] write_data;
	// logic [31:0] ALUresult ;
	// logic [31:0] pc        ;
	// logic [31:0] Addr      ;
	// logic [31:0] RD        ;

	// logic        WE;
	// logic [31:0] A ;
	// logic [31:0] WD;



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



	instr_mem i_instr_mem (
		.Addr(pc   ),
		.RD  (instr)
	);



	data_memory i_data_memory (
		.clk (clk       ),
		.srst(srst      ),
		.WE  (mem_w     ),
		.A   (ALUresult ),
		.WD  (write_data),
		.RD  (read_data )
	);

always_comb begin : proc_
  opcode = instr[6:0];
  $cast(instr_name,instr[6:0]);

end

endmodule : top_riscv_single_cycle