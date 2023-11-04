library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity pc is
	port(
		clk			:		in		std_logic;	
		addr_in		:		in		std_logic_vector(31 downto 0);
		pc_out		:		out		std_logic_vector(31 downto 0):= (others => 'Z')
	);
end entity;


architecture main of pc is

	signal inc : std_logic_vector(31 downto 0):= "00000000000000000000000000000100";
	signal Q   : std_logic_vector(31 downto 0):= "00000000000000000000000000000000";

begin

	ff:	process(clk, addr_in)
		begin
			if(addr_in'event and addr_in /= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ") then
				Q <= addr_in;
			end if;
			
			if(clk'event and clk = '1') then
				pc_out <= Q;
				Q      <= std_logic_vector(signed(Q) + signed(inc));
			end if;
	end process;

end architecture;



