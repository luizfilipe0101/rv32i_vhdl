library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity alu is
	port(
		opcode		:	in		std_logic_vector(10 downto 0);
		imm_mux_in	:	in		std_logic_vector(31 downto 0);
		rs1_mux_in	:	in		std_logic_vector(31 downto 0);
		rs2_op_in	:	in		std_logic_vector(31 downto 0);
		
		data_mem	:	in		std_logic_vector(31 downto 0);	
		
		result		:	out		std_logic_vector(31 downto 0):= (others => 'Z')
	);
end entity;


architecture main of alu is

	signal mux_out	:	std_logic_vector(31 downto 0);
	signal undef	:	std_logic_vector(31 downto 0):= (others => 'Z');
	
	signal is_addi	:	std_logic_vector(31 downto 0);
	signal is_add	:	std_logic_vector(31 downto 0);

begin

	mux_out	<=	rs1_mux_in when opcode(6 downto 0) = "0110011" else imm_mux_in;
	
	is_addi <= std_logic_vector(signed(mux_out) + signed(rs2_op_in)) when mux_out /= undef else undef; -- ADDI
			   
	is_add  <= std_logic_vector(signed(mux_out) + signed(rs2_op_in)) when mux_out /= undef else undef; -- ADD
	
	with opcode select
		result  <= is_addi	 when "00000010011" | "10000010011",
				   is_add	 when "00000110011",
				   (others => 'Z') when others;
		
end architecture;





