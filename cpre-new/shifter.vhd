library IEEE;
use IEEE.std_logic_1164.all;


entity shifter is
  port( A     : in std_logic_vector(31 downto 0);
        shift : in std_logic_vector( 4 downto 0);
        logic : in std_logic;
				C     : in std_logic;
        F     : out std_logic_vector(31 downto 0));
end shifter;

architecture structure of shifter is
  
  signal msb : std_logic;
  signal t1  : std_logic_vector(31 downto 0);
  signal t2  : std_logic_vector(31 downto 0);
  signal t3  : std_logic_vector(31 downto 0);
  signal t4  : std_logic_vector(31 downto 0);
  signal t5  : std_logic_vector(31 downto 0);
	signal f_A : std_logic_vector(31 downto 0);
  signal s_A : std_logic_vector(31 downto 0);
	signal s_t : std_logic_vector(31 downto 0);

  component mux is
    port( i_A : in std_logic;
          i_B : in std_logic;
          i_S : in std_logic;
          o_F : out std_logic);
  end component;
  
  begin

		switch_1 : for i in 0 to 31 generate
			f_A(i) <= A(31 - i);
		end generate;

		sw_1 : for i in 0 to 31 generate
			switch_mux_1 : mux
				port MAP( i_A => f_A(i),
									i_B => A(i),
									i_S => C,
									o_F => s_A(i));
		end generate;

    mux1 : mux
    port MAP( i_A => '0',
              i_B => s_A(31),
              i_S => logic,
              o_F => msb);
    
    
----tier 1
    bits1 : mux
    port MAP( i_A => s_A(31),
              i_B => msb,
              i_S => shift(0),
              o_F => t1(31));
       
    
    g1 : for i in 30 downto 0 generate
      
      mux1_i : mux
        port MAP( i_A => s_A(i),
                  i_B => s_A(i + 1),
                  i_S => shift(0),
                  o_F => t1(i));
                  
    end generate;
    
----tier 2
    
    bits2 : for i in 31 downto 30 generate
      mux2_i : mux
        port MAP( i_A => t1(i),
                  i_B => msb,
                  i_S => shift(1),
                  o_F => t2(i));
    end generate;
      
    
    g2 : for i in 29 downto 0 generate
      
      mux3_i : mux
        port MAP( i_A => t1(i),
                  i_B => t1(i + 2),
                  i_S => shift(1),
                  o_F => t2(i));
    
    end generate;
    
----tier 3
    
    bits3 : for i in 31 downto 28 generate
      mux4_i: mux
        port MAP( i_A => t2(i),
                  i_B => msb,
                  i_S => shift(2),
                  o_F => t3(i));
    end generate;
    
    g3 : for i in 27 downto 0 generate
      
      mux5_i : mux
        port MAP( i_A => t2(i),
                  i_B => t2(i + 4),
                  i_S => shift(2),
                  o_F => t3(i));
    end generate;
                  
 ----tier 4
    
    bits4 : for i in 31 downto 24 generate
      mux6_i : mux
        port MAP( i_A => t3(i),
                  i_B => msb,
                  i_S => shift(3),
                  o_F => t4(i));
    end generate;
    
    g4 : for i in 23 downto 0 generate
      
      mux7_i : mux
        port MAP( i_A => t3(i),
                  i_B => t3(i + 8),
                  i_S => shift(3),
                  o_F => t4(i));
    end generate;
    
 ----tier 5
    
    bits5 : for i in 31 downto 16 generate
      mux8_i : mux
        port MAP( i_A => t4(i),
                  i_B => msb,
                  i_S => shift(4),
                  o_F => t5(i));
    end generate;
    
    g5 : for i in 15 downto 0 generate
      
      mux9_i : mux
        port MAP( i_A => t4(i),
                  i_B => t4(i + 16),
                  i_S => shift(4),
                  o_F => t5(i));
    end generate;
    
		switch_2 : for i in 0 to 31 generate
			s_t(i) <= t5(31 - i);
		end generate;

		sw2 : for i in 0 to 31 generate
			switch_mux_2 : mux
				port MAP( i_A => s_t(i),
									i_B => t5(i),
									i_S => C,
									o_F => F(i));
		end generate;

end structure;
    
