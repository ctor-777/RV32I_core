library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

library work;
use work.types_pkg.all;

ENTITY PC_stage IS
	PORT(
		clk				: in STD_LOGIC;
		pipeline_out	: out pc_to_fd_rec_t;
		fetch_addr		: out data_word_t);
END ENTITY PC_stage;

ARCHITECTURE rtl OF PC_stage IS
	signal pc	: data_word_t := (others => '0');
BEGIN
	PROCESS (clk) BEGIN IF rising_edge(clk) THEN
		pc <= STD_LOGIC_VECTOR(unsigned(pc) + 1);
		pipeline_out.pc <= pc;
	END IF; END PROCESS;

	fetch_addr <= pc;

END ARCHITECTURE rtl;
