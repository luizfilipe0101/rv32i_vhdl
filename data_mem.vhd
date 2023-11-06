library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity data_mem is
	port(
		width	:	in		std_logic_vector(10 downto 0);
		addr	:	in		std_logic_vector(31 downto 0);
		data_in	:	in		std_logic_vector(31 downto 0);
		data_out:	out		std_logic_vector(31 downto 0)
	);
end entity;


architecture main of data_mem is

	type mem is array(15 downto 0) of std_logic_vector(7 downto 0);
	signal d_mem :	mem:= ("00000100", "00000000", "00000000", "00000000",
						   "00000000", "00000000", "00000000", "00000000",
						   "00000000", "00000000", "00000000", "00000000",
						   "00001110", "00000001", "00001010", "00001000");
	
	signal undef	:	std_logic_vector(31 downto 0):= (others => 'Z');
	signal we		:	std_logic;
	signal sw		:	std_logic_vector(3 downto 0);

begin

	with width(6 downto 0) select
		we <= '1' when "0100011",
			  '0' when "0000011",
			  'Z' when others;
			  
	sw <= width(9 downto 7) & we;
	
	
	process(addr)
		begin
			if(sw = "0000") then
				data_out( 7 downto 0) <= d_mem(to_integer(signed(addr)));
				data_out(31 downto 8) <= (others => '0');
				
			elsif(sw = "0010") then
				data_out( 7 downto  0) <= d_mem(to_integer(signed(addr)));
				data_out(15 downto  8) <= d_mem(to_integer(signed(addr)) + 1);
				data_out(31 downto 16) <= (others => '0');
				
			elsif(sw = "0100") then
				data_out( 7 downto  0) <= d_mem(to_integer(signed(addr)));
				data_out(15 downto  8) <= d_mem(to_integer(signed(addr)) + 1);
				data_out(23 downto 16) <= d_mem(to_integer(signed(addr)) + 2);
				data_out(31 downto 24) <= d_mem(to_integer(signed(addr)) + 3);
				
			else
				data_out <= (others => 'Z');
				
			end if;
	end process;


end architecture;




