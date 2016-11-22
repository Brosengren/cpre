library IEEE;
use IEEE.std_logic_1164.all;

entity IF_Register2 is
  port( i_CLK     : in std_logic;
        i_RST     : in std_logic;
        i_WE      : in std_logic;
        
        i_instr   : in std_logic_vector(31 downto 0);
        i_PCplus4 : in std_logic_vector(31 downto 0);
        
        o_instr   : out std_logic_vector(31 downto 0);
        o_PCplus4 : out std_logic_vector(31 downto 0)
        );
end IF_Register2;

architecture veeandbee of IF_Register2 is
  
  component Nbit_reg is
  generic(N : integer := 32);
  port( i_CLK  : in std_logic;
        i_RST  : in std_logic;
        i_WE   : in std_logic;
        i_D    : in std_logic_vector(N-1 downto 0);
        o_Q    : out std_logic_vector(N-1 downto 0));
  end component;

begin
  
  instr_reg : Nbit_reg
    port MAP( i_CLK => i_CLK,
              i_RST => i_RST,
              i_WE  => i_WE,
              i_D   => i_instr,
              o_Q   => o_instr);
              
  PCplus4_reg : Nbit_reg
    port MAP( i_CLK => i_CLK,
              i_RST => i_RST,
              i_WE  => i_WE,
              i_D   => i_PCplus4,
              o_Q   => o_PCPlus4);
 
  
end veeandbee;
