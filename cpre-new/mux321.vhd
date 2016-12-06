library IEEE;
use IEEE.std_logic_1164.all;

entity mux321 is
  port( D31, D30, D29, D28, D27, D26, D25, D24, D23, D22, D21, D20, 
        D19, D18, D17, D16, D15, D14, D13, D12, D11, D10, D9, D8, D7,
        D6, D5, D4, D3, D2, D1, D0 : in std_logic_vector(31 downto 0);
        i_S : in std_logic_vector(4 downto 0);
        o_F : out std_logic_vector(31 downto 0));
end mux321;

architecture BRADEN of mux321 is

begin

    with i_S select
      o_F <=  D0  when "00000",
              D1  when "00001",
              D2  when "00010",
              D3  when "00011",
              D4  when "00100",
              D5  when "00101",
              D6  when "00110",
              D7  when "00111",
              D8  when "01000",
              D9  when "01001",
              D10 when "01010", 
              D11 when "01011",
              D12 when "01100",
              D13 when "01101", 
              D14 when "01110", 
              D15 when "01111",  
              D16 when "10000",  
              D17 when "10001",  
              D18 when "10010",  
              D19 when "10011",  
              D20 when "10100",  
              D21 when "10101",  
              D22 when "10110",  
              D23 when "10111",  
              D24 when "11000",  
              D25 when "11001",  
              D26 when "11010",  
              D27 when "11011",  
              D28 when "11100",  
              D29 when "11101",  
              D30 when "11110",  
              D31 when others;
  
end BRADEN;