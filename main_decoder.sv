module main_decoder (
  input        [6:0] op_code   ,
  input        [2:0] funct3    ,
  input        [6:0] funct7    ,
  output logic [1:0] alu_op    ,
  output logic       branch    ,
  output logic       jump      ,
  output logic [1:0] result_src,
  output logic [3:0] mem_w     , //{funct3,mem_sig}
  output logic       alu_src   ,
  output logic [1:0] imm_src   ,
  output logic [3:0] reg_w
);

  enum logic[6:0] {
    LOAD   = 7'b0000011,
    STORE  = 7'b0100011,
    BRANCH = 7'b1100011,
    I_TYPE = 7'b0010011,//itype instructions
    R_TYPE = 7'b0110011,
    JALR   = 7'b1100111,
    LUI    = 7'b0110111,
    AUIPC  = 7'b0010111,
    JUMP   = 7'b1101111,

  } instr_e;

  //logic [13:0] control_sig;
  assign {reg_w,imm_src,alu_src,mem_w,result_src,branch,alu_op,jump} = control_sig;
//alu_op when 00 lw,sw(add) 01 ,beq =01 and 10 for other logic function

  typedef struct packed {
    logic [1:0] alu_op    ;
    logic       branch    ;
    logic       jump      ;
    logic [1:0] result_src;
    logic [3:0] mem_w     ; //lsb cntrl sig and [3:1] funct3;
    logic       alu_src   ;
    logic [2:0] imm_src   ;
    logic [3:0] reg_w     ; //lsb cntrl sig and [3:1] funct3;
    logic       pc_update ;
    logic lui,
    logic auipc,
  } cntrl_sigs_t ;
  cntrl_sigs_t control_sig;
  always_comb begin : proc_main_decoder
    control_sig ='0;
    case(op_code)
      LOAD :begin
        control_sig.reg_w     =    {funct3,1'b1};
        control_sig.imm_src   =   3'b000;
        control_sig.alu_src   =   1'b1;
        control_sig.mem_w     =   {funct3,1'b0};
        control_sig.result_src=   2'b01;
        control_sig.branch    =   1'b0;
        control_sig.alu_op    =   2'b00;
        control_sig.jump      =   1'b0;
        control_sig.pc_update =   1'b0;
        control_sig.lui       =   1'b0;
        control_sig.lui       =   1'b0;
        control_sig.auipc     =   1'b0;
        control_sig.auipc     =   1'b0;
      end
      STORE :begin
        control_sig.reg_w     =    {funct3,1'b0};
        control_sig.imm_src   =   3'b001;
        control_sig.alu_src   =   1'b1;
        control_sig.mem_w     =   {funct3,1'b1};
        control_sig.result_src=   2'b00;
        control_sig.branch    =   1'b0;
        control_sig.alu_op    =   2'b00;
        control_sig.jump      =   1'b0;
        control_sig.pc_update = 1'b0;
        control_sig.lui       =1'b0;
        control_sig.auipc  = 1'b0;
      end
      R_TYPE :begin
        control_sig.reg_w     =   {3'b010,1'b1};//full word write
        control_sig.imm_src   =   3'b000;
        control_sig.alu_src   =   1'b0;
        control_sig.mem_w     =   {3'b000,1'b0};
        control_sig.result_src=   2'b00;
        control_sig.branch    =   1'b0;
        control_sig.alu_op    =   2'b10;
        control_sig.jump      =   1'b0;
        control_sig.pc_update = 1'b0;
        control_sig.lui       =1'b0;
        control_sig.auipc  = 1'b0;
      end
      I_TYPE :begin
        control_sig.reg_w     =   {3'b010,1'b1};//full word write
        control_sig.imm_src   =   3'b000;
        control_sig.alu_src   =   1'b0;
        control_sig.mem_w     =   {funct3,1'b0};
        control_sig.result_src=   2'b00;
        control_sig.branch    =   1'b0;
        control_sig.alu_op    =   2'b10;
        control_sig.jump      =   1'b0;
        control_sig.pc_update = 1'b0;
        control_sig.lui       = 1'b0;
        control_sig.auipc     = 1'b0;
      end
      BRANCH :begin
        control_sig.reg_w     =   {3'b000,1'b0};
        control_sig.imm_src   =   3'b010;
        control_sig.alu_src   =   1'b0;
        control_sig.mem_w     =   {funct3,1'b0};
        control_sig.result_src=   2'b00;
        control_sig.branch    =   1'b1;
        control_sig.alu_op    =   2'b01;
        control_sig.jump      =   1'b0;
        control_sig.pc_update =   1'b0;
        control_sig.lui       =   1'b0;
        control_sig.auipc     =   1'b0;
      end
      LUI :begin
        //implemented as instead alu result forward diectly connected immediat with 4to1 mux instead alu result
        //immedaite will be send when lui is high 
        control_sig.reg_w     =   {3'b010,1'b1};//full word write
        control_sig.imm_src   =   3'b100;//utype immdiate
        control_sig.alu_src   =   1'b0;//
        control_sig.mem_w     =   {funct3,1'b0};//no memory write
        control_sig.result_src=   2'b00;//for lui immediate
        control_sig.branch    =   1'b0;
        control_sig.alu_op    =   2'b00;
        control_sig.jump      =   1'b0;
        control_sig.pc_update =   1'b0;
        control_sig.lui       =   1'b1;// need to forward that immediate
        control_sig.auipc     =   1'b0;
      end
      AUIPC :begin//use 
        control_sig.reg_w     =   {3'b010,1'b1};//full word write
        control_sig.imm_src   =   3'b100;//utype immdiate
        control_sig.alu_src   =   1'b0;
        control_sig.mem_w     =   {funct3,1'b0};
        control_sig.result_src=   2'b00//immedaite vlaue from mux instead alu which pc+immext(utype);
        control_sig.branch    =   1'b0;
        control_sig.alu_op    =   2'b00;
        control_sig.jump      =   1'b0;
        control_sig.pc_update =   1'b0;
        control_sig.lui       =   1'b0;
        control_sig.auipc     =   1'b1;
      end


// always_comb
//  case(WE[3:1])
//   3'd0:load_type = {{24{data_in[31]}},data_in[7:0]};// load byte
//   3'd1:load_type = {{16{data_in[31]}},data_in[15:0]};// load half
//   3'd2:load_type = data_in;// load WORD
//   3'd4:load_type = {'0,data_in[7:0]};// load byte unsigned
//   3'd5:load_type = {'0,data_in[15:0]};// load half unsigned
//   default : load_type = data_in;

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