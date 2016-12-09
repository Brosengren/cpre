--http://courses.cs.vt.edu/cs2506/Spring2013/Assignments/8/ForwardingUnit.pdf
--look here for info on forwarding unit

library IEEE;
use IEEE.std_logic_1164.all;

entity forwardingunit is
	port(	ID_Rs        : in std_logic_vector(4 downto 0);
			ID_Rt        : in std_logic_vector(4 downto 0);
			EX_RegWrite  : in std_logic;
			EX_Rd        : in std_logic_vector(4 downto 0);
			MEM_RegWrite : in std_logic;
			MEM_Rd       : in std_logic_vector(4 downto 0);
			ForwardA     : out std_logic_vector(1 downto 0); --control for first input to ALU
			ForwardB     : out std_logic_vector(1 downto 0));  --control for second input to ALU
end forwardingunit;

architecture beevee of forwardingunit is

	signal EX_hazardA : std_logic;
	signal EX_hazardB : std_logic;
	signal MEM_hazardA : std_logic;
	signal MEM_hazardB : std_logic;

	begin

		EX_hazardA <= '0';
		EX_hazardB <= '0';
		MEM_hazardA <= '0';
		MEM_hazardB <= '0';

		--EX hazard
		process(EX_RegWrite, EX_Rd, ID_Rs)
		begin
	if EX_RegWrite = '1' and not(EX_Rd = "00000") and EX_Rd = ID_Rs then
		ForwardA <= "11";
			EX_hazardA <= '1';
		end if;
		end process;

		process(EX_Rd, ID_Rt, EX_RegWrite)
		begin
		if EX_RegWrite = '1' and not(EX_Rd = "00000") and EX_Rd = ID_Rt then
			ForwardB <= "11";
			EX_hazardB <= '1';
		end if;
		end process;

		--MEM hazard
		process(MEM_RegWrite, MEM_Rd, ID_Rs)
		begin
		if MEM_RegWrite = '1' and not(MEM_Rd = "00000") and MEM_Rd = ID_Rs
		and (EX_hazardA = '0') then
			ForwardA <= "10";
			MEM_hazardA <= '1';
		end if;
		end process;

		process(MEM_RegWrite, MEM_Rd, ID_Rt)
		begin
		if MEM_RegWrite = '1' and not(MEM_Rd = "00000") and MEM_Rd = ID_Rt
		and (EX_hazardB = '0') then
			ForwardB <= "10";
			MEM_hazardB <= '1';
		end if;
		end process;
		
		process(EX_hazardA, MEM_hazardA)
		begin
		if EX_hazardA = '0' and MEM_hazardA = '0' then
		  ForwardA <= "00";
		end if;
		end process;
		
		process(EX_hazardB, MEM_hazardB)
		begin
		if EX_hazardB = '0' and MEM_hazardB = '0' then
		  ForwardB <= "00";
		end if;
		end process;

end beevee;
