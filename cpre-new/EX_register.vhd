library IEEE;
use IEEE.std_logic_1164.all;

entity EX_register is
	port(	CLK		: in std_logic;
			Reset	: in std_logic;

			memWrite 	: in std_logic;
			LSSigned	: in std_logic;
			LSSize	: in std_logic_vector(1 downto 0);
			Data2Reg  : in std_logic_vector(1 downto 0);
			RegWrite  : in std_logic;
			
			memWrite_o		: out std_logic;
			LSSigned_o	: out std_logic;
			LSSize_o : out std_logic_vector(1 downto 0);
			Data2Reg_o : out std_logic_vector(1 downto 0);
			RegWrite_o : out std_logic
		);
end EX_register;

architecture BV of EX_register is

component Nbit_reg is
generic(N : integer := 32);
port( i_CLK  : in std_logic;
			i_RST  : in std_logic;
			i_WE   : in std_logic;
			i_D    : in std_logic_vector(N-1 downto 0);
			o_Q    : out std_logic_vector(N-1 downto 0));
end component;

signal tempSignalIn : std_logic_vector(31 downto 0) := (others => '0');
signal tempSignalOut : std_logic_vector(31 downto 0) := (others => '0');

begin

tempSignalIn(0) <= memWrite;
tempSignalIn(1) <= LSSigned;
tempSignalIn(3 downto 2) <= LSSize;
tempSignalIn(5 downto 4) <= Data2Reg;
tempSignalIn(6) <= RegWrite;


AllTheSignals : Nbit_reg
	port MAP( i_CLK => CLK,
						i_RST => Reset,
						i_WE  => '1',
						i_D   => tempSignalIn,
						o_Q   => tempSignalOut);

memWrite_o   <= tempSignalOut(0);
LSSigned_o   <= tempSignalOut(1);
LSSize_o  	 <= tempSignalOut(3 downto 2);
Data2Reg_o   <= tempSignalOut(5 downto 4);
RegWrite_o   <= tempSignalOut(6);

end BV;
