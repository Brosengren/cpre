library IEEE;
use IEEE.std_logic_1164.all;

entity extender16 is
  port( i_A : in std_logic_vector(15 downto 0);
        i_C : in std_logic;
        o_F : out std_logic_vector(31 downto 0));
  
end extender16;

architecture dataflow of extender16 is
  
  signal temp : std_logic_vector(15 downto 0);
  
  begin
  
  temp <= (15 downto 0 => i_A(15));  
    
  with i_C select
    o_F <=  x"0000" & i_A when '0',
            temp & i_A when others;
  
end dataflow;       
  
