module alu_decoder (
  input  [2:0] funct3     ,
  input  [6:0] funct7     ,
  input  [6:0] op_code    ,
  input  [1:0] alu_op     ,
  output logic [5:0] alu_control //{op[1:0],fun7[5],funct3[2:0]};
);

//lui,aupic jal, jalr instr are are using another adder that result pc+imm/pc+4 so instead designing
//alu decode for above instr we have handled them in main decoder as the reesult generate from thsi is forward using
//mux that select either alu_result is forward to next stage or mux other input base on cntrol sig auipc lui 
always_comb begin 
  if(alu_op = 2'b00) //load ,store, lui,auipc,jal,jalr
    alu_control = 6'b00_0_000;//add
  else if(alu_op = 2'b10)
    alu_control  = {2'b00,funct7[5],funct3};//to handle r_type and itype instr
  else if(alu_op = 2'b01)
    alu_control  = {2'b01,funct7[5],funct3};//to handle branch inst
  else
    alu_control ='0;
end

//   always_comb begin : proc_alu_deocder
  
//     if(alu_op==2'b00)//load ,store instr,
//       alu_control = 'b000;
//     else if(alu_op==2'b01)
//       alu_control = 3'b001;//sub branch
//     else if(alu_op==2'b10)//itype and rtype
//       begin
//         casez(funct3)
//           'b000 : begin 
//               if(op_funct7==2'b11)
//                 alu_control =  3'b001;//sub
//               else
//                 alu_control =  3'b000;
//           end 
//           'b010 : alu_control =  3'b101;//slt
//           'b110 : alu_control =  3'b011;//or
//           'b111 : alu_control =  3'b010;//and
//           default:alu_control =  3'bxxx;//
//         endcase // {funct3,op_code[5],funct7[5]}
//       end
//   end

// always_comb begin 
// casez({op_code[5],funct7[5],funct3})
//  'b10_000 : alu_control = 4'd0;// add reg
//  'b11_000 : alu_control = 4'd1; // sub reg
//  'b10_001 : alu_control = 4'd4; // sll shift logic left  
//  'b10_010 : alu_control = 4'd5; // slt set less than
//  'b10_011 : alu_control = 4'd5; // sltu usinged
//  'b10_100 : alu_control = 4'd7; // xor
//  'b10_101 : alu_control = 4'd8; // shift right logic
//  'b11_101 : alu_control = 4'd9; // Shift arthmetic right
//  'b10_110 : alu_control = 4'd3; // or
//  'b10_111 : alu_control = 4'd2; // and
//   endcase
// end








endmodule : alu_decoder