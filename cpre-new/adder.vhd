library IEEE;
use IEEE.std_logic_1164.all;

entity adder is
  port( i_A : in std_logic;
        i_B : in std_logic;
        i_C : in std_logic;
        o_S : out std_logic;
        o_C : out std_logic);
        
end adder;

architecture structure of adder is
  
  component and2 is
    port( i_A : in std_logic;
          i_B : in std_logic;
          o_F : out std_logic);
  end component;
  
  component or2 is
    port( i_A : in std_logic;
          i_B : in std_logic;
          o_F : out std_logic);
  end component;
  
  component xor2 is
    port( i_A : in std_logic;
          i_B : in std_logic;
          o_F : out std_logic);
  end component;
  
  signal AxB, AxBC, AB : std_logic;
  
  begin
    
    xor_1 : xor2
      port MAP( i_A => i_A,
                i_B => i_B,
                o_F => AxB);
            
    xor_2 : xor2
      port MAP( i_A => AxB,
                i_B => i_C,
                o_F => o_S);
    
    and_1 : and2
      port MAP( i_A => i_C,
                i_B => AxB,
                o_F => AxBC);
             
    and_2 : and2
      port MAP( i_A => i_A,
                i_B => i_B,
                o_F => AB);
    
    or_1 : or2
      port MAP( i_A => AxBC,
                i_B => AB,
                o_F => o_C);
            
end structure;