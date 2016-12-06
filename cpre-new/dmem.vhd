library IEEE;
use IEEE.std_logic_1164.all;

entity dmem is
	generic( depth : integer := 10;
					mif_file : string := "dmem.mif");
  port( addr    : in std_logic_vector(31 downto 0);
        data    : in std_logic_vector(31 downto 0);
        we      : in std_logic;
        clock1  : in std_logic := '1';
        lssigned  : in std_logic;
        op      : in std_logic_vector(1 downto 0);
        dataout : out std_logic_vector(31 downto 0)); 
end dmem;

architecture BV of dmem is

component mux41 is
  generic(N : integer := 32);
  port( D3, D2, D1, D0 : in std_logic_vector(N-1 downto 0);
        i_S : in std_logic_vector(1 downto 0);
        o_F : out std_logic_vector(N-1 downto 0));
end component;


component extender8 is
  port( i_A : in std_logic_vector(7 downto 0);
        i_C : in std_logic;
        o_F : out std_logic_vector(31 downto 0));
end component;

component extender16 is
  port( i_A : in std_logic_vector(15 downto 0);
        i_C : in std_logic;
        o_F : out std_logic_vector(31 downto 0));
end component;

component muxN_st is
  generic(N : integer := 8);
  port( i_A : in std_logic_vector(N-1 downto 0);
        i_B : in std_logic_vector(N-1 downto 0);
        i_S : in std_logic;
        o_F : out std_logic_vector(N-1 downto 0));
end component;

component mux21 is
  generic(N : integer := 32);
  port( D1, D0  : in std_logic_vector(N-1 downto 0);
        i_S     : in std_logic;
        o_F     : out std_logic_vector(N-1 downto 0));
end component;

component mux_lb is
  port( i_A : in std_logic_vector(31 downto 0);
        i_S : in std_logic_vector(1 downto 0);
        o_F : out std_logic_vector(7 downto 0));   
end component;

 component mem is
   generic( depth_exp_of_2 : integer := depth;
            mif_filename   : string  := mif_file);
   port( address			: IN STD_LOGIC_VECTOR (depth_exp_of_2-1 DOWNTO 0) := (OTHERS => '0');
   		    byteena			: IN STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '1');
		     clock			  : IN STD_LOGIC := '1';
		     data			   : IN STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
		     wren			   : IN STD_LOGIC := '0';
		     q				     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));         
 end component;
 
 signal byte, halfword : std_logic_vector(31 downto 0);
 signal s1, s2, s3, s4, s5, s7, s8, s9 : std_logic_vector(31 downto 0);
 signal s6 :std_logic_vector(7 downto 0);
 signal ldupper, ldlower : std_logic_vector(31 downto 0);
 
 
 begin
   
   mux1 : mux41
    port MAP( D3  => x"00000008",
              D2  => x"00000004",
              D1  => x"00000002",
              D0  => x"00000001",
              i_S => addr(1 downto 0),
              o_F => s1);
              
  mux2 : mux21
    port MAP( D1  => x"0000000C",
              D0  => x"00000003",
              i_S => addr(1),
              o_F => s2);
              
  mux3 : mux41
    port MAP( D3 => x"00000000",
              D2 => x"0000000F",
              D1 => s2,
              D0 => s1,
              i_S => op,
              o_F => s3);
              
  byte <= data(7 downto 0) & data(7 downto 0) & data(7 downto 0) & data(7 downto 0);
  halfword <= data(15 downto 0) & data(15 downto 0);
  
  mux4 : mux41
    port MAP( D3  => x"00000000",
              D2  => data,
              D1  => halfword,
              D0  => byte,
              i_S => op,
              o_F => s4);
              
  damemory : mem
    port MAP( address => addr(11 downto 2),
              byteena => s3(3 downto 0),
              clock   => clock1,
              data    => s4,
              wren    => we,
              q       => s5);
            
  mux5 : mux_lb
    port MAP( i_A => s5,
              i_S => addr(1 downto 0),
              o_F => s6);
              
  ldupper <= x"0000" & s5(31 downto 16);
  ldlower <= x"0000" & s5(15 downto  0);
              
  mux6 : mux21
    port MAP( D1  => ldupper,
              D0  => ldlower,
              i_S => addr(1),
              o_F => s8);
              
  extnd1 : extender8
    port MAP( i_A => s6,
              i_C => lssigned,
              o_F => s7);
              
  extnd2 : extender16
    port MAP( i_A => s8(15 downto 0),
              i_C => lssigned,
              o_F => s9);
              
  mux7 : mux41
    port MAP( D3 => x"00000000",
              D2 => s5,
              D1 => s9,
              D0 => s7,
              i_S => op,
              o_F => dataout);
      
end BV;
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
