library IEEE;
use IEEE.std_logic_1164.all;

entity hazarddetection is
	port(	CLK				: in std_logic;
			IF_Rs        : in std_logic_vector(4 downto 0);
			IF_Rt        : in std_logic_vector(4 downto 0);
			ID_MemRead   : in std_logic;
			ID_Rt        : in std_logic_vector(4 downto 0);
			Branch       : in std_logic;
			Jump		 : in std_logic;
			LoadUse_Hazard : out std_logic;
			BranchJump_Hazard : out std_logic);
end hazarddetection;

architecture beevee of hazarddetection is

	begin

	--Load-use hazard
	process(ID_MemRead, ID_Rt, IF_Rs, IF_Rt, CLK)
	begin
	if ( (ID_MemRead = '1')
	and ((ID_Rt = IF_Rs) or (ID_Rt = IF_Rt))
	and falling_edge(CLK) ) then
		LoadUse_Hazard <= '1';
	else
		LoadUse_Hazard <= '0';
	end if;
	end process;

	--Branch/Jump
	process(Branch, Jump, CLK)
	begin
	if ((Branch = '1' or Jump = '1') and falling_edge(CLK)) then
		BranchJump_Hazard <= '1';
	else
		BranchJump_Hazard <= '0';
	end if;
	end process;

end beevee;
