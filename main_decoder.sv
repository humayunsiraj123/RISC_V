module main_decoder (
  input  [6:0] op_code   ,
  input  [2:0] funct3    ,
  input  [6:0] funct7    ,
  output logic [1:0] alu_op    ,
  output logic       branch    ,
  output logic       jump      ,
  output logic [1:0] result_src,
  output logic [3:0] mem_w     ,//{funct3,mem_sig}
  output logic       alu_src   ,
  output logic [1:0] imm_src   ,
  output logic [3:0] reg_w
);

  enum logic[6:0] {
    LW     = 7'b0000011,
    SW     = 7'b0100011,
    BEQ    = 7'b1100011,
    I_TYPE = 7'b0010011,//itype instructions
    R_TYPE = 7'b0110011,
    JAL    = 7'b1101111,
    U_TYPE = 7'b} instr_e;

  //logic [13:0] control_sig;
  assign {reg_w,imm_src,alu_src,mem_w,result_src,branch,alu_op,jump} = control_sig;
//alu_op when 00 lw,sw(add) 01 ,beq =01 and 10 for other logic function

typedef struct packed {
  logic [1:0] alu_op;
  logic  branch;
  logic jump;
  logic [1:0] result_src;
  logic [3:0] mem_w; //lsb cntrl sig and [3:1] funct3;
  logic       alu_src;
  logic [2:0] imm_src;
  logic [3:0] reg_w;//lsb cntrl sig and [3:1] funct3;
} cntrl_sigs_t ;
  cntrl_sigs_t control_sig;
  always_comb begin : proc_main_decoder
    control_sig ='0;
    case(op_code)
      LW :begin
        control_sig.reg_w     =    {funct3,1'b1};
        control_sig.imm_src   =   3'b000;
        control_sig.alu_src   =   1'b1;
        control_sig.mem_w     =   {funct3,1'b0};
        control_sig.result_src=   2'b01;
        control_sig.branch    =   1'b0;
        control_sig.alu_op    =   2'b00;
        control_sig.jump      =   1'b0;
      end 
      SW :begin
        control_sig.reg_w     =    {funct3,1'b0};
        control_sig.imm_src   =   3'b001;
        control_sig.alu_src   =   1'b1;
        control_sig.mem_w     =   {funct3,1'b1};
        control_sig.result_src=   2'b00;
        control_sig.branch    =   1'b0;
        control_sig.alu_op    =   2'b00;
        control_sig.jump      =   1'b0;
      end
      R_TYPE :begin
        control_sig.reg_w     =   {funct3,1'b1};
        control_sig.imm_src   =   3'b000;
        control_sig.alu_src   =   1'b0;
        control_sig.mem_w     =   {funct3,1'b0};
        control_sig.result_src=   2'b00;
        control_sig.branch    =   1'b0;
        control_sig.alu_op    =   2'b10;
        control_sig.jump      =   1'b0;
      end
      I_TYPE :begin
        control_sig.reg_w     =   {funct3,1'b1};
        control_sig.imm_src   =   3'b000;
        control_sig.alu_src   =   1'b0;
        control_sig.mem_w     =   {funct3,1'b0};
        control_sig.result_src=   2'b00;
        control_sig.branch    =   1'b0;
        control_sig.alu_op    =   2'b10;
        control_sig.jump      =   1'b0;
      end

      //assign {reg_w,imm_src,alu_src,mem_w,result_src,branch,alu_op,jump} = control_sig;
    // case (op_code)
    //   LW      : control_sig = 11'b1_00_1_0_01_0_00_0;//11'b100_1001_0000 replace x with zero
    //   SW      : control_sig = 11'b0_01_1_1_00_0_00_0;//11'b001_11xx_0000 
    //   R_TYPE  : control_sig = 11'b100_0000_0100;//11'b1xx_0000_0100 
    //   BEQ     : control_sig = 11'b010_0000_1010;//11'b010_00xx_1010 
    //   I_TYPE  : control_sig = 11'b100_1000_0100;//11'b100_1000_0100 
    //   JAL     : control_sig = 11'b111_0010_0001;//11'b111_x010_0xx1 
    //   default : control_sig = 0;
    // endcase


  end : proc_main_decoder
endmodule : main_decoder