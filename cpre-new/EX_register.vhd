library IEEE;
use IEEE.std_logic_1164.all;

entity EX_register is
	port(	CLK		: in std_logic;
			Reset	: in std_logic;

			memWrite 	: in std_logic;
			LSSigned	: in std_logic;
			LSSize		: in std_logic_vector(1 downto 0);
			Data2Reg  	: in std_logic_vector(1 downto 0);
			RegWrite  	: in std_logic;
			RdRt_addr	: in std_logic_vector(4 downto 0);
			Rt   		: in std_logic_vector(31 downto 0);
			Data 		: in std_logic_vector(31 downto 0);
			
			memWrite_o	: out std_logic;
			LSSigned_o	: out std_logic;
			LSSize_o 	: out std_logic_vector(1 downto 0);
			Data2Reg_o 	: out std_logic_vector(1 downto 0);
			RegWrite_o 	: out std_logic;
			RdRt_addr_o 	: out std_logic_vector(4 downto 0);
			Rt_o  		: out std_logic_vector(31 downto 0);
			Data_o 		: out std_logic_vector(31 downto 0)
		);
end EX_register;

architecture BV of EX_register is

component Nbit_reg is
generic(N : integer := 76);
port( i_CLK  : in std_logic;
			i_RST  : in std_logic;
			i_WE   : in std_logic;
			i_D    : in std_logic_vector(N-1 downto 0);
			o_Q    : out std_logic_vector(N-1 downto 0));
end component;

signal tempSignalIn : std_logic_vector(75 downto 0) := (others => '0');
signal tempSignalOut : std_logic_vector(75 downto 0) := (others => '0');

begin

tempSignalIn(0) <= memWrite;
tempSignalIn(1) <= LSSigned;
tempSignalIn(3 downto 2) <= LSSize;
tempSignalIn(5 downto 4) <= Data2Reg;
tempSignalIn(6) <= RegWrite;
tempSignalIn(11 downto 7) <= RdRt_addr;
tempSignalIn(43 downto 12) <= Rt;
tempSignalIn(75 downto 44) <= Data;


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
RdRt_addr_o       <= tempSignalOut(11 downto 7);
Rt_o         <= tempSignalOut(43 downto 12);
Data_o		 <= tempSignalOut(75 downto 44);

end BV;
