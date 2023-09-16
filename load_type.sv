module load_type(
	input [2:0]funct3,
	input [31:0]data_in,
	output logic [31:0] data_out);

always_comb
 case(funct3)
 	3'd0:data_out = {{24{data_in[31]}},data_in[7:0]};// load byte 
 	3'd1:data_out = {{16{data_in[31]}},data_in[15:0]};// load half 
 	3'd2:data_out = data_in;// load WORD 
 	3'd4:data_out = {'0,data_in[7:0]};// load byte unsigned 
 	3'd5:data_out = {'0,data_in[15:0]};// load half unsigned 
 	default : data_out = data_in;
endmodule : load_type