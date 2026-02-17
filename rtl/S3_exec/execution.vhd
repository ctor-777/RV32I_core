library ieee;
use ieee.std_logic_1164.all;

library work;
use work.types_pkg.all;

ENTITY execution_stage IS
	Port( 
		pipeline_in: in fd_to_ex_rec_t;
		clk: in std_logic;
		pipeline_out: out ex_to_mem_rec_t);
END ENTITY execution_stage;

ARCHITECTURE behavioral OF execution_stage IS
	signal ALU_val2: data_word_t;
	signal ALU_out: data_word_t;
BEGIN

	ALU_val2 <= pipeline_in.imm WHEN pipeline_in.alu_src = '1' ELSE
				pipeline_in.rs2_data;

	ALU_inst: entity work.ALU
		PORT MAP(
			val1 => pipeline_in.rs1_data,
			val2 => ALU_val2,
			op => pipeline_in.alu_op,
			out_val => ALU_out);
	
	PROCESS(clk) 
	BEGIN
		IF (rising_edge(clk)) THEN
			pipeline_out.alu_result <= ALU_out;
			pipeline_out.rs2_data <= pipeline_in.rs2_data;
			pipeline_out.rd_addr <= pipeline_in.rd_addr;

			pipeline_out.reg_write <= pipeline_in.reg_write;
			pipeline_out.mem_read <= pipeline_in.mem_read;
			pipeline_out.mem_write <= pipeline_in.mem_write;
			pipeline_out.mem_to_reg <= pipeline_in.mem_to_reg;
		END IF;
	END PROCESS;

END ARCHITECTURE behavioral;
