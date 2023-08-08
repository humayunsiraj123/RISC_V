module risc_core(
  input clk,
  input srst,
  );


  logic [6:0] op_code;
  logic [2:0] funct3;
  logic [6:0] funct7;
  logic zero;
  logic branch;
  logic result_src;
  logic mem_w;
  logic alu_src;
  logic [1:0] imm_src;
  logic reg_w;
  logic pc_src;
  logic [2:0] alu_control;

control_path i_control_path (
  .op_code    (op_code    ),
  .funct3     (funct3     ),
  .funct7     (funct7     ),
  .zero       (zero       ),
  .branch     (branch     ),
  .result_src (result_src ),
  .mem_w      (mem_w      ),
  .alu_src    (alu_src    ),
  .imm_src    (imm_src    ),
  .reg_w      (reg_w      ),
  .pc_src     (pc_src     ),
  .alu_control(alu_control)
);



  logic negative;
  logic carry;
  logic over_flow;
  
data_path i_data_path (
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
  .zero       (zero       ),
  .negative   (negative   ),
  .carry      (carry      ),
  .over_flow  (over_flow  )
);



endmodule : risc_core
