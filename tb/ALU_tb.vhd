library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity ALU_tb is
end entity ALU_tb;

architecture tb of ALU_tb is
    signal val1_sig : data_word_t := (others => '0');
    signal val2_sig : data_word_t := (others => '0');
    signal op_sig   : alu_op_t := (others => '0');
    signal out_sig  : data_word_t;
begin

    uut: entity work.ALU(rtl)
        port map(
            val1 => val1_sig,
            val2 => val2_sig,
            op => op_sig,
            out_val => out_sig
        );

    stim_proc: process
    begin
        -- ADD
        val1_sig <= std_logic_vector(to_unsigned(5,32));
        val2_sig <= std_logic_vector(to_unsigned(7,32));
        op_sig <= ALU_ADD;
        wait for 1 ns;
        assert out_sig = std_logic_vector(to_unsigned(12,32)) report "ADD failed" severity error;
        wait for 1 ns;

        -- SUB
        val1_sig <= std_logic_vector(to_unsigned(10,32));
        val2_sig <= std_logic_vector(to_unsigned(3,32));
        op_sig <= ALU_SUB;
        wait for 1 ns;
        assert out_sig = std_logic_vector(to_unsigned(7,32)) report "SUB failed" severity error;
        wait for 1 ns;

        -- SLL
        val1_sig <= std_logic_vector(to_unsigned(1,32));
        val2_sig <= std_logic_vector(to_unsigned(1,32));
        op_sig <= ALU_SLL;
        wait for 1 ns;
        assert out_sig = std_logic_vector(to_unsigned(2,32)) report "SLL failed" severity error;
        wait for 1 ns;

        -- SRL
        val1_sig <= std_logic_vector(to_unsigned(4,32));
        val2_sig <= std_logic_vector(to_unsigned(1,32));
        op_sig <= ALU_SRL;
        wait for 1 ns;
        assert out_sig = std_logic_vector(to_unsigned(2,32)) report "SRL failed" severity error;
        wait for 1 ns;

        -- SRA
        val1_sig <= std_logic_vector(to_signed(-4,32));
        val2_sig <= std_logic_vector(to_unsigned(1,32));
        op_sig <= ALU_SRA;
        wait for 1 ns;
        assert out_sig = std_logic_vector(to_signed(-2,32)) report "SRA failed" severity error;
        wait for 1 ns;

        -- AND
        val1_sig <= std_logic_vector(to_unsigned(6,32));
        val2_sig <= std_logic_vector(to_unsigned(3,32));
        op_sig <= ALU_AND;
        wait for 1 ns;
        assert out_sig = std_logic_vector(to_unsigned(2,32)) report "AND failed" severity error;
        wait for 1 ns;

        -- OR
        val1_sig <= std_logic_vector(to_unsigned(4,32));
        val2_sig <= std_logic_vector(to_unsigned(1,32));
        op_sig <= ALU_OR;
        wait for 1 ns;
        assert out_sig = std_logic_vector(to_unsigned(5,32)) report "OR failed" severity error;
        wait for 1 ns;

        -- XOR
        val1_sig <= std_logic_vector(to_unsigned(5,32));
        val2_sig <= std_logic_vector(to_unsigned(1,32));
        op_sig <= ALU_XOR;
        wait for 1 ns;
        assert out_sig = std_logic_vector(to_unsigned(4,32)) report "XOR failed" severity error;
        wait for 1 ns;

        -- SLTU
        val1_sig <= std_logic_vector(to_unsigned(2,32));
        val2_sig <= std_logic_vector(to_unsigned(3,32));
        op_sig <= ALU_SLTU;
        wait for 1 ns;
        assert out_sig = std_logic_vector(to_unsigned(1,32)) report "SLTU failed" severity error;
        wait for 1 ns;

        -- SLT
        val1_sig <= std_logic_vector(to_signed(-1,32));
        val2_sig <= std_logic_vector(to_signed(1,32));
        op_sig <= ALU_SLT;
        wait for 1 ns;
        assert out_sig = std_logic_vector(to_unsigned(1,32)) report "SLT failed" severity error;
        wait for 1 ns;

        report "ALU testbench finished" severity note;
        wait;
    end process;

end architecture tb;
