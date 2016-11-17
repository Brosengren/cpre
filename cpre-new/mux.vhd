library IEEE;
use IEEE.std_logic_1164.all;

entity mux is
  port( i_A : in std_logic;
        i_B : in std_logic;
        i_S : in std_logic;
        o_F : out std_logic);
        
end mux;
  
architecture structure of mux is

component inv is
  port(i_A : in std_logic;
       o_F : out std_logic);
  end component;
  
component and2 is
  port(i_A : in std_logic;
       i_B : in std_logic;
       o_F : out std_logic);
  end component;

component or2 is
  port( i_A : in std_logic;
        i_B : in std_logic;
        o_F : out std_logic);
  end component;

signal Sn : std_logic;
signal AS : std_logic;
signal BS : std_logic;

begin
  
  inv_1: inv
    port MAP(i_A => i_S,
             o_F => Sn);
             
  and_1 : and2
    port MAP( i_A => i_A,
              i_B => Sn,
              o_F => AS);
          
  and_2 : and2
    port MAP( i_A => i_B,
              i_B => i_S,
              o_F => BS);
              
  or_1 : or2
    port MAP( i_A => AS,
              i_B => BS,
              o_F => o_F);
              
end structure;
