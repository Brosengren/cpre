library IEEE;
use IEEE.std_logic_1164.all;

entity extender8 is
  port( i_A : in std_logic_vector(7 downto 0);
        i_C : in std_logic;
        o_F : out std_logic_vector(31 downto 0));
  
end extender8;

architecture dataflow of extender8 is
  
  signal temp : std_logic_vector(23 downto 0);
  
  begin
  
  temp <= (23 downto 0 => i_A(7));  
    
  with i_C select
    o_F <=  x"000000" & i_A when '0',
            temp & i_A when others;
  
end dataflow;       
  
