library IEEE;
use IEEE.std_logic_1164.all;

entity ID_Register is
  port( i_CLK     : in std_logic;
        i_RST     : in std_logic;
        i_WE      : in std_logic;
        
        i_Branch  : in std_logic;
        i_RegDst  : in std_logic;
        i_Jump    : in std_logic;
        i_JR      : in std_logic; --jump register instruction
        i_EqNe    : in std_logic;
        i_LtGt    : in std_logic;
        i_LSSigned: in std_logic;
        i_ALUOp   : in std_logic(4 downto 0);
        i_Rt      : in std_logic_vector(4 downto 0);
        i_Rs      : in std_logic_vector(4 downto 0);
        i_PCplus4 : in std_logic_vector(31 downto 0);
        
        o_Branch  : out std_logic;
        o_RegDst  : out std_logic;
        o_Jump    : out std_logic;
        o_JR      : out std_logic; --jump register instruction
        o_EqNe    : out std_logic;
        o_LtGt    : out std_logic;
        o_LSSigned: out std_logic;
        o_ALUOp   : out std_logic(4 downto 0);
        o_Rt      : out std_logic_vector(4 downto 0);
        o_Rs      : out std_logic_vector(4 downto 0);
        o_PCplus4 : out std_logic_vector(31 downto 0);
        );
end ID_Register;

architecture veeandbee of ID_Register is
  
  component Nbit_reg is
  generic(N : integer := 32);
  port( i_CLK  : in std_logic;
        i_RST  : in std_logic;
        i_WE   : in std_logic;
        i_D    : in std_logic_vector(N-1 downto 0);
        o_Q    : out std_logic_vector(N-1 downto 0));
  end component;

begin
  
  Branch_reg : Nbit_reg
    port MAP( i_CLK => i_CLK,
              i_RST => i_RST,
              i_WE  => i_WE,
              i_D   => i_Branch,
              o_Q   => o_Branch);
              
  RegDst_reg : Nbit_reg
    port MAP( i_CLK => i_CLK,
              i_RST => i_RST,
              i_WE  => i_WE,
              i_D   => i_RegDst,
              o_Q   => o_RegDst);

  Jump_reg : Nbit_reg
    port MAP( i_CLK => i_CLK,
              i_RST => i_RST,
              i_WE  => i_WE,
              i_D   => i_Jump,
              o_Q   => o_Jump);
              
  JR_reg : Nbit_reg
    port MAP( i_CLK => i_CLK,
              i_RST => i_RST,
              i_WE  => i_WE,
              i_D   => i_JR,
              o_Q   => o_JR);
              
  EqNe_reg : Nbit_reg
    port MAP( i_CLK => i_CLK,
              i_RST => i_RST,
              i_WE  => i_WE,
              i_D   => i_EqNe,
              o_Q   => o_EqNe);
              
  LtGt_reg : Nbit_reg
    port MAP( i_CLK => i_CLK,
              i_RST => i_RST,
              i_WE  => i_WE,
              i_D   => i_LtGt,
              o_Q   => o_LtGt);
              
  LSSigned_reg : Nbit_reg
    port MAP( i_CLK => i_CLK,
              i_RST => i_RST,
              i_WE  => i_WE,
              i_D   => i_LSSigned,
              o_Q   => o_LSSigned);
                                            
end veeandbee;
