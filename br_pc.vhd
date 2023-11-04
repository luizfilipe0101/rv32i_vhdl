library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity br_pc is
	port(
		en		:	in	boolean;
		pc		:	in	std_logic_vector(31 downto 0);
		imm		:	in	std_logic_vector(31 downto 0);
		br_addr	:	out std_logic_vector(31 downto 0)
	);
end entity;


architecture main of br_pc is

	signal target	:	std_logic_vector(31 downto 0);

begin
	
	target <= std_logic_vector((signed(imm) - signed(pc) + signed(pc))) when en = true else (others => 'Z'); 
	br_addr <= target when en = true else (others => 'Z');

end architecture;
