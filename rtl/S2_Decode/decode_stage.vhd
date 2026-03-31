library ieee;
use ieee.std_logic_1164.all;

library work;
use work.types_pkg.all;


ENTITY decode_stage IS
	PORT(
		clk				: in STD_LOGIC;
		fetched_instr	: in data_word_t;
		pipeline_in		: in pc_to_fd_rec_t;
		pipeline_out	: out fd_to_ex_rec_t);

END ENTITY decode_stage;

ARCHITECTURE rtl OF decode_stage IS
    -- opcode for the fetched instruction (same position for all formats)
    signal opcode : opcode_t;

    -- unpacked instruction records
    signal r_rec : r_type_t;
    signal i_rec : i_type_t;
    signal s_rec : s_type_t;
    signal u_rec : u_type_t;
BEGIN
    pipeline_out.pc      <= pipeline_in.pc;
    pipeline_out.instr   <= fetched_instr;

	-- common opcode field
	opcode <= fetched_instr(6 downto 0);

	-- R-type fields
	r_rec.funct7 <= fetched_instr(31 downto 25);
	r_rec.rs2    <= fetched_instr(24 downto 20);
	r_rec.rs1    <= fetched_instr(19 downto 15);
	r_rec.funct3 <= fetched_instr(14 downto 12);
	r_rec.rd     <= fetched_instr(11 downto 7);

	-- I-type immediate (sign-extended)
	i_rec.rd     <= fetched_instr(11 downto 7);
	i_rec.funct3 <= fetched_instr(14 downto 12);
	i_rec.rs1    <= fetched_instr(19 downto 15);
	i_rec.imm    <= (31 downto 12 => fetched_instr(31)) & fetched_instr(31 downto 20);

	-- S-type fields and immediate (sign-extended)
	s_rec.funct3 <= fetched_instr(14 downto 12);
	s_rec.rs1    <= fetched_instr(19 downto 15);
	s_rec.rs2    <= fetched_instr(24 downto 20);
	s_rec.imm    <= (31 downto 12 => fetched_instr(31)) & fetched_instr(31 downto 25) & fetched_instr(11 downto 7);

	-- U-type fields
	u_rec.rd     <= fetched_instr(11 downto 7);
	u_rec.imm    <= fetched_instr(31 downto 12) & (11 downto 0 => '0');

	PROCESS (pipeline_in, clk, fetched_instr) BEGIN IF rising_edge(clk) THEN
		CASE opcode IS
			WHEN others => null;
		END CASE;
	END IF; END PROCESS;
END ARCHITECTURE rtl;
