module main_decoder (
  input  [6:0] op_code   ,
  input  [2:0] funct3    ,
  input  [4:0] funct7    ,
  output [1:0] alu_op    ,
  output       branch    ,
  output       result_src,
  output       mem_w     ,
  output       alu_src   ,
  output [1:0] imm_src
  output       reg_w
);

  enum logic[6:0] {LW=7'b0000011,SW=7'b0100011,R_TYPE=7'b0110011,BEQ=1100011};

  logic [8:0] decode_res;
  assign {reg_w,imm_src,alu_src,mem_w,result_src,branch,alu_op} = decode_res;


  always_comb begin : proc_main_decoder
    case (op_code):
      LW      : decode_res = 9'b1_0010_1000;
      SW      : decode_res = 9'b0_0111_x000;
      R_TYPE  : decode_res =9'b1_xx00_0010;
      BEQ     : decode_res =9'b0_1000_x101;
      default : decode_res= 0;
    endcase

  end

  end : proc_main_decoder
