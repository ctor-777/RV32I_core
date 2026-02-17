library ieee;
use ieee.std_logic_1164.all;

package types_pkg is

	-- =========================================================================
    -- BASIC DATA TYPES
    -- =========================================================================
    -- RV32I is a 32-bit architecture. PC, Memory Addresses, and Data are all 32 bits.
    subtype data_word_t is std_logic_vector(31 downto 0); 
    
    -- Instruction field types based on the RV32I encoding
    subtype opcode_t is std_logic_vector(6 downto 0);  -- bits [6:0] 
    subtype funct3_t is std_logic_vector(2 downto 0);  -- bits [14:12] 
    subtype funct7_t is std_logic_vector(6 downto 0);  -- bits [31:25] 
    
    -- Register addresses are 5 bits (allowing for 32 registers) 
    subtype reg_addr_t is std_logic_vector(4 downto 0);
	
    -- =========================================================================
    -- OPCODES (7-bit)
    -- =========================================================================
    constant LUI_OP    : std_logic_vector(6 downto 0) := "0110111";
    constant AUIPC_OP  : std_logic_vector(6 downto 0) := "0010111"; 
    constant JAL_OP    : std_logic_vector(6 downto 0) := "1101111";
    constant JALR_OP   : std_logic_vector(6 downto 0) := "1100111";
    constant BR_OP     : std_logic_vector(6 downto 0) := "1100011"; 
    constant MEML_OP   : std_logic_vector(6 downto 0) := "0000011"; 
    constant MEMS_OP   : std_logic_vector(6 downto 0) := "0100011"; 
    constant IRI_OP    : std_logic_vector(6 downto 0) := "0010011"; -- ADDI, SLTI, etc.
    constant IRR_OP    : std_logic_vector(6 downto 0) := "0110011"; -- ADD, SUB, etc.
    constant FENCE_OP  : std_logic_vector(6 downto 0) := "0001111";
    constant SYS_OP    : std_logic_vector(6 downto 0) := "1110011"; -- ECALL, EBREAK

    -- =========================================================================
    -- FUNCT3 (3-bit) 
    -- =========================================================================
    
    -- Branch Instructions (BR_OP)
    constant F3_BEQ    : std_logic_vector(2 downto 0) := "000";
    constant F3_BNE    : std_logic_vector(2 downto 0) := "001";
    constant F3_BLT    : std_logic_vector(2 downto 0) := "100";
    constant F3_BGE    : std_logic_vector(2 downto 0) := "101";
    constant F3_BLTU   : std_logic_vector(2 downto 0) := "110";
    constant F3_BGEU   : std_logic_vector(2 downto 0) := "111";

    -- Memory Load Instructions (MEML_OP)
    constant F3_LB     : std_logic_vector(2 downto 0) := "000";
    constant F3_LH     : std_logic_vector(2 downto 0) := "001";
    constant F3_LW     : std_logic_vector(2 downto 0) := "010";
    constant F3_LBU    : std_logic_vector(2 downto 0) := "100";
    constant F3_LHU    : std_logic_vector(2 downto 0) := "101";

    -- Memory Store Instructions (MEMS_OP)
    constant F3_SB     : std_logic_vector(2 downto 0) := "000";
    constant F3_SH     : std_logic_vector(2 downto 0) := "001";
    constant F3_SW     : std_logic_vector(2 downto 0) := "010";

    -- ALU / Integer Instructions (IRI_OP & IRR_OP)
    constant F3_ADD_SUB: std_logic_vector(2 downto 0) := "000"; -- ADDI, ADD, SUB
    constant F3_SLL    : std_logic_vector(2 downto 0) := "001"; -- SLLI, SLL
    constant F3_SLT    : std_logic_vector(2 downto 0) := "010"; -- SLTI, SLT
    constant F3_SLTU   : std_logic_vector(2 downto 0) := "011"; -- SLTIU, SLTU
    constant F3_XOR    : std_logic_vector(2 downto 0) := "100"; -- XORI, XOR
    constant F3_SR     : std_logic_vector(2 downto 0) := "101"; -- SRLI, SRAI, SRL, SRA
    constant F3_OR     : std_logic_vector(2 downto 0) := "110"; -- ORI, OR
    constant F3_AND    : std_logic_vector(2 downto 0) := "111"; -- ANDI, AND

    -- System (SYS_OP)
    constant F3_PRIV   : std_logic_vector(2 downto 0) := "000"; -- ECALL, EBREAK

    -- =========================================================================
    -- FUNCT7 (7-bit) 
    -- Used mainly to differentiate ADD/SUB and logical/arithmetic shifts
    -- =========================================================================
    
    constant F7_BASIC  : std_logic_vector(6 downto 0) := "0000000"; -- ADD, SRL, etc.
    constant F7_ALT    : std_logic_vector(6 downto 0) := "0100000"; -- SUB, SRA, SRAI

	-- =========================================================================
    -- ALU OPERATION TYPES & CONSTANTS
    -- =========================================================================
    subtype alu_op_t is std_logic_vector(3 downto 0);

    -- Arithmetic & Logic (Derived from RV32I requirements )
    constant ALU_ADD  : alu_op_t := "0000"; -- Addition (ADD, ADDI, AUIPC, Load/Store addr)
    constant ALU_SUB  : alu_op_t := "1000"; -- Subtraction (SUB)
    constant ALU_SLL  : alu_op_t := "0001"; -- Shift Left Logical (SLL, SLLI)
    constant ALU_SLT  : alu_op_t := "0010"; -- Set Less Than Signed (SLT, SLTI)
    constant ALU_SLTU : alu_op_t := "0011"; -- Set Less Than Unsigned (SLTU, SLTIU)
    constant ALU_XOR  : alu_op_t := "0100"; -- Bitwise XOR (XOR, XORI)
    constant ALU_SRL  : alu_op_t := "0101"; -- Shift Right Logical (SRL, SRLI)
    constant ALU_SRA  : alu_op_t := "1101"; -- Shift Right Arithmetic (SRA, SRAI)
    constant ALU_OR   : alu_op_t := "0110"; -- Bitwise OR (OR, ORI)
    constant ALU_AND  : alu_op_t := "0111"; -- Bitwise AND (AND, ANDI)

	-- =========================================================================
    -- PIPELINE STAGE RECORDS
    -- =========================================================================

    -- 1. Stage 1 (PC) -> Stage 2 (Fetch/Decode)
    -- This record carries the address generated by your first stage.
    type pc_to_fd_rec_t is record
        pc          : pc_t;
    end record;

    -- 2. Stage 2 (Fetch/Decode) -> Stage 3 (Execute)
    -- After fetching the instruction and decoding it, pass everything to EX.
    type fd_to_ex_rec_t is record
        pc          : pc_t;
        instr       : data_word_t; -- Useful for debugging
        rs1_data    : data_word_t;
        rs2_data    : data_word_t;
        imm         : data_word_t;
        rd_addr     : reg_addr_t;
        -- Control Signals
        alu_op      : std_logic_vector(3 downto 0);
        alu_src     : std_logic; -- 0 for Reg, 1 for Imm
        reg_write   : std_logic;
        mem_read    : std_logic;
        mem_write   : std_logic;
        mem_to_reg  : std_logic;
    end record;

    -- 3. Stage 3 (Execute) -> Stage 4 (Memory)
    type ex_to_mem_rec_t is record
        alu_result  : data_word_t;
        rs2_data    : data_word_t; -- For store instructions
        rd_addr     : reg_addr_t;
        -- Control Signals
        reg_write   : std_logic;
        mem_read    : std_logic;
        mem_write   : std_logic;
        mem_to_reg  : std_logic;
    end record;

    -- 4. Stage 4 (Memory) -> Stage 5 (Writeback)
    type mem_to_wb_rec_t is record
        alu_result  : data_word_t;
        mem_data    : data_word_t;
        rd_addr     : reg_addr_t;
        -- Control Signals
        reg_write   : std_logic;
        mem_to_reg  : std_logic;
    end record;


end package types_pkg;
