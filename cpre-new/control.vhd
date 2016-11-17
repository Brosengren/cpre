library IEEE;
use IEEE.std_logic_1164.all;

entity control is
  port( I 			 : in std_logic_vector(31 downto 0);
        LSSigned  : out std_logic;
				RegDst   : out std_logic;
				Jump		 : out std_logic;
				JR			 : out std_logic;
				Branch	 : out std_logic;
				Data2Reg : out std_logic_vector(1 downto 0);
				ALUOp		 : out std_logic_vector(4 downto 0);
				MemWrite : out std_logic;
				ALUSrc   : out std_logic_vector(1 downto 0);
				RegWrite : out std_logic;
				Link     : out std_logic;
				ShiftSrc : out std_logic_vector(1 downto 0);
				numOrZero: out std_logic;
        GTLT     : out std_logic;
				EQNE     : out std_logic;
        ShiftLog : out std_logic;
        ShiftDir : out std_logic;
        LSSize   : out std_logic_vector(1 downto 0));

end control;

architecture BRADENV of control is

	signal output, output1, output2, output3 : std_logic_vector(26 downto 0);
	signal opcode : std_logic_vector( 5 downto 0);
	signal funct1 : std_logic_vector( 5 downto 0);
  signal funct2 : std_logic_vector( 4 downto 0);

	begin

		opcode <= I(31 downto 26);
		funct1 <= I( 5 downto  0);
		funct2 <= I(20 downto 16);


		with funct1 select
			output1 <="110000000001000010000000000" when "100000",
  							  "010000000001000010000000000" when "100001",
	 							"110000000101000010000000000" when "100010",
								"010000000101000010000000000" when "100011",
								"010000000000000010000000000" when "100100",
								"010000000000100010000000000" when "100101",
								"010000001100000010000000000" when "100111",
								"010000000010000010000000000" when "100110",
								"010000100000000010000000000" when "011000",
								"110000000101100010000000000" when "101010", --slt
								"010000000101100010000000000" when "101011",
								"010000110000000010000000100" when "000000", --sll
								"010000110000000010000000100" when "000010",
								"010000110000000010000001000" when "000011",
								"010000110000000010100000100" when "000100", --sllv
								"010000110000000010100000000" when "000110",
								"010000110000000010100001000" when "000111",
								"001100000000000011000000000" when "001001", --jalr
								"001100000000000000000000000" when "001000",
								"000000000000000000000000000" when others;

		with funct2 select
			output2 <="000010000101101000000100000" when "00000", --bltz
								"000010000101101011000100000" when "10000", --bltzal
								"000010000101101000000000000" when "00001", --bgez
								"000010000101101011000000000" when "10001", --bgezal
								"000000000000000000000000000" when others;

		with opcode select
			output3 <="001000000000000000000000000" when "000010", --j
								"001000000000000011000000000" when "000011",
								"000010000101000000001010000" when "000100",
								"000010000101000000001000000" when "000101",
								"000010000101101100000100000" when "000110",
								"000010000101101100000000000" when "000111",
								"100000000001000110000000000" when "001000", --addi
								"000000000001000110000000000" when "001001",
								"100000000101100110000000000" when "001010",
								"000000000101100110000000000" when "001011",
								"000000000000000110000000000" when "001100",
								"000000000000100110000000000" when "001101",
								"000000000010000110000000000" when "001110",
								"000000110000000010100000000" when "001111", --lui
								"100001010001000110000000000" when "100000",
								"100001010001000110000000001" when "100001",
								"000001010001000110000000010" when "100011",
								"000001010001000110000000000" when "100100",
								"000001010001000110000000001" when "100101",
								"000000000001010100000000000" when "101000",
								"000000000001010100000000001" when "101001",
								"000000000001010100000000010" when "101011",
								"000000000000000000000000000" when others;


		choose : process(output1, output2, output3)
		begin
			if ( opcode	= "000000" ) then
				output <= output1;

			elsif ( opcode = "000001" ) then
				output <= output2;

			else
				output <= output3;

			end if;
		end process;

    LSSigned <= output(26);
		RegDst   <= output(25);
		Jump		 <= output(24);
		JR			 <= output(23);
		Branch	 <= output(22);
		--MemRead <= output(21)
		Data2Reg <= output(20 downto 19);
		ALUOp		 <= output(18 downto 14);
		MemWrite <= output(13);
		ALUSrc   <= output(12 downto 11);
		RegWrite <= output(10);
		Link     <= output(9);
		ShiftSrc <= output(8 downto 7);
		numOrZero<= output(6);
		GTLT     <= output(5);
    EQNE     <= output(4);
    ShiftLog <= output(3);
    ShiftDir <= output(2);
    LSSize   <= output(1 downto 0);

	end BRADENV;
