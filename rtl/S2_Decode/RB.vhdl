library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;


ENTITY RB IS
	PORT(
			clk		: in std_logic;
			-- port a and b (read)
			addr_a	: in reg_addr_t;
			addr_b	: in reg_addr_t;

			data_a	: out data_word_t;
			data_b	: out data_word_t;
			-- port c (write)
			addr_d	: in reg_addr_t;
			data_d	: in data_word_t;
			we_reg	: in std_logic -- write enable
		);


END ENTITY RB;

ARCHITECTURE rtl OF RB IS
	constant REGFILE_SIZE: natural := 32;
	type regfile_t is array (REGFILE_SIZE-1 downto 0) of data_word_t;

	signal regfile: regfile_t;
BEGIN

	data_a <= regfile(to_integer(unsigned(addr_a)));
	data_b <= regfile(to_integer(unsigned(addr_b)));

	PROCESS (clk, addr_d, data_d, we_reg) BEGIN IF rising_edge(clk) THEN
		IF (we_reg = '1') THEN
			regfile(to_integer(unsigned(addr_d))) <= data_d;
		END IF;
	END IF; END PROCESS;

END ARCHITECTURE;
