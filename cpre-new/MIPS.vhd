library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS is
  port( i_CLK      : in std_logic;
        read_rs    : in std_logic_vector(4 downto 0);
        read_rt    : in std_logic_vector(4 downto 0);
        write_data : in std_logic_vector(31 downto 0);
        write_addr : in std_logic_vector( 4 downto 0);
        write_en   : in std_logic;
        reset      : in std_logic;
        rs         : out std_logic_vector(31 downto 0);
        rt         : out std_logic_vector(31 downto 0));
        
end MIPS;

architecture BRADEN of MIPS is
  
  component decoder532 is
    port( i_A : in std_logic_vector(4 downto 0);
          o_F : out std_logic_vector (31 downto 0));
  end component;
  
  component mux321 is
    port( D31, D30, D29, D28, D27, D26, D25, D24, D23, D22, D21, D20, 
        D19, D18, D17, D16, D15, D14, D13, D12, D11, D10, D9, D8, D7,
        D6, D5, D4, D3, D2, D1, D0 : in std_logic_vector(31 downto 0);
        i_S : in std_logic_vector(4 downto 0);
        o_F : out std_logic_vector(31 downto 0));
  end component;
  
  component Nbit_reg is
    generic( N : integer := 32);
    port( i_CLK : in std_logic;
          i_RST : in std_logic;
          i_WE  : in std_logic;
          i_D   : in std_logic_vector(N-1 downto 0);
          o_Q   : out std_logic_vector(N-1 downto 0));
  end component;
  
  type registers is array (31 downto 0) of std_logic_vector(31 downto 0);
  signal regs : registers;
  signal w_addr_sig : std_logic_vector(31 downto 0);
  signal writeThisReg : std_logic_vector(31 downto 0);
  
  begin
    
    DECODE : decoder532
      port MAP( i_A => write_addr,
                o_F => w_addr_sig);
    
    GO : for i in 0 to 31 generate
    
      writeThisReg(i) <= w_addr_sig(i) and write_en;
    
    end generate;
    
    reg_0 : Nbit_reg
      port MAP( i_CLK => i_CLK,
                i_RST => '1',
                i_WE  => '0',
                i_D   => write_data,
                o_Q   => regs(0));
    
    write : for i in 1 to 31 generate
      
      reg_i : Nbit_reg
        port MAP( i_CLK => i_CLK,
                  i_RST => reset,
                  i_WE  => writeThisReg(i),
                  i_D   => write_data,
                  o_Q   => regs(i));
      
    end generate;
    
    rt_out : mux321
      port MAP( D31 => regs(31),
                D30 => regs(30),
                D29 => regs(29),
                D28 => regs(28),
                D27 => regs(27),
                D26 => regs(26),
                D25 => regs(25),
                D24 => regs(24),
                D23 => regs(23),
                D22 => regs(22),
                D21 => regs(21),
                D20 => regs(20),
                D19 => regs(19),
                D18 => regs(18),
                D17 => regs(17),
                D16 => regs(16),
                D15 => regs(15),
                D14 => regs(14),
                D13 => regs(13),
                D12 => regs(12),
                D11 => regs(11),
                D10 => regs(10),
                D9  => regs(9),
                D8  => regs(8),
                D7  => regs(7),
                D6  => regs(6),
                D5  => regs(5),
                D4  => regs(4),
                D3  => regs(3),
                D2  => regs(2),
                D1  => regs(1),
                D0  => regs(0),
                i_S => read_rt,
                o_F => rt);
                
    rs_out : mux321
      port MAP( D31 => regs(31),
                D30 => regs(30),
                D29 => regs(29),
                D28 => regs(28),
                D27 => regs(27),
                D26 => regs(26),
                D25 => regs(25),
                D24 => regs(24),
                D23 => regs(23),
                D22 => regs(22),
                D21 => regs(21),
                D20 => regs(20),
                D19 => regs(19),
                D18 => regs(18),
                D17 => regs(17),
                D16 => regs(16),
                D15 => regs(15),
                D14 => regs(14),
                D13 => regs(13),
                D12 => regs(12),
                D11 => regs(11),
                D10 => regs(10),
                D9  => regs(9),
                D8  => regs(8),
                D7  => regs(7),
                D6  => regs(6),
                D5  => regs(5),
                D4  => regs(4),
                D3  => regs(3),
                D2  => regs(2),
                D1  => regs(1),
                D0  => regs(0),
                i_S => read_rs,
                o_F => rs);
                
end BRADEN;