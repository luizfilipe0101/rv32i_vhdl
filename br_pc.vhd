library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity br_pc is
	port(
		op		:	in	std_logic_vector(10 downto 0);
		rs1		:	in	std_logic_vector(31 downto 0);
		rs2		:	in	std_logic_vector(31 downto 0);
		pc		:	in	std_logic_vector(31 downto 0);
		imm		:	in	std_logic_vector(31 downto 0);
		br_addr	:	out std_logic_vector(31 downto 0):= (others => 'Z')
	);
end entity;


architecture main of br_pc is

	signal beq  : boolean;
	signal bne  : boolean;
	signal blt  : boolean;
	signal bge  : boolean;
	signal bltu : boolean;
	signal bgeu : boolean;
	
	signal taken_br : boolean;
	signal check	: boolean;
	
	signal target	: std_logic_vector(31 downto 0);

begin

	beq  <= rs1 =  rs2;
	bne  <= rs1 /= rs2;
	blt  <= rs1 <  rs2;
	bge  <= rs1 >= rs2;
	bltu <= rs1 <  rs2;
	bgeu <= rs1 >  rs2;
	
	with op(9 downto 0) select
		taken_br <= beq   when "0001100011",
					bne   when "0011100011",
					blt   when "1001100011",
					bge   when "1011100011",
					bltu  when "1101100011",
					bgeu  when "1111100011",
					false when others;
					
	check <= taken_br and op(6 downto 0) = "1100011";
	
	target  <= std_logic_vector(signed(imm) - signed(pc)) when op(6 downto 0) = "1100011" else (others => 'Z');
	br_addr <= std_logic_vector(signed(target) + signed(pc)) when check = true else (others => 'Z');

end architecture;
