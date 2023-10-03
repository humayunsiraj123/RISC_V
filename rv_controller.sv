module rv_controller
  import riscv_pkg :: *;
(
  input        [31:0] instr      ,
  input               zero       ,
  output logic [ 1:0] alu_op     ,
  output logic        branch     ,
  output logic        jump       ,
  output logic [ 1:0] result_src ,
  output logic        auipc      ,
  output logic        lui        ,
  output logic [ 3:0] mem_w      ,
  output logic [ 3:0] reg_w      ,
  output logic        alu_src    ,
  output logic [ 2:0] imm_src    ,
  output logic        pc_src     ,
  output logic [ 5:0] alu_control
);

  cntrl_sigs_t control_sig;


  logic [6:0] op_code    ;
  logic [2:0] funct3     ;
  logic [6:0] funct7     ;
  logic [1:0] alu_op  = 0; //wire of alu_op from main to alu decoder
// main decoder module of control path
  always_comb
    begin
      op_code = instr[6:0];
      funct3  = instr[14:12];
      funct7  = instr[31:25];
    end


  alu_decoder i_alu_decoder (
    .funct3     (funct3     ),
    .funct7     (funct7     ),
    .op_code    (op_code    ),
    .alu_op     (alu_op     ),
    .alu_control(alu_control)  // TODO: Check connection ! Signal/port not matching : Expecting logic [5:0]  -- Found logic [2:0]
  );

  main_decoder i_main_decoder (
    .op_code    (op_code    ),
    .funct3     (funct3     ),
    .funct7     (funct7     ),
    .control_sig(control_sig)
  );

  always_comb begin
    alu_op     = control_sig.alu_op;
    branch     = control_sig.branch;
    jump       = control_sig.jump;
    result_src = control_sig.result_src;
    auipc      = control_sig.auipc;
    lui        = control_sig.lui;
    mem_w      = control_sig.mem_w;
    reg_w      = control_sig.reg_w;
    alu_src    = control_sig.alu_src;
    imm_src    = control_sig.imm_src;
  end

  always_comb begin : proc_x
    pc_src = (branch && zero) || jump;//branch or jal/jalr
  end



endmodule : rv_controller