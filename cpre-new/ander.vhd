library IEEE;
use IEEE.std_logic_1164.all;

entity ander is
	port( A     : in std_logic_vector(31 downto 0);
	      B     : in std_logic;
	      F     : out std_logic_vector(31 downto 0));
end ander;


architecture BradenVenecia of ander is
  
  component and2 is 
    port( i_A : in std_logic;
          i_B : in std_logic;
          o_F : out std_logic);
  end component;
  
begin
  
  GO : for i in 0 to 31 generate
    
     and_i : and2
      port MAP( i_A => A(i),
                i_B => B,
                o_F => F(i));
                
  end generate;
  

end BradenVenecia;