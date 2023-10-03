module rv_datapath (
  input               clk        , // Clock
  input               srst       ,
  input  logic        branch     ,
  input  logic [ 1:0] result_src ,
  input  logic [ 3:0] mem_w      ,
  input  logic        alu_src    ,
  input  logic [ 2:0] imm_src    ,
  input  logic [ 3:0] reg_w      ,
  input  logic        pc_src     ,
  input  logic [ 5:0] alu_control,
  input               lui        ,
  input               auipc      ,
  input        [31:0] instr      ,
  input        [31:0] read_data  ,
  output logic [31:0] write_data ,
  output logic [31:0] ALUresult  ,
  output logic [31:0] pc         ,
  output logic        zero
);

  //pc signals
  logic [31:0] pc_target = 0;
  logic [31:0] pc_plus4  = 0;
  logic [31:0] pc_next   = 0;

// register files signals
  logic [31:0] f_mux_out    ; //
  logic [ 4:0] A1           ;
  logic [ 4:0] A2           ;
  logic [ 4:0] A3           ;
  logic [31:0] WD3          ;
  logic [ 3:0] WE3       = 0;
  logic [31:0] RD1          ;
  logic [31:0] RD2       = 0;

  // logic [31:0] Addr = 0;

// extended module sig
  logic [11:0] imm     = 0;
  logic [31:0] imm_ext = 0;

// Alu sig
  logic [31:0] scrA       = 0;
  logic [31:0] scrB       = 0;
  logic [31:0] alu_result    ;


  assign A1  = instr[19:15];
  assign A2  = instr[24:20];
  assign A3  = instr[11:7];
  assign RD1 = scrA;
  assign WD3 = f_mux_out;



// program_counter
  pc_reg i_pc_reg (
    .clk    (clk    ),
    .srst   (srst   ),
    .pc_next(pc_next),
    .pc     (pc     )  //PCF program counter reg output
  );

//pc + pc_next addr
  always @(*) begin : proc_
    pc_plus4  = 'd4 + pc;
    pc_target = pc + imm_ext;//we add pc and immediate result addr to jump or branch addr
  end

  //mux to select pc if pc src one then instead pc+4 ,pc+imm-ext to jump on that addr
  mux_2to1 i_mux_2to1 (
    .in1(pc_plus4 ),
    .in2(pc_target),
    .s  (pc_src   ),
    .out(pc_next  )
  );


// sign immediate extend module
  extend i_extend (
    .imm    (instr  ),
    .imm_src(imm_src),
    .imm_ext(imm_ext)  // o mux of alu
  );


//regsiter files
  register_file i_register_file (
    .clk (clk       ),
    .srst(srst      ),
    .A1  (A1        ),
    .A2  (A2        ),
    .A3  (A3        ),
    .WD3 (f_mux_out ), //final mux output from alu/memory/pc_target base on result_src
    .WE3 (reg_w     ),
    .RD1 (scrA      ),
    .RD2 (write_data)
  );


//selection of input of alu based on alu_src b/w data-from reg_file rd2 i.e write_data and immediate
  mux_2to1 i2_mux_2to1 (
    .in1(write_data),
    .in2(imm_ext   ), //from extended module
    .s  (alu_src   ),
    .out(scrB      )
  );


  ALU i_ALU (
    .a        (scrA       ),
    .b        (scrB       ),
    .alu_cntrl(alu_control),
    .result   (ALUresult  ), //alu_result forwarded to mux
    .zero     (zero       ), //for branch instr
    .negative (negative   ),
    .carry    (carry      ),
    .over_flow(over_flow  )
  );

//updated mux for lui and auipc intrs added selection mux for alu_result
// when lui intr utype immediate will be forwadred to alu_result; while auipc then utype_imm+pc is forwared
// this approach turn simplar handling hazard
  mux_4to1 alu_result_mux (
    .in1(alu_result ), //'00
    .in2(imm_ext    ),
    .in3(pc_target  ),
    .in4(pc_plus4   ), //when jump and jalr
    .s  ({auipc,lui}),
    .out(ALUresult  )
  );


// last mux select which data to be send to regfile based on result_src sig
//select b/w alu_result/pc_target/memory_data_out
  mux_4to1 i_mux_4to1 (
    .in1(ALUresult ),
    .in2(read_data ),
    .in3(pc_plus4  ),
    .in4('0        ),
    .s  (result_src),
    .out(f_mux_out )
  );


endmodule