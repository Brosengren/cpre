library IEEE;
use IEEE.std_logic_1164.all;

entity fasub is
  generic(N : integer := 8);
  port( i_A : in std_logic_vector(N-1 downto 0);
        i_B : in std_logic_vector(N-1 downto 0);
        i_C : in std_logic;
        i_S : in std_logic;
        o_S : out std_logic_vector(N-1 downto 0);
        o_C : out std_logic);
        
end fasub;

architecture structure of fasub is
  
  component fa_st is
    generic(N : integer := 8);
    port( i_A : in std_logic_vector(N-1 downto 0);
          i_B : in std_logic_vector(N-1 downto 0);
          i_C : in std_logic;
          o_S : out std_logic_vector(N-1 downto 0);
          o_C : out std_logic);
  end component;
  
  component OCStr is
    generic(N : integer := 8);
    port( i_A : in std_logic_vector(N-1 downto 0);
          o_F : out std_logic_vector(N-1 downto 0));
  end component;
  
  component muxN_st is
    generic(N : integer := 8);
    port( i_A : in std_logic_vector(N-1 downto 0);
          i_B : in std_logic_vector(N-1 downto 0);
          i_S : in std_logic;
          o_F : out std_logic_vector(N-1 downto 0));
  end component;
  
  signal s_Bn, s_B :std_logic_vector(N-1 downto 0);
  
  
  begin
    
    OCStr_1 : OCStr
      port MAP( i_A => i_B,
                o_F => s_Bn);
    
    mux_1 : muxN_st
      port MAP( i_A => i_B,
                i_B => s_Bn,
                i_S => i_S,
                o_F => s_B);
                
    fa_1 : fa_st
      port MAP( i_A => i_A,
                i_B => s_B,
                i_C => i_C,
                o_S => o_S,
                o_C => o_C);
                
end structure;
