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

		);
end EX_register;

architecture BV of EX_register is









end BV;