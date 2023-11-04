library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity mem is
	port(
		pc_addr	:	in		std_logic_vector(31 downto 0);
		instr	:	out		std_logic_vector(31 downto 0):= (others => 'Z')
	);
end entity;


architecture main of mem is

	type c_mem is array(63 downto 0) of std_logic_vector(7 downto 0);
	
	signal opcode	:	std_logic_vector(31 downto 0);
		
	signal code_mem :	c_mem:= ("00000000", "00000000", "00000000", "00000000",
								 "00000000", "00000000", "00000000", "00000000",
								 "00000000", "00000000", "00000000", "00000000",
								 "00000000", "00000000", "00000000", "00000000",
								 "00000000", "00000000", "00000000", "00000000",
								 "00000000", "00000000", "00000000", "00000000",
								 "00000000", "00000000", "00000000", "00000000",
								 "00000000", "00000000", "00000000", "00000000",
								 "00000000", "00000000", "00000000", "00000000",
								 "00000000", "00000000", "00000000", "00000000",
								 "00000000", "00110001", "00000000", "01100011",
								 "00000000", "00110001", "00000010", "00110011",
								 "00000000", "00010000", "00000010", "00010011",
								 "00000000", "11110000", "00000001", "10010011",
								 "00000000", "11110000", "00000001", "00010011",
								 "00000000", "10100000", "00000000", "10010011");

begin

	op:	process(pc_addr)
		begin
			if(pc_addr /= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ") then
				opcode( 7 downto  0) <= code_mem(to_integer(signed(pc_addr)));
				opcode(15 downto  8) <= code_mem(to_integer(signed(pc_addr) + 1));
				opcode(23 downto 16) <= code_mem(to_integer(signed(pc_addr) + 2));
				opcode(31 downto 24) <= code_mem(to_integer(signed(pc_addr) + 3));
			end if;
	end process;
	
	load:	process(opcode)
		begin
			if(opcode'event) then
				instr <= opcode;
			end if;
	end process;

end architecture;



