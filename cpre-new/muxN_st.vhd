library IEEE;
use IEEE.std_logic_1164.all;

entity muxN_st is
  generic(N : integer := 8);
  port( i_A : in std_logic_vector(N-1 downto 0);
        i_B : in std_logic_vector(N-1 downto 0);
        i_S : in std_logic;
        o_F : out std_logic_vector(N-1 downto 0));
        
end muxN_st;

architecture structure of muxN_st is
  
component mux_st is
  port( i_A : in std_logic;
        i_B : in std_logic;
        i_S : in std_logic;
        o_F : out std_logic);
  end component;

begin
  
  GO: for i in 0 to N-1 generate
    mux_i: mux_st
      port MAP( i_A => i_A(i),
                i_B => i_B(i),
                i_S => i_S,
                o_F => o_F(i));
  end generate;
  
end structure;