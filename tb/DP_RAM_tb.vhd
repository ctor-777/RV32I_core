library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity DP_RAM_tb is
end entity DP_RAM_tb;

architecture tb of DP_RAM_tb is
    signal clk : std_logic := '0';
    signal addr_a : data_word_t := (others => '0');
    signal out_a : data_word_t;
    signal addr_b : data_word_t := (others => '0');
    signal we_b : std_logic := '0';
    signal in_b : data_word_t := (others => '0');
    signal out_b : data_word_t;
begin

    uut: entity work.DP_RAM(rtl)
        generic map (
            RAM_SIZE => 1024,
            RAM_INIT_FILE => "tb/dp_ram_init.hex"
        )
        port map (
            clk => clk,
            addr_a => addr_a,
            out_a => out_a,
            addr_b => addr_b,
            we_b => we_b,
            in_b => in_b,
            out_b => out_b
        );

    clk_proc: process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process clk_proc;

    stim_proc: process
    begin
        -- Allow time for initialization and a couple clock cycles
        wait for 20 ns;

        -- Check initial values from hex file (addresses are byte addresses; words are 4 bytes)
        addr_a <= std_logic_vector(to_unsigned(0*4, 32));
        wait for 10 ns;
        assert out_a = x"DEADBEEF" report "DP_RAM init mismatch at addr 0" severity error;

        addr_a <= std_logic_vector(to_unsigned(1*4, 32));
        wait for 10 ns;
        assert out_a = x"00000001" report "DP_RAM init mismatch at addr 1" severity error;

        addr_a <= std_logic_vector(to_unsigned(2*4, 32));
        wait for 10 ns;
        assert out_a = x"01234567" report "DP_RAM init mismatch at addr 2" severity error;

        -- Test write via port B
        addr_b <= std_logic_vector(to_unsigned(10*4, 32));
        in_b <= x"12345678";
        we_b <= '1';
        wait for 10 ns;
        we_b <= '0';
        wait for 10 ns;

        -- Read back via port A
        addr_a <= std_logic_vector(to_unsigned(10*4, 32));
        wait for 10 ns;
        assert out_a = x"12345678" report "DP_RAM write/read mismatch at addr 10" severity error;

        report "DP_RAM testbench finished" severity note;
        wait;
    end process stim_proc;
end architecture tb;
