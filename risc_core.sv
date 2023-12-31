module risc_core (
  input clk ,
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
typedef enum logic [4:0]{x0=0,x1=1,x2=2,x3=3,x4=4,x5=5,x6=6,x7=7,x8=8,x9=9,x10=10,
x11=11,x12=12,x13=13,x14=14,x15=15,x16=16,x17=17,,x18=18,x19=19,x20=20,x21=21,x22=22,
x23=23,x24=24,x25=25,x26=26,x27=27,,x28=28,x29=29,x30=30,x31=31}reg_no;    


  logic [ 6:0] op_code     = 0;
  logic [ 2:0] funct3      = 0;
  logic [ 6:0] funct7      = 0;
  logic        zero        = 0;
  logic        branch      = 0;
  logic [ 1:0] result_src  = 0;
  logic        mem_w       = 0;
  logic        alu_src     = 0;
  logic [ 1:0] imm_src     = 0;
  logic        reg_w       = 0;
  logic        pc_src      = 0;
  logic [ 2:0] alu_control = 0;
  logic        jump        = 0;
  logic        negative    = 0;
  logic        carry       = 0;
  logic        over_flow   = 0;
  logic [31:0] instr          ;

  always_comb begin : proc_
    op_code = instr[6:0];
    funct3  = instr[14:12];
    funct7  = instr[31:25];
    $cast(instr_name,instr[6:0]);
  end

  control_path i_control_path (
    .op_code    (op_code    ),
    .funct3     (funct3     ),
    .funct7     (funct7     ),
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
    .over_flow  (over_flow  ),
    .instr      (instr      )
  );






endmodule : risc_core
