library IEEE;
use IEEE.std_logic_1164.all;

entity ALU1 is
  port( i_A, i_B      : in std_logic;
        a_inv, b_inv  : in std_logic;
        op            : in std_logic_vector(2 downto 0);
        less          : in std_logic;
        Cin           : in std_logic;
        set           : out std_logic;
        overflow      : out std_logic;
        Cout          : out std_logic;
        o_F           : out std_logic);
end ALU1;
  

architecture BradenVenecia of ALU1 is
  
  signal an, bn, s_A, s_B, AandB, AorB, AxB, sum, C_out, ovfl: std_logic;
  
  component adder is
    port( i_A : in std_logic;
          i_B : in std_logic;
          i_C : in std_logic;
          o_S : out std_logic;
          o_C : out std_logic);
  end component;
  
  
  begin
    
    an <= not i_A;
    bn <= not i_B;
    
    with a_inv select
      s_A <=  i_A when '0',
              an  when others;
              
    with b_inv select
      s_B <=  i_B when '0',
              bn when others;
              
    AandB <= s_A and s_B;
    AorB  <= s_A or  s_B;
    AxB   <= s_A xor s_B;
    
    ADD : adder
     port MAP(i_A => s_A,
              i_B => s_B,
              i_C => Cin,
              o_S => sum,
              o_C => C_out);
    
    with op select
      o_F <=  AandB when "000",
              AorB  when "001",  
              sum   when "010",   -- add/sub signed
              less  when "011",
              AxB   when "100",
              sum   when others;  -- add/sub unsigned

    
    ovfl     <= Cin xor C_out;          
    set      <= sum xor ovfl;
    Cout     <= C_out;
    overflow <= ovfl;

end BradenVenecia;
