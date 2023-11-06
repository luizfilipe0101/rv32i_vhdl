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
		F			:	out		std_logic_vector(31 downto 0):= (others => 'Z');
		result		:	out		std_logic_vector(31 downto 0):= (others => 'Z')
	);
end entity;


architecture main of alu is

	signal mux_out	:	std_logic_vector(31 downto 0);
	signal undef	:	std_logic_vector(31 downto 0):= (others => 'Z');
	
	signal is_sb	:	std_logic_vector(31 downto 0);
	signal is_sh	:	std_logic_vector(31 downto 0);
	signal is_sw	:	std_logic_vector(31 downto 0);
	signal is_lb	:	std_logic_vector(31 downto 0);
	signal is_lh	:	std_logic_vector(31 downto 0);
	signal is_lw	:	std_logic_vector(31 downto 0);
	
	signal is_addi	:	std_logic_vector(31 downto 0);
	signal is_add	:	std_logic_vector(31 downto 0);
	
	signal F_alu	:  std_logic_vector(31 downto 0);


begin

	mux_out	<=	rs1_mux_in when opcode(6 downto 0) = "0110011" else imm_mux_in;
	
	is_sb	<= std_logic_vector(signed(rs1_mux_in) + signed(imm_mux_in));
	is_sh	<= std_logic_vector(signed(rs1_mux_in) + signed(imm_mux_in));
	is_sw	<= std_logic_vector(signed(rs1_mux_in) + signed(imm_mux_in));
	is_lb	<= std_logic_vector(signed(mux_out) + signed(rs2_op_in));
	is_lh	<= std_logic_vector(signed(mux_out) + signed(rs2_op_in));
	is_lw	<= std_logic_vector(signed(mux_out) + signed(rs2_op_in));
			
	is_addi <= std_logic_vector(signed(mux_out) + signed(rs2_op_in)); -- ADDI
			   
	is_add  <= std_logic_vector(signed(mux_out) + signed(rs2_op_in)); -- ADD
	
	F <= F_alu;
	
	with opcode select
		F_alu <=   is_addi	 when "00000010011" | "10000010011",
				   is_sb	 when "00000100011" | "10000100011",
				   is_sh	 when "00010100011" | "10010100011",
				   is_sw	 when "00100100011" | "10100100011",
				   is_lb	 when "00000000011" | "10000000011",
				   is_lh	 when "00010000011" | "10010000011",
				   is_lw	 when "00100000011" | "10100000011",
				   is_add	 when "00000110011",
			   
			   (others => 'Z') when others;
			   
	with opcode(6 downto 0) select
		result <= data_mem when "0100011",
				  data_mem when "0000011",
					 F_alu when others;	   
	
end architecture;





