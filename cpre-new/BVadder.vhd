library IEEE;
use IEEE.std_logic_1164.all;

entity BVadder is
	port( A     : in std_logic_vector(31 downto 0);
	      B     : in std_logic_vector(31 downto 0);
	      Set   : out std_logic;
	      F     : out std_logic_vector(31 downto 0));
end BVadder;


architecture BradenVenecia of BVadder is
  
  component fa_st is
    generic(N : integer := 32);
    port( i_A : in std_logic_vector(N-1 downto 0);
          i_B : in std_logic_vector(N-1 downto 0);
          i_C : in std_logic;
          o_S : out std_logic_vector(N-1 downto 0);
          o_C : out std_logic);
  end component;
  
  signal foo : std_logic_vector(31 downto 0);
  signal c : std_logic;
  
  
  begin
  
  add : fa_st
    port MAP( i_A => A,
              i_B => B,
              i_C => '0',
              o_S => foo,
              o_C => c);
              
  Set <= foo(0); 
  F   <= c & foo(31 downto 1);
 
end BradenVenecia;