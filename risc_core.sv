module risc_core(
  input clk,
  input srst,
  );

logic [31:0]pc_next=0;
logic [31:0]pc =0;


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


  logic [31:0] Addr;
  logic [31:0] RD;

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




endmodule : risc_core
