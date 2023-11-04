library IEEE;
use IEEE.std_logic_1164.ALL;


entity clock is
	port(
		clk		:	out		std_logic:= 'Z'
	);
end entity;


architecture main of clock is

begin
	gen:	process
		begin
			clk <= '1';	wait for 0.5 us;
			clk <= '0';	wait for 0.5 us;
	end process;

end architecture;
