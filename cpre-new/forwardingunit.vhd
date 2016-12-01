--http://courses.cs.vt.edu/cs2506/Spring2013/Assignments/8/ForwardingUnit.pdf
--look here for info on forwarding unit

library IEEE;
use IEEE.std_logic_1164.all;

entity forwardingunit is
	port( ID_Rs        : in std_logic_vector(4 downto 0);
        ID_Rt        : in std_logic_vector(4 downto 0);
        EX_RegWrite  : in std_logic;
        EX_Rd        : in std_logic_vector(4 downto 0);
        MEM_Rd       : in std_logic_vector(4 downto 0);
        MEM_RegWrite : in std_logic;
        ForwardA     : out std_logic_vector(1 downto 0); --control for first input to ALU
        ForwardB     : out std_logic_vector(1 downto 0)  --control for second input to ALU
        );
end forwardingunit;

architecture beevee of pipeline is

	component mux is
		port( 	i_A : in std_logic;
				i_B : in std_logic;
				i_S : in std_logic;
				o_F : out std_logic);
		end component;

	begin



end beevee;
