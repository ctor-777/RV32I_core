library ieee;
use ieee.std_logic_1164.all;

library work;
use work.types_pkg.all;

ENTITY memory_stage IS
	PORT(
		pipeline_in: in ex_to_mem_rec_t;
		pipeline_out: out mem_to_wb_rec_t;

		-- RAM bus (port B)
		addr_b: out data_word_t;
		we_b: out std_logic;
		out_b: out data_word_t;
		in_b: in data_word_t;

		-- clock
		clk: in std_logic);

END ENTITY memory_stage;

ARCHITECTURE rtl OF memory_stage IS
BEGIN
	-- RAM signals (synchronized in the memory module)
	addr_b <= pipeline_in.alu_result;
	we_b <= pipeline_in.mem_write;
	out_b <= pipeline_in.rs2_data;
	pipeline_out.mem_data <= in_b;

	-- non RAM related signals
	PROCESS(clk)
	BEGIN
		IF rising_edge(clk)
		THEN
			pipeline_out.alu_result <= pipeline_in.alu_result;
			pipeline_out.rd_addr <= pipeline_in.rd_addr;

			-- control
			pipeline_out.reg_write <= pipeline_in.reg_write;
			pipeline_out.mem_to_reg <= pipeline_in.mem_to_reg;
		END IF;
	END PROCESS;

END ARCHITECTURE rtl;


