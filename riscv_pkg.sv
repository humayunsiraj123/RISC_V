package riscv_pkg;

	typedef struct packed {
		logic [1:0] alu_op    ;
		logic       branch    ;
		logic       jump      ;
		logic [1:0] result_src;
		logic [3:0] mem_w     ; //lsb cntrl sig and [3:1] funct3;
		logic       alu_src   ;
		logic [2:0] imm_src   ;
		logic [3:0] reg_w     ; //lsb cntrl sig and [3:1] funct3;
		logic       pc_update ;
		logic       lui       ;
		logic       auipc     ;
	} cntrl_sigs_t ;


endpackage