library ieee;
use ieee.std_logic_1164.all;
use std.textio.all; -- Required for file I/O
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

ENTITY DP_RAM IS
	GENERIC(
			RAM_SIZE: integer := 1024;
			RAM_INIT_FILE: string := "zero.hex"
		   );
	PORT(
			clk: in std_logic;
			
			-- port a (fetch)
			addr_a: in data_word_t;
			out_a: out data_word_t;
			
			-- port b (memory operations)
			addr_b: in data_word_t;
			we_b: in std_logic;
			in_b: in data_word_t;
			out_b: out data_word_t);

END ENTITY DP_RAM;

ARCHITECTURE rtl OF DP_RAM IS
	type ram_type is array (0 to RAM_SIZE - 1) of data_word_t;

	-- Function to load the RAM from a text file
    impure function init_ram_from_file(file_name : in string) return ram_type is
        file text_file       : text open read_mode is file_name;
        variable text_line   : line;
        variable ram_content : ram_type := (others => (others => '0'));
        variable hex_val     : std_logic_vector(31 downto 0);
    begin
        for i in 0 to RAM_SIZE - 1 loop
            if not endfile(text_file) then
                readline(text_file, text_line);
                hread(text_line, hex_val); -- Read hex value from line
                ram_content(i) := hex_val;
            end if;
        end loop;
        return ram_content;
    end function;

	-- Initialize the signal using the function
    signal ram_block : ram_type := init_ram_from_file(RAM_INIT_FILE);
BEGIN
	PROCESS(clk)
	BEGIN
		IF rising_edge(clk) THEN

			out_a <= ram_block(to_integer(unsigned(addr_a(31 downto 2))));

			IF (we_b = '1') THEN
				ram_block(to_integer(unsigned(addr_b(31 downto 2)))) <= in_b;
			END IF;

			out_b <= ram_block(to_integer(unsigned(addr_b(31 downto 2))));
		END IF;

	END PROCESS;
END ARCHITECTURE rtl;
