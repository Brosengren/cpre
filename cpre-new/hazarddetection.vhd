library IEEE;
use IEEE.std_logic_1164.all;

entity hazarddetection is
	port( IF_Rs        : in std_logic_vector(4 downto 0);
				IF_Rt        : in std_logic_vector(4 downto 0);
				ID_MemRead   : in std_logic; --need to add this signal into IF and ID pipeline regs
				ID_Rt        : in std_logic_vector(4 downto 0)
        );
end hazarddetection;

architecture beevee of hazarddetection is

	begin
    
  --Load-use hazard
  if ( (ID_MemRead = '1')
  and ((ID_Rt = IF_Rs) or (ID_Rt = IF_Rt)) ) then
    --stall
  end if;

end beevee;
