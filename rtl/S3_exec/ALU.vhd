library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

library work;
use work.types_pkg.all;

ENTITY ALU IS
	PORT (	val1: in data_word_t;
			val2: in data_word_t;
			op: in alu_op_t;
			out_val: out data_word_t);
END ENTITY;

ARCHITECTURE rtl OF ALU IS
BEGIN
	PROCESS(val1, val2, op)
		variable shift_int: INTEGER;
	BEGIN
		shift_int := TO_INTEGER(unsigned(val2(4 downto 0)));
		CASE op IS

			WHEN ALU_AND =>
				out_val <= val1 and val2;
			WHEN ALU_OR =>
				out_val <= val1 or val2;
			WHEN ALU_XOR =>
				out_val <= val1 xor val2;
			WHEN ALU_SRA =>
				out_val <= STD_LOGIC_VECTOR(signed(val1) sra shift_int);
			WHEN ALU_SRL =>
				out_val <= STD_LOGIC_VECTOR(unsigned(val1) srl shift_int);
			WHEN ALU_SLL =>
				out_val <= STD_LOGIC_VECTOR(unsigned(val1) sll shift_int);
			WHEN ALU_ADD =>
				out_val <= STD_LOGIC_VECTOR(unsigned(val1) + unsigned(val2));
			WHEN ALU_SUB =>
				out_val <= STD_LOGIC_VECTOR(unsigned(val1) - unsigned(val2));
			WHEN ALU_SLTU =>
				IF unsigned(val1) < unsigned(val2) then
					out_val <= (0 => '1', others => '0');
				ELSE
					out_val <= (others => '0');
				END IF;
			WHEN ALU_SLT =>
				IF signed(val1) < signed(val2) then
					out_val <= (0 => '1', others => '0');
				ELSE
					out_val <= (others => '0');
				END IF;
			WHEN others =>
				out_val <= (others => '0');
		END CASE;
	END PROCESS;

END ARCHITECTURE rtl;
