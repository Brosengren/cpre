library IEEE;
use IEEE.std_logic_1164.all;

entity Nbit_reg is
  generic(N : integer := 32);
  port( i_CLK  : in std_logic;
        i_RST  : in std_logic;
        i_WE   : in std_logic;
        i_D    : in std_logic_vector(N-1 downto 0);
        o_Q    : out std_logic_vector(N-1 downto 0));
end Nbit_reg;

architecture mixed of Nbit_reg is
  
  signal s_D    : std_logic_vector(N-1 downto 0);    -- Multiplexed input to the FF
  signal s_Q    : std_logic_vector(N-1 downto 0);    -- Output of the FF

begin

  -- The output of the FF is fixed to s_Q
  
  set_outputs : for i in 0 to N-1 generate
    o_Q(i) <= s_Q(i);
  
   -- Create a multiplexed input to the FF based on i_WE
   with i_WE select
      s_D(i) <= i_D(i) when '1',
             s_Q(i) when others;
  
    -- This process handles the asyncrhonous reset and
    -- synchronous write. We want to be able to reset 
    -- our processor's registers so that we minimize
    -- glitchy behavior on startup.
    process (i_CLK, i_RST, i_D)
    begin
      if (i_RST = '1') then
        s_Q(i) <= '0'; -- Use "(others => '0')" for N-bit values
      elsif (rising_edge(i_CLK)) then
        s_Q(i) <= s_D(i);
      end if;
      
    end process;
  
  end generate;
  
end mixed;
