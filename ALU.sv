module ALU #(parameter WIDTH=32) (
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

	always_comb begin : proc_
		sum    = SrcA+srcB;
		result = 0;
		if(alu_cntrl[5:4]==2'b00)//alu_op type

			case(alu_cntrl[3:0])//{funct7[5],funct3}
				3'd0    : {carry,result} = alu_cntrl[3] ? (SrcA +  (~SrcB) +1 ) : (SrcA + SrcB);  // sub if f7[5]=1 else simple add
				3'd1    : result         = SrcA << SrcB[4:0] ;//shift logic left
				3'd2    : result      	 = {'0,SrcA<SrcB};//set if srcA is less than srcB
				3'd2    : result         = SrcA & SrcB;//AND
				3'd3    : result         = SrcA|SrcB; //OR
				3'd4    : result         = SrcA<<SrcB;//left shift
				3'd6    : result[0]  	= (SrcB!=0 && $signed(SrcA)< $signed(SrcB)) ;//SLTU unsigned
				3'd7    : result  		= SrcA ^ SrcB; //xor
				3'd8    : result  		= SrcA>>SrcB; //right sifht
				3'd9    : result  		= SrcA>>>SrcB; //arthmetic right shift
				default : result 		= 0;
			endcase
		carry     = ~alu_cntrl[1] && cout;
		over_flow = (sum[31] ^ SrcA[31]) &&(~(SrcA[31] ^SrcB[31] ^ alu_cntrl[0])) && ~alu_cntrl[1];
		zero      = &(!(sum));
		negative  = result[31];


	end



endmodule
//ALU module
//  //ALU module

// module alu_block(SrcA, SrcB, ALU_Control, ALU_Output, zero);

// input [5:0] ALU_Control;

// input [31:0] SrcA, SrcB;

// output [31:0] ALU_Output;

// output zero;



// wire signed [31:0] signed_SrcA;

// wire signed [31:0] signed_SrcB;

// wire [31:0] sltu_result;

// wire [63:0] sra_result ;

// wire [63:0] Ext_SrcA;

// wire [31:0] sll_result;

// wire [31:0] srl_result;



// assign signed_SrcA = SrcA;

// assign signed_SrcB = SrcB;



// assign zero = (ALU_Output==0);



// assign sltu_result = {31'b0, SrcA<SrcB};

// assign sltu_result_signed = {31'b0, signed_SrcA<signed_SrcB};

// assign Ext_SrcA = {{32{SrcA[31]}}, SrcA};

// assign sra_result = Ext_SrcA >> SrcB[4:0];

// assign sll_result = SrcA << SrcB[4:0];

// assign srl_result = SrcA >> SrcB[4:0];



// assign ALU_Output =

// (ALU_Control == 6'b000_000)? SrcA + SrcB: /* ADD, ADDI*/

// (ALU_Control == 6'b001_000)? SrcA - SrcB: /* SUB */

// (ALU_Control == 6'b000_100)? SrcA ^ SrcB: /* XOR, XORI*/

// (ALU_Control == 6'b000_110)? SrcA | SrcB: /* OR, ORI */

// (ALU_Control == 6'b000_111)? SrcA & SrcB: /* AND, ANDI */

// (ALU_Control == 6'b000_010)? sltu_result_signed: /* SLT, SLTI */

// (ALU_Control == 6'b000_011)? sltu_result: /* SLTU, SLTIU */

// (ALU_Control == 6'b000_001)? sll_result: /* SLL, SLLI => 0's shifted in from right */

// (ALU_Control == 6'b000_101)? srl_result: /* SRL, SRLI => 0's shifted in from left */

// (ALU_Control == 6'b001_101)? sra_result[31:0]: /* SRA, SRAI => sign bit shifted in from left */

// (ALU_Control == 6'b011_111)? SrcB: /* LUI */

// (ALU_Control == 6'b010_000)? SrcA - SrcB: /* BEQ */

// (ALU_Control == 6'b010_001)? SrcA == SrcB: /* BNE */

// (ALU_Control == 6'b010_100)? signed_SrcA < signed_SrcB: /* BLT */

// (ALU_Control == 6'b010_101)? signed_SrcA >= signed_SrcB: /* BGE */

// (ALU_Control == 6'b010_110)? SrcA < SrcB: /* BLTU */

// (ALU_Control == 6'b010_111)? SrcA >= SrcB: 32'b0; /* BGEU */

// endmodule