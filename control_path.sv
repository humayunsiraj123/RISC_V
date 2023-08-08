`module control_path (
	input[6:0]op_code,
	input[2:0]funct3,
	input[6:0]funct7,
	output logic       branch     ,
	output logic       result_src ,
	output logic       mem_w      ,
	output logic       alu_src    ,
	output logic [1:0] imm_src    ,
	output logic       reg_w      ,
	output logic       pc_src     ,
	output logic [2:0] alu_control
);


	logic [1:0] alu_op; //wire of alu_op from main to alu decoder
// main decoder module of control path

	logic [1:0] imm_src;
	main_decoder i_main_decoder (
		.op_code   (op_code   ),
		.funct3    (funct3    ),
		.funct7    (funct7    ),
		.alu_op    (alu_op    ),
		.branch    (branch    ),
		.result_src(result_src),
		.mem_w     (mem_w     ),
		.alu_src   (alu_src   ),
		.imm_src   (imm_src   ),
		.reg_w     (reg_w     )
	);



	alu_decoder i_alu_decoder (
		.funct3     (funct3     ),
		.funct7     (funct7     ),
		.op_code    (op_code    ),
		.alu_op     (alu_op     ),
		.alu_control(alu_control)
	);



endmodule : control_path