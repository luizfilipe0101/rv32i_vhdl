library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity pc is
	port(
		clk			:		in		std_logic;	
		ctrl		:		in		std_logic_vector(10 downto 0);
		addr_in		:		in		std_logic_vector(31 downto 0):= (others => 'L'); -- pc_out
		branch		:		in		std_logic_vector(31 downto 0);
		jump		:		in		std_logic_vector(31 downto 0);
		pc_out		:		out		std_logic_vector(31 downto 0):= (others => 'Z')
	);
end entity;


architecture main of pc is

	signal inc : std_logic_vector(31 downto 0):= "00000000000000000000000000000100";
	signal Q   : std_logic_vector(31 downto 0):= (others => '0');
	signal Himp: std_logic_vector(31 downto 0):= (others => 'Z');

begin

	sum:process(clk, branch)
		begin 
			if(clk'event and clk = '0') then
				if(branch /= Himp) then
					Q <= branch;
				
				elsif(jump /= Himp) then
					Q <= jump;
				else
					Q <= std_logic_vector(signed(addr_in) + signed(inc));
					
				end if;
			end if;
	end process;
	

	ff:	process(clk)
		begin
			if(clk'event and clk = '1') then
				pc_out <= Q;
			end if;
	end process;


end architecture;



