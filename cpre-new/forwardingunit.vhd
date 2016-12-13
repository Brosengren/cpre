--http://courses.cs.vt.edu/cs2506/Spring2013/Assignments/8/ForwardingUnit.pdf
--look here for info on forwarding unit

library IEEE;
use IEEE.std_logic_1164.all;

entity forwardingunit is
	port(	ID_Rs        : in std_logic_vector(4 downto 0);
			ID_Rt        : in std_logic_vector(4 downto 0);
			MEM_RegWrite  : in std_logic;
			EX_Rd        : in std_logic_vector(4 downto 0);
			WB_RegWrite : in std_logic;
			MEM_Rd       : in std_logic_vector(4 downto 0);
			ForwardA     : out std_logic_vector(1 downto 0); --control for first input to ALU
			ForwardB     : out std_logic_vector(1 downto 0));  --control for second input to ALU
end forwardingunit;

architecture beevee of forwardingunit is

	begin


		--EX hazard
		process(MEM_RegWrite, EX_Rd, ID_Rs, ID_Rt, WB_RegWrite, MEM_Rd)
		begin

		if MEM_RegWrite = '1' and not(EX_Rd = "00000") and EX_Rd = ID_Rs then
			ForwardA <= "11";
		end if;

		if MEM_RegWrite = '1' and not(EX_Rd = "00000") and EX_Rd = ID_Rt then
			ForwardB <= "11";

		end if;

		--MEM hazard
		if WB_RegWrite = '1' and not(MEM_Rd = "00000") and MEM_Rd = ID_Rs
		and not(MEM_RegWrite = '1' and not(EX_Rd = "00000") and EX_Rd = ID_Rs) then
			ForwardA <= "10";

		end if;

		if WB_RegWrite = '1' and not(MEM_Rd = "00000") and MEM_Rd = ID_Rt
		and not(MEM_RegWrite = '1' and not(EX_Rd = "00000") and EX_Rd = ID_Rt) then
			ForwardB <= "10";

		end if;

		if not ((MEM_RegWrite = '1' and not(EX_Rd = "00000") and EX_Rd = ID_Rs)
		or (WB_RegWrite = '1' and not(MEM_Rd = "00000") and MEM_Rd = ID_Rs)) then
		  ForwardA <= "00";
		end if;

		if not ((MEM_RegWrite = '1' and not(EX_Rd = "00000") and EX_Rd = ID_Rt)
		or (WB_RegWrite = '1' and not(MEM_Rd = "00000") and MEM_Rd = ID_Rt)) then
		  ForwardB <= "00";
		end if;

		end process;
end beevee;
