module alu_decoder (
  input  [2:0] funct3     ,
  input  [6:0] funct7     ,
  input  [6:0] op_code    ,
  input  [1:0] alu_op     ,
  output logic [2:0] alu_control
);

logic [1:0]op_funct7;


/*0110011 (51) 000 0000000 R add rd, rs1, rs2 add rd = rs1 + rs2
0110011 (51) 000 0100000 R sub rd, rs1, rs2 sub rd = rs1 — rs2
0110011 (51) 001 0000000 R sll rd, rs1, rs2 shift left logical rd = rs1 << rs24:0
0110011 (51) 010 0000000 R slt rd, rs1, rs2 set less than rd = (rs1 < rs2)
0110011 (51) 011 0000000 R sltu rd, rs1, rs2 set less than unsigned rd = (rs1 < rs2)
0110011 (51) 100 0000000 R xor rd, rs1, rs2 xor rd = rs1 ^ rs2
0110011 (51) 101 0000000 R srl rd, rs1, rs2 shift right logical rd = rs1 >> rs24:0
0110011 (51) 101 0100000 R sra rd, rs1, rs2 shift right arithmetic rd = rs1 >>> rs24:0
0110011 (51) 110 0000000 R or rd, rs1, rs2 or rd = rs1 | rs2
0110011 (51) 111 0000000 R and rd, rs1, rs2 and rd = rs1 & rs2
*/
/*  always_comb begin : proc_alu_deocder
    op_funct7 = {op_code[5],funct7[5]};
    if(alu_op==0)
      alu_control = 3'b000;//add lw,sw instr
    else if(alu_op==2'b01)
      alu_control = 3'b001;//sub branch
    else if(alu_op==2'b10)
      begin
        case(funct3)
          'b000 : begin 
              if(op_funct7==2'b11)
                alu_control =  3'b001;//sub
              else
                alu_control =  3'b000;
          end 
          'b010 : alu_control =  3'b101;//slt
          'b110 : alu_control =  3'b011;//or
          'b111 : alu_control =  3'b010;//and
          default:alu_control =  3'bxxx;//
        endcase // {funct3,op_code[5],funct7[5]}
      end
  end*/

always_comb begin 
casez({op_code[5],funct7[5],funct3})
 'b10_000 : alu_control = 4'd0;// add reg
 'b11_000 : alu_control = 4'd1; // sub reg
 'b10_001 : alu_control = 4'd4; // sll shift logic left  
 'b10_010 : alu_control = 4'd5; // slt set less than
 'b10_011 : alu_control = 4'd5; // sltu usinged
 'b10_100 : alu_control = 4'd7; // xor
 'b10_101 : alu_control = 4'd8; // shift right logic
 'b11_101 : alu_control = 4'd9; // Shift arthmetic right
 'b10_110 : alu_control = 4'd3; // or
 'b10_111 : alu_control = 4'd2; // and
  endcase
end








endmodule : alu_decoder