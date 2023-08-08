module data_path (
  input clk,    // Clock
  input srst,  // Asynchronous reset active low
);

  logic [31:0] pc_next;
  logic [31:0] pc;

  logic [31:0] Addr;
  logic [31:0] RD;

  logic [11:0] imm;
  logic [31:0] imm_ext;

// program_counter 
pc_reg i_pc_reg (
  .clk    (clk    ),
  .srst   (srst   ),
  .pc_next(pc_next),
  .pc     (pc     )
);
//pc + pc_next addr
always @(*) begin : proc_
 pc_next = 'd4 + pc;
end


//instruction memory
instr_mem i_instr_mem (
  .Addr(Addr),
  .RD(RD)
  );

  logic [11:0] imm;
  logic [31:0] imm_ext;

extende i_extende (
  .imm(imm), 
  .imm_ext(imm_ext));


  logic [4:0] A1;
  logic [4:0] A2;
  logic [4:0] A3;
  logic WE3;
  logic [31:0] RD1;
  logic [31:0] RD2;

register_file i_register_file (
  .A1 (A1 ),
  .A2 (A2 ),
  .A3 (A3 ),
  .WE3(WE3),
  .RD1(RD1),
  .RD2(RD2)
);


  logic [31:0] a;
  logic [31:0] b;
  logic [2:0] alu_cntrl;
  logic [31:0] result;
  logic zero;
  logic negative;
  logic carry;
  logic over_flow;
ALU i_ALU (
  .a        (a        ),
  .b        (b        ),
  .alu_cntrl(alu_cntrl),
  .result   (result   ),
  .zero     (zero     ),
  .negative (negative ),
  .carry    (carry    ),
  .over_flow(over_flow)
);


  logic [31:0] in1;
  logic [31:0] in2;
  logic s;
  logic [31:0] out;

mux_2to1 i_mux_2to1 (
  .in1(in1),
  .in2(in2),
  .s  (s  ),
  .out(out)
);


  logic WE;
  logic [31:0] A;
  logic [31:0] WD;
data_memory i_data_memory (
  .clk (clk ),
  .srst(srst),
  .WE  (WE  ),
  .A   (A   ),
  .WD  (WD  ),
  .RD  (RD  )
);




endmodule