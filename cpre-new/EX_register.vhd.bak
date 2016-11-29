library IEEE;
use IEEE.std_logic_1164.all;

entity EX_register is
	port(	CLK		: in std_logic;
			Reset	: in std_logic;

			MemWr 	: in std_logic;
			MemSign	: in std_logic;
			MemHW	: in std_logic;
			MemByte	: in std_logic;

			MemWr_o		: out std_logic;
			MemSign_o	: out std_logic;
			MemHW_o : out std_logic;
			MemByte_o : out std_logic;

		);
end EX_register;

architecture BV of EX_register is

component Nbit_reg is
generic(N : integer := 4);
port( i_CLK  : in std_logic;
			i_RST  : in std_logic;
			i_WE   : in std_logic;
			i_D    : in std_logic_vector(N-1 downto 0);
			o_Q    : out std_logic_vector(N-1 downto 0));
end component;

signal tempSignalIn : std_logic_vector(3 downto 0) := (others => '0');
signal tempSignalOut : std_logic_vector(3 downto 0) := (others => '0');

begin

tempSignalIn(0) <= MemWr;
tempSignalIn(1) <= MemSign;
tempSignalIn(2) <= MemHW;
tempSignalIn(3) <= MemByte;


AllTheSignals : Nbit_reg
	port MAP( i_CLK => i_CLK,
						i_RST => i_RST,
						i_WE  => i_WE,
						i_D   => tempSignalIn,
						o_Q   => tempSignalOut);

MemWr_o  		<= tempSignalOut(0);
MemSign_o   <= tempSignalOut(1);
MemHW_o  	  <= tempSignalOut(2);
MemByte_o   <= tempSignalOut(3);

end BV;
