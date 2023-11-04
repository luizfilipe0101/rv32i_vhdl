library IEEE;
use IEEE.std_logic_1164.ALL;


entity core is
	port(
		rst : in bit
	);
end entity;


architecture main of core is

	component clock is
		port(
			clk		:	out		std_logic
		);
	end component;
	
	component pc is
		port(
			clk			:		in		std_logic;	
			addr_in		:		in		std_logic_vector(31 downto 0);
			pc_out		:		out		std_logic_vector(31 downto 0)
		);
	end component;
	
	component mem is
		port(
			pc_addr	:	in		std_logic_vector(31 downto 0);
			instr	:	out		std_logic_vector(31 downto 0)
		);
	end component;
	
	component dec is
		port(
			instr	:	in		std_logic_vector(31 downto 0);
			op_out	:	out		std_logic_vector(10 downto 0);
			imm		:	out		std_logic_vector(31 downto 0);
			rs1		:	out		std_logic_vector( 4 downto 0);
			rs2		:	out		std_logic_vector( 4 downto 0);
			rd		:	out		std_logic_vector( 4 downto 0)
		);
	end component;
	
	component rf is
		port(
			rs1_addr	:	in		std_logic_vector(4 downto  0);
			rs2_addr	:	in		std_logic_vector(4 downto  0);
			rd_addr		:	in		std_logic_vector(4 downto  0);
			rd_data		:	in		std_logic_vector(31 downto 0);
			rs1_data	:	out		std_logic_vector(31 downto 0):= (others => 'Z');
			rs2_data	:	out		std_logic_vector(31 downto 0):= (others => 'Z')
		);
	end component;
	
	component branch is
		port(
			funct3	:	in		std_logic_vector( 2 downto 0);
			rs1		:	in		std_logic_vector(31 downto 0);
			rs2		:	in		std_logic_vector(31 downto 0);
			en		:	in		std_logic:= '0';
			taken_br:	out		boolean:= false
		);
	end component;
	
	component br_pc is
		port(
			en		:	in	boolean;
			pc		:	in	std_logic_vector(31 downto 0);
			imm		:	in	std_logic_vector(31 downto 0);
			br_addr	:	out std_logic_vector(31 downto 0)
		);
	end component;
	
	component alu is
		port(
			opcode		:	in		std_logic_vector(10 downto 0);
			imm_mux_in	:	in		std_logic_vector(31 downto 0);
			rs1_mux_in	:	in		std_logic_vector(31 downto 0);
			rs2_op_in	:	in		std_logic_vector(31 downto 0);
			
			data_mem	:	in		std_logic_vector(31 downto 0);	
			
			result		:	out		std_logic_vector(31 downto 0):= (others => 'Z')
		);
	end component;
	
	signal clk_s 		: std_logic;
	signal addr_s		: std_logic_vector(31 downto 0):= (others => 'Z');
	signal pc_s			: std_logic_vector(31 downto 0);
	signal instr_s		: std_logic_vector(31 downto 0);
	
	signal imm_s		: std_logic_vector(31 downto 0);
	signal rs1_addr_s	: std_logic_vector( 4 downto 0);
	signal rs2_addr_s	: std_logic_vector( 4 downto 0);
	signal rd_addr_s	: std_logic_vector( 4 downto 0);
	
	signal opcode_s 	: std_logic_vector(10 downto 0);
	
	signal result_s		: std_logic_vector(31 downto 0);
	signal rs1_data_s	: std_logic_vector(31 downto 0);
	signal rs2_data_s	: std_logic_vector(31 downto 0);
	
	signal taken_br_s	: boolean;
	signal en_br_s		: std_logic;
	
	signal data_mem_s		: std_logic_vector(31 downto 0):= (others => 'Z');
		
begin

	clk1:	clock port map(
		clk 	=> 		clk_s
	);
	
	pc1:	pc port map(
		clk 	=> 		clk_s,
		addr_in =>		addr_s,
		pc_out	=>		pc_s
	);
	
	mem1:	mem port map(
		pc_addr => 		pc_s,
		instr	=>		instr_s
	);
	
	dec1:	dec port map(
		instr	=>		instr_s,
		op_out  =>		opcode_s,
		imm		=>		imm_s,
		rs1		=>		rs1_addr_s,
		rs2		=>		rs2_addr_s,
		rd		=>		rd_addr_s
	);
	
	rf1:	rf port map(
		rs1_addr => rs1_addr_s,
		rs2_addr => rs2_addr_s,
		rd_addr	 => rd_addr_s,
		rd_data	 => result_s,
		rs1_data => rs1_data_s,
		rs2_data => rs2_data_s 
	);
	
	br1:	branch port map(
		funct3	 =>	instr_s(14 downto 12),
		rs1		 =>	rs1_data_s,
		rs2		 =>	rs2_data_s,
		en		 => en_br_s,
		taken_br => taken_br_s
	);
	
	br2:	br_pc port map(
		en		=>	taken_br_s,
		pc		=>	pc_s,
		imm		=>	imm_s,
		br_addr =>  addr_s
	);


	alu1:	alu port map(
		opcode   	=> opcode_s,
		imm_mux_in	=> imm_s,
		rs1_mux_in  => rs1_data_s,
		rs2_op_in	=> rs2_data_s,
		data_mem	=> data_mem_s,
		result      => result_s
	);
	
	-- Branch control
	en_br_s <= '1' when opcode_s(6 downto 0) = "1100011" else '0';

end architecture;





