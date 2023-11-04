library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity rf is
	port(
		rs1_addr	:	in		std_logic_vector(4 downto  0);
		rs2_addr	:	in		std_logic_vector(4 downto  0);
		rd_addr		:	in		std_logic_vector(4 downto  0);
		rd_data		:	in		std_logic_vector(31 downto 0);
		rs1_data	:	out		std_logic_vector(31 downto 0):= (others => 'Z');
		rs2_data	:	out		std_logic_vector(31 downto 0):= (others => 'Z')
	);
end entity;


architecture main of rf is

	type regs is array(31 downto 0) of std_logic_vector(31 downto 0);
	
	signal reg	:	regs:= (others =>(others => '0'));
	
begin

	rs1_data <= reg(to_integer(unsigned(rs1_addr))) when rs1_addr /= "ZZZZZ" else (others => 'Z');
	rs2_data <= reg(to_integer(unsigned(rs2_addr))) when rs2_addr /= "ZZZZZ" else (others => 'Z');
	
	reg(to_integer(unsigned(rd_addr))) <= rd_data when ((rd_addr /= "ZZZZZ" and rd_addr /= "00000") and
		rd_data /= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ");

end architecture;



