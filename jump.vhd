library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity jump is
	port(
		opcode	:	in		std_logic_vector(10 downto 0);
		pc		:	in		std_logic_vector(31 downto 0);
		imm		:	in		std_logic_vector(31 downto 0);
		rs1		:	in		std_logic_vector(31 downto 0);
		jp_out	:	out		std_logic_vector(31 downto 0):= (others => 'Z');
		rd_out	:	out		std_logic_vector(31 downto 0):= (others => 'Z')
	);
end entity;


architecture main of jump is

	signal	inc	:	std_logic_vector(31 downto 0):= "00000000000000000000000000000100";
	signal  jal	:	std_logic_vector(31 downto 0);
	signal  jalr:	std_logic_vector(31 downto 0);

begin

	jal 	<= std_logic_vector(signed(imm) + signed(pc));
	jalr	<= std_logic_vector(signed(rs1) + signed(imm));

	with opcode(6 downto 0) select
		jp_out <= jal  when "1101111",
			  	  jalr when "1100111",
			  	  (others => 'Z') when others;
			
	rd_out <= std_logic_vector(signed(pc) + signed(inc)) when 
			(opcode(6 downto 0) = "1101111" or opcode(6 downto 0) = "1100111") else (others => 'Z');

end architecture;



