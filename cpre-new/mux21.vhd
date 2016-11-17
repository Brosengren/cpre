library IEEE;
use IEEE.std_logic_1164.all;


entity mux21 is
  generic(N : integer := 32);
  port( D1, D0 : in std_logic_vector(N-1 downto 0);
        i_S : in std_logic;
        o_F : out std_logic_vector(N-1 downto 0));
end mux21;

architecture BRADEN of mux21 is
  
begin
  with i_S select
     o_F <=  D0 when '0',
             D1 when others;
   
    
  end BRADEN;
      
