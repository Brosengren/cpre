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

architecture beevee of forwardingunit is

	signal EX_hazardA : std_logic;
	signal EX_hazardB : std_logic;

	begin

		EX_hazardA <= '0';
		EX_hazardB <= '0';

		--EX hazard
    if ((EX_RegWrite = '1') and (not(EX_Rd = '0')) and (EX_Rd = ID_Rs)) then
    	ForwardA <= "10";
			EX_hazardA <= '1';
		end if;

		if ((EX_RegWrite = '1') and (not(EX_Rd = '0')) and (EX_Rd = ID_Rt)) then
			ForwardB <= "10";
			EX_hazardB <= '1';
		end if;

		--MEM hazard
		if ((MEM_RegWrite = '1') and (not(MEM_Rd = '0')) and (MEM_Rd = ID_Rs))
		and (EX_hazardA = '0') then
			ForwardA <= "01";
		end if;

		if ((MEM_RegWrite = '1') and (not(MEM_Rd = '0'))	and (MEM_Rd = ID_Rt))
		and (EX_hazardB = '0') then
			ForwardB <= "01";
		end if;

end beevee;
