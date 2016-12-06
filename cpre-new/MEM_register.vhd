library IEEE;
use IEEE.std_logic_1164.all;

entity MEM_register is
  port( CLK       : in std_logic;
        Reset     : in std_logic;
        Data2Reg  : in std_logic_vector(1 downto 0);
        RegWrite  : in std_logic;
        MemOut    : in std_logic_vector(31 downto 0);
        RdRt      : in std_logic_vector(4 downto 0);
        AluOut    : in std_logic_vector(31 downto 0);
		
        Data2Reg_o : out std_logic_vector(1 downto 0);
        RegWrite_o : out std_logic;
        MemOut_o   : out std_logic_vector(31 downto 0);
        RdRt_o     : out std_logic_vector(4 downto 0);
        ALUOut_o   : out std_logic_vector(31 downto 0));
end MEM_register;

architecture BV of MEM_register is
  
  component Nbit_reg is
    generic(N : integer := 72);
    port( i_CLK : in std_logic;
          i_RST : in std_logic;
          i_WE  : in std_logic;
          i_D   : in std_logic_vector(N-1 downto 0);
          o_Q   : out std_logic_vector(N-1 downto 0));
  end component;
  
  signal intoSignalReg : std_logic_vector(71 downto 0) := (others => '0');
  signal outofSignalReg : std_logic_vector(71 downto 0) := (others => '0');
  
  begin
  
  intoSignalReg(1 downto 0) <= Data2Reg;
  intoSignalReg(2)          <= RegWrite;
  intoSignalReg(34 downto 3)<= MemOut;
  intoSignalReg(39 downto 35) <= RdRt;
  intoSignalReg(71 downto 40) <= ALUOut;
  
  
  signal_reg : Nbit_reg
    port MAP( i_CLK => CLK,
              i_RST => Reset,
              i_WE  => '1',
              i_D   => intoSignalReg,
              o_Q   => outofSignalReg);
              
  Data2Reg_o <= outofSignalReg(1 downto 0);
<<<<<<< HEAD
  RegWrite_o <= outofSignalReg(2);
  MemOut_o   <= outofSignalReg(34 downto 3);
  RdRt_o     <= outofSignalReg(39 downto 35);
=======
  RegWrite_o <= outofSignalReg(2);
  MemOut_o   <= outofSignalReg(34 downto 3);
  RdRt_o     <= outofSignalReg(39 downto 35);
>>>>>>> bb468a737d1fdaf0fd5474158ad8cbd83e2026ef
  ALUOut_o   <= outofSignalReg(71 downto 40);
  


end BV;

