module data_memory
(
	input clk,
	input srst,
	input [3:0]WE,
	input [31:0]A,
	input [31:0]WD,
	output logic [31:0]RD
	);
	logic [31:0] mem [4096:0] ;
logic [31:0] write_data;
initial begin
	/*foreach(mem[i]) begin
		mem[i]=i;
	end*/
	// mem[2]='h4;
	// mem[6]='hC;
	// mem[4]	= 'h8;
	// mem[8]	= 'hf;
	// mem[0] = 'h1A;

	// mem['h2000]='h10;
end

always_comb begin : proc_store_type
case(WE[3:1])//uper 3bit i.e funct3 bits to decide type of store
	3'b000: write_data = {'1,WD[7:0]};//store byte 
	3'b001: write_data = {'1,WD[15:0]};//store half word
	3'b010: write_data = WD; //store word
	default:write_data ='1;
end

// always_comb begin : proc_store_type
// case(WE[3:1])//uper 3bit i.e funct3 bits to decide type of store
// 	3'b000: write_data = {'0,WD[7:0]};//store byte 
// 	3'b001: write_data = {'0,WD[15:0]};//store half word
// 	3'b010: write_data = WD; //store word
// 	default:write_data ='0;
// end
	// using and operation to write only of desired size like byte or half byte by using  AND operation
	always @(posedge clk) begin 
		mem[A] <= WE[0] ? mem[A] & write_data :0;
	end

	always@(*) begin : proc_
	 	RD = srst? 0: mem[A];
	end

endmodule