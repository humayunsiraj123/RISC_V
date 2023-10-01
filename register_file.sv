module register_file(
	input clk,
	input srst,
	input[4:0]A1,
	input[4:0]A2,
	input[4:0]A3,
	input[31:0]WD3,
	input[3:0]WE3,
	output logic [31:0]RD1,
	output logic [31:0]RD2

	);

logic[31:0][31:0] memory;

logic[31:0] load_type;
initial begin
//lw instr
memory[0]  ='0;
memory[5]  ='d5;// example 1 x5
memory[9] ='h8;//x9

end

always_comb
 case(WE[3:1])
 	3'd0:load_type = {{24{data_in[31]}},data_in[7:0]};// load byte 
 	3'd1:load_type = {{16{data_in[31]}},data_in[15:0]};// load half 
 	3'd2:load_type = data_in;// load WORD 
 	3'd4:load_type = {'0,data_in[7:0]};// load byte unsigned 
 	3'd5:load_type = {'0,data_in[15:0]};// load half unsigned 
 	default : load_type = data_in;

always @(posedge clk) begin : proc_regiter_files
	if(WE3[0])
		memory[A3] <= load_type ;
	end

always @(*) begin : proc_RD_x
RD2 = srst ? 0: memory[A2];
RD1 = srst ? 0: memory[A1];
end



endmodule : register_file