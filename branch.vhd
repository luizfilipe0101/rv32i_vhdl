library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity branch is
	port(
		funct3	:	in		std_logic_vector( 2 downto 0);
		rs1		:	in		std_logic_vector(31 downto 0);
		rs2		:	in		std_logic_vector(31 downto 0);
		en		:	in		std_logic:= '0';
		taken_br:	out		boolean:= false
	);
end entity;


architecture main of branch is

	signal beq  : boolean;
	signal bne  : boolean;
	signal blt  : boolean;
	signal bge  : boolean;
	signal bltu : boolean;
	signal bgeu : boolean;
	
	signal switch	:	std_logic_vector(3 downto 0);

begin

	switch <= funct3 & en;
	
	beq  <= rs1 =  rs2;
	bne  <= rs1 /= rs2;
	blt  <= rs1 <  rs2;
	bge  <= rs1 >= rs2;
	bltu <= rs1 <  rs2;
	bgeu <= rs1 >  rs2;
	
	
	with switch select
		taken_br <= beq   when "0001",
					bne   when "0011",
					blt   when "1001",
					bge   when "1011",
					bltu  when "1101",
					bgeu  when "1111",
					false when others;
		
end architecture;




