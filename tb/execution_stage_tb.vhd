library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity execution_stage_tb is
end entity execution_stage_tb;

architecture tb of execution_stage_tb is
    signal clk : std_logic := '0';
    signal pipeline_in_sig : fd_to_ex_rec_t;
    signal pipeline_out_sig : ex_to_mem_rec_t;
begin

    uut: entity work.execution_stage(behavioral)
        port map(
            pipeline_in => pipeline_in_sig,
            clk => clk,
            pipeline_out => pipeline_out_sig
        );

    clk_proc: process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    stim_proc: process
    begin
        -- initialize fields
        pipeline_in_sig.rs1_data <= (others => '0');
        pipeline_in_sig.rs2_data <= (others => '0');
        pipeline_in_sig.imm <= (others => '0');
        pipeline_in_sig.rd_addr <= (others => '0');
        pipeline_in_sig.alu_op <= (others => '0');
        pipeline_in_sig.alu_src <= '0';
        pipeline_in_sig.reg_write <= '0';
        pipeline_in_sig.mem_read <= '0';
        pipeline_in_sig.mem_write <= '0';
        pipeline_in_sig.mem_to_reg <= '0';

        wait for 10 ns;

        -- Test 1: ADD using registers
        pipeline_in_sig.rs1_data <= std_logic_vector(to_unsigned(5,32));
        pipeline_in_sig.rs2_data <= std_logic_vector(to_unsigned(7,32));
        pipeline_in_sig.alu_op <= ALU_ADD;
        pipeline_in_sig.alu_src <= '0';
        pipeline_in_sig.rd_addr <= "00001";
        pipeline_in_sig.reg_write <= '1';
        wait until rising_edge(clk);
        wait for 1 ns; -- allow outputs to settle
        assert pipeline_out_sig.alu_result = std_logic_vector(to_unsigned(12,32))
            report "execution_stage ADD (reg) failed" severity error;
        assert pipeline_out_sig.rs2_data = std_logic_vector(to_unsigned(7,32))
            report "rs2_data not forwarded" severity error;
        assert pipeline_out_sig.rd_addr = "00001"
            report "rd_addr not forwarded" severity error;

        -- Test 2: ADD using immediate
        pipeline_in_sig.rs1_data <= std_logic_vector(to_unsigned(10,32));
        pipeline_in_sig.imm <= std_logic_vector(to_unsigned(3,32));
        pipeline_in_sig.alu_op <= ALU_ADD;
        pipeline_in_sig.alu_src <= '1'; -- use immediate
        pipeline_in_sig.rd_addr <= "00010";
        wait until rising_edge(clk);
        wait for 1 ns;
        assert pipeline_out_sig.alu_result = std_logic_vector(to_unsigned(13,32))
            report "execution_stage ADD (imm) failed" severity error;
        assert pipeline_out_sig.rd_addr = "00010"
            report "rd_addr not forwarded (imm)" severity error;

        report "execution_stage testbench finished" severity note;
        wait; -- stop here
    end process;

end architecture tb;
