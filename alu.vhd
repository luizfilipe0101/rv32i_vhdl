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

	type 	instr_set is array(28 downto 0) of std_logic_vector(31 downto 0);
	signal	instrs	:	instr_set;
	
	signal  set		:	std_logic_vector(31 downto 0):= "00000000000000000000000000000001";

	signal mux_out	:	std_logic_vector(31 downto 0);
	signal undef	:	std_logic_vector(31 downto 0):= (others => 'Z');
	
	signal is_sb	:	std_logic_vector(31 downto 0);
	signal is_sh	:	std_logic_vector(31 downto 0);
	signal is_sw	:	std_logic_vector(31 downto 0);
		
	signal F_alu	:  std_logic_vector(31 downto 0);


begin

	
	mux_out	<=	rs1_mux_in when opcode(6 downto 0) = "0110011" else imm_mux_in;
		
	instrs(0)	<= std_logic_vector(signed(mux_out) + signed(rs2_op_in)); -- ADD
	instrs(1)	<= std_logic_vector(signed(mux_out) - signed(rs2_op_in)); -- SUB
	
	instrs(2)	<= std_logic_vector(signed(mux_out) sll to_integer(signed(rs2_op_in))) when	--SLL
									rs2_op_in /= undef else undef; 
													
	instrs(3)	<= set when mux_out < rs2_op_in else (others => '0'); --SLT
	instrs(4)	<= set when mux_out < rs2_op_in else (others => '0'); --SLTU									  
	instrs(5)	<= std_logic_vector(mux_out xor rs2_op_in); 		  --XOR
	
	instrs(6)	<= std_logic_vector(unsigned(mux_out) srl to_integer(signed(rs2_op_in))) when -- SRL
													rs2_op_in /= undef;
	
	instrs(7)	<= std_logic_vector(shift_right(signed(mux_out), to_integer(signed(rs2_op_in)))) when
				  (rs2_op_in /= undef and mux_out /= undef) else (others => 'Z'); -- SRA
	
	instrs(8)	<= std_logic_vector(mux_out or rs2_op_in); 		  	  --OR
	instrs(9)	<= std_logic_vector(mux_out and rs2_op_in); 		  --AND
	
	instrs(10)  <= std_logic_vector(signed(mux_out) + signed(rs2_op_in)); -- ADDI
	instrs(11)	<= set when mux_out < rs2_op_in else (others => '0'); --SLTI
	instrs(12)	<= set when mux_out < rs2_op_in else (others => '0'); --SLTIU
	instrs(13)	<= std_logic_vector(mux_out xor rs2_op_in); 		  --XORI
	instrs(14)	<= std_logic_vector(mux_out and rs2_op_in); 		  --ANDI
	
	instrs(15)	<= std_logic_vector(shift_left(unsigned(rs2_op_in), to_integer(signed(mux_out)))) when
				  (mux_out /= undef and rs2_op_in /= undef) else (others => 'Z');--SLLI
				  
	instrs(16)	<= std_logic_vector(shift_right(unsigned(rs2_op_in), to_integer(signed(mux_out)))) when
				  (mux_out /= undef and rs2_op_in /= undef) else (others => 'Z');--SRLI
				  
	instrs(17)	<= std_logic_vector(shift_right(signed(rs2_op_in), to_integer(signed(mux_out)))) when
				  (mux_out /= undef and rs2_op_in /= undef) else (others => 'Z');--SRAI
				  
	instrs(18)  <= std_logic_vector(signed(mux_out) + signed(rs2_op_in));--LB
	instrs(19)	<= std_logic_vector(signed(mux_out) + signed(rs2_op_in));--LH
	instrs(20)	<= std_logic_vector(signed(mux_out) + signed(rs2_op_in));--LW
	instrs(21)  <= std_logic_vector(not(signed(mux_out) + signed(rs2_op_in)) + signed(set));--LBU
	instrs(22)	<= std_logic_vector(not(signed(mux_out) + signed(rs2_op_in)) + signed(set));--LHU
	
	instrs(23)	<= std_logic_vector(signed(rs1_mux_in) + signed(imm_mux_in)); --SB
	instrs(24)	<= std_logic_vector(signed(rs1_mux_in) + signed(imm_mux_in)); --SH
	instrs(25)	<= std_logic_vector(signed(rs1_mux_in) + signed(imm_mux_in)); --SW
			
	
			   
	F <= F_alu;
	
	with opcode select
		F_alu <=   instrs(0) when "00000110011", -- ADD
				   instrs(1) when "10000110011", -- SUB
				   instrs(2) when "00010110011", -- SLL
				   instrs(3) when "00100110011", -- SLT
				   instrs(4) when "00110110011", -- SLTU
				   instrs(5) when "01000110011", -- XOR
				   instrs(6) when "01010110011", -- SRL
				   --instrs(7) when "11010110011", -- SRA
				   instrs(8) when "01100110011", -- OR
				   instrs(9) when "01110110011", -- AND
				   instrs(10)when "00000010011" | "10000010011", -- ADDI
				   instrs(11)when "00100010011" | "10100010011", -- SLTI
				   instrs(12)when "00110010011" | "10110010011", -- SLTIU
				   instrs(13)when "01000010011" | "11000010011", -- XORI
				   instrs(14)when "01110010011" | "11110010011", -- ANDI
				   instrs(15)when "00010010011",				 --SLLI
				   instrs(16)when "01010010011",				 --SRLI
			   	   instrs(17)when "11010010011",				 --SRAI
			   	   instrs(18)when "00000000011" | "10000000011", --LB
			   	   instrs(19)when "00010000011" | "10010000011", --LH
			   	   instrs(20)when "00100000011" | "10100000011", --LW
			   	   instrs(21)when "01000000011" | "11000000011", --LBU *
			   	   instrs(22)when "01010000011" | "11010000011", --LHU *
			   	   instrs(23)when "00000100011" | "10000100011", --SB
			   	   instrs(24)when "00010100011" | "10010100011", --SH
			   	   instrs(25)when "00100100011" | "10100100011", --SW
			   	   
			   	   
			   (others => 'Z') when others;
			   
	with opcode(6 downto 0) select
		result <= data_mem when "0100011",
				  data_mem when "0000011",
					 F_alu when others;	   
	
end architecture;





