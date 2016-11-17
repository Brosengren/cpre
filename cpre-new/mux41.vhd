library IEEE;
use IEEE.std_logic_1164.all;


entity mux41 is
  generic(N : integer := 32);
  port( D3, D2, D1, D0 : in std_logic_vector(N-1 downto 0);
        i_S : in std_logic_vector(1 downto 0);
        o_F : out std_logic_vector(N-1 downto 0));
    
end mux41;

architecture BRADEN of mux41 is
  
begin
  with i_S select
     o_F <=  D0 when "00",
             D1 when "01",
             D2 when "10",
             D3 when others;
   
    
  end BRADEN;
      