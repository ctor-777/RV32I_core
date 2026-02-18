library ieee;
use ieee.std_logic_1164.all;

library work;
use work.types_pkg.all;


ENTITY decode_stage IS
	PORT(
		pipeline_in: in pc_to_fd_rec_t;
		pipeline_out: out fd_to_ex_rec_t);

END ENTITY decode_stage;

ARCHITECTURE rtl OF decode_stage IS
BEGIN
END ARCHITECTURE rtl;
