library IEEE;
use IEEE.std_logic_1164.all;

entity fa_st is
  generic(N : integer := 32);
  port( i_A : in std_logic_vector(N-1 downto 0);
        i_B : in std_logic_vector(N-1 downto 0);
        i_C : in std_logic;
        o_S : out std_logic_vector(N-1 downto 0);
        o_C : out std_logic);
        
end fa_st;

architecture structure of fa_st is
  
  component adder
    port( i_A : in std_logic;
          i_B : in std_logic;
          i_C : in std_logic;
          o_S : out std_logic;
          o_C : out std_logic);
  end component;
  
  signal s_C : std_logic_vector(N downto 0);
  
  begin
    
    s_C(0) <= i_C;  
                  
    GO : for i in 0 to N-1 generate
      adder_i : adder
        port MAP( i_A => i_A(i),
                  i_B => i_B(i),
                  i_C => s_C(i),
                  o_S => o_S(i),
                  o_C => s_C(i+1));
    end generate;
      
    o_C <= s_C(N);
                  
end structure;