library IEEE;
use IEEE.std_logic_1164.all;

entity hazarddetection is
	port( IF_Rs        : in std_logic_vector(4 downto 0);
				IF_Rt        : in std_logic_vector(4 downto 0);
				ID_MemRead   : in std_logic; --need to add this signal into IF and ID pipeline regs
				ID_Rt        : in std_logic_vector(4 downto 0);
        Stall        : out std_logic
        );
end hazarddetection;

architecture beevee of hazarddetection is

	begin

  --Load-use hazard
  process(ID_MemRead, ID_Rt, IF_Rs, IF_Rt)
  begin
  if ( (ID_MemRead = '1')
  and ((ID_Rt = IF_Rs) or (ID_Rt = IF_Rt)) ) then
    Stall <= '1';
  else
    Stall <= '0';
  end if;
  end process;

end beevee;
