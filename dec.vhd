library IEEE;
use IEEE.std_logic_1164.ALL;

entity dec is
	port(
		instr	:	in		std_logic_vector(31 downto 0);
		op_out	:	out		std_logic_vector(10 downto 0):= (others => 'Z');
		imm		:	out		std_logic_vector(31 downto 0):= (others => 'Z');
		rs1		:	out		std_logic_vector( 4 downto 0):= (others => 'Z');
		rs2		:	out		std_logic_vector( 4 downto 0):= (others => 'Z');
		rd		:	out		std_logic_vector( 4 downto 0):= (others => 'Z')
	);
end entity;


architecture main of dec is

	signal high_imp		:	std_logic_vector(31 downto 0):= (others => 'Z');
	
	signal is_r_type	:	boolean;
	signal is_i_type	:	boolean;
	signal is_s_type	:	boolean;
	signal is_b_type	:	boolean;
	signal is_u_type	:	boolean;
	signal is_j_type	:	boolean;
	
	signal opcode		:	std_logic_vector( 6 downto 0);
	signal funct7		:	std_logic_vector( 6 downto 0);
	signal funct3		:	std_logic_vector( 2 downto 0);

begin

	opcode		<=	instr( 6 downto  0);
	funct3		<=	instr(14 downto 12);
	funct7		<=	instr(31 downto 25);
	
	is_r_type	<=	true when instr(6 downto 0) = "0110011" else false;
	is_i_type	<=	true when instr(6 downto 0) = "0010011" or instr(6 downto 0) = "1100111"else false;
	is_s_type	<=	true when instr(6 downto 0) = "0100011" else false;
	is_b_type	<=	true when instr(6 downto 0) = "1100011" else false;
	is_u_type	<=	true when instr(6 downto 0) = "0110111" or instr(6 downto 0) = "0010111"else false;
	is_j_type	<=	true when instr(6 downto 0) = "1101111" else false;
	
	op_out		<=	funct7(5) & funct3 & opcode;
	
	rd 	<= instr(11 downto  7) when is_u_type or is_j_type or is_i_type or is_r_type else (others => 'Z');
	rs1	<= instr(19 downto 15) when is_i_type or is_b_type or is_s_type or is_r_type else (others => 'Z');
	
	-- rs2 recebe os valores que seriam do rs1 quando a instrução for do tipo I
	rs2	<= instr(24 downto 20) when is_b_type or is_s_type or is_r_type else 
		   instr(19 downto 15) when is_i_type else (others => 'Z');
	

	set_imm:	process(instr, is_r_type, is_i_type, is_s_type, is_b_type, is_u_type, is_j_type)
		begin
			if(is_i_type) then
				imm(31 downto 11) <= (others => instr(31));
				imm(10 downto  5) <= instr(30 downto 25);
				imm( 4 downto  1) <= instr(24 downto 21);
				imm(0)			  <= instr(20);
			
			elsif(is_s_type) then
				imm(31 downto 11) <= (others => instr(31));
				imm(10 downto  5) <= instr(30 downto 25);
				imm( 4 downto  1) <= instr(11 downto  8);
				imm(0)			  <= instr(7);
				
			elsif(is_b_type) then
				imm(31 downto 12) <= (others => instr(31));
				imm(11) 		  <= instr(7);
				imm(10 downto  5) <= instr(30 downto 25);
				imm( 4 downto  1) <= instr(11 downto  8);
				imm(0)			  <= '0';
				
			elsif(is_u_type) then
				imm(31)			  <= instr(31);
				imm(30 downto 20) <= instr(30 downto 20);
				imm(19 downto 12) <= instr(19 downto 12);
				imm(11 downto  0) <= (others => '0');
				
			elsif(is_j_type) then
				imm(31 downto 20) <= instr(31 downto 20);
				imm(19 downto 12) <= instr(19 downto 12);
				imm(11)			  <= instr(10);
				imm(10 downto  5) <= instr(30 downto 25);
				imm( 4 downto  1) <= instr(24 downto  21);
				imm(31)			  <= '0';
			
			else
				imm <= (others => 'Z');
				
			end if;	
	end process;
	
end architecture;




