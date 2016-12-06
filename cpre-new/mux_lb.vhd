library IEEE;
use IEEE.std_logic_1164.all;

entity mux_lb is
  port( i_A : in std_logic_vector(31 downto 0);
        i_S : in std_logic_vector(1 downto 0);
        o_F : out std_logic_vector(7 downto 0));
        
end mux_lb;

architecture BRADEN of mux_lb is
  
  signal f0, f1, f2, f3 : std_logic_vector(7 downto 0);  

begin
  f0 <= i_A(31 downto 24);
  f1 <= i_A(23 downto 16);
  f2 <= i_A(15 downto 8);
  f3 <= i_A(7 downto 0);
    
    with i_S select
      o_F <=  f0 when "00",
              f1 when "01",
              f2 when "10",
              f3 when others;
    
    
  end BRADEN;
      