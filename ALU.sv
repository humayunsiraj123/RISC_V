module ALU #(parameter WIDTH = 32) (
	input        [WIDTH-1:0] SrcA     ,
	input        [WIDTH-1:0] SrcB     ,
	input        [      5:0] alu_cntrl,
	output logic [WIDTH-1:0] result   ,
	output logic             zero     ,
	output logic             negative ,
	output logic             carry    ,
	output logic             over_flow
);

	logic [WIDTH-1:0] sum = 0;

	logic cout = 0;

	always_comb begin : proc_
		sum    = SrcA + srcB;
		result = 0;
		zero   = 0;
		if(alu_cntrl[5:4] == 2'b00)//alu_op type ......handled rtype itype lui auipc instr
			case(alu_cntrl[2:0])//{funct3}
				3'd0 : {carry,result} = alu_cntrl[3] ? (SrcA +  (~SrcB) +1 ) : (SrcA + SrcB);  // SUB/SUBI if f7[5]=1 else simple ADD/ADDI
				3'd1 : result         = SrcA << SrcB[4:0] ;//SLL/SLLI;
				3'd2 : result      	  = {'0,( SrcB != 0 && $signed(SrcA)< $signed(SrcB))};//set if srcA is less than srcB signed
				3'd3 : result         = {'0 , SrcA < SrcB};//unsiged set if SrcA less than SrcB;
				3'd4 : result         = SrcA ^ SrcB;//XOR/XORI
				3'd5 : result         = alu_cntrl[3] ? (SrcA >>> SrcB[4:0]) : (SrcA >> SrcB[4:0]);// f7[5]=1 SAR/SARI else SRL/SRLI
				3'd6 : result  		  = SrcA | SrcB; //OR/ORI
				3'd7 : result  		  = Src  & SrcB; //AND/ANDI
			endcase
		else if(alu_cntrl[5:4]==2'b01)//branch instr;
			case(alu_cntrl[2:0])//for brnach control we need to set only zero when meet conditions
				3'd0    : zero     	  = SrcA == SrcB; // BEQ
				3'd1    : zero     	  = SrcA != SrcB; //BNEQ
				3'd4    : zero     	  = $signed(SrcA) < $signed(SrcB) ; //BLT  SIGNED
				3'd5    : zero     	  = $signed(SrcA) >= $signed(SrcB); //BGE  SIGNED
				3'd5    : zero     	  = SrcA < SrcB  ;//BLT  UNSIGNED
				3'd7    : zero     	  = SrcA >= SrcB;  //BGE  UNSIGNED
				default : zero 	   	  = '0;
			endcase
		carry     = ~alu_cntrl[1] && cout;
		over_flow = (sum[31] ^ SrcA[31]) &&(~(SrcA[31] ^SrcB[31] ^ alu_cntrl[0])) && ~alu_cntrl[1];
		//zero      = &(!(sum));
		negative  = result[31];
	end

endmodule



// always_comb begin :alu_control
// 	{cout,sum} = alu_cntrl[0] ?  a + (1+ (~b)): a + b ;
// 	case (alu_cntrl[2:1])
// 		2'b00 : result = sum;
// 		2'b01 : result = sum;
// 		2'b10 : result = a & b;
// 		2'b11 : result = a | b;
// 	endcase


/*always_comb begin : proc_
sum =a+b;
result = 0;
case(alu_cntrl)
4'b000 : {carry,result} = a + b;
4'b001 : {carry,result} = a +  (~b) +1;
4'b010 : result = a & b;
4'b011 : result = a|b;
4'b101 : result[0] = a<b;//set if ais less than b
default: result = 0;
endcase
carry     =  ~alu_cntrl[1] && cout;
over_flow = (sum[31] ^ a[31]) &&(~(a[31] ^b[31] ^ alu_cntrl[0])) && ~alu_cntrl[1];
zero     = &(!(sum));
negative = result[31];


end*/
