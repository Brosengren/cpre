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
  generic(N : integer := 53);
  port( i_CLK  : in std_logic;
        i_RST  : in std_logic;
        i_WE   : in std_logic;
        i_D    : in std_logic_vector(N-1 downto 0);
        o_Q    : out std_logic_vector(N-1 downto 0));
  end component;

  signal tempSignalIn : std_logic_vector(31 downto 0) := (others => '0');
  signal tempSignalOut : std_logic_vector(31 downto 0) := (others => '0');

begin

  tempSignalIn(0) <= i_Branch;
  tempSignalIn(1) <= i_RegDst;
  tempSignalIn(2) <= i_Jump;
  tempSignalIn(3) <= i_JR;
  tempSignalIn(4) <= i_EqNe;
  tempSignalIn(5) <= i_LtGt;
  tempSignalIn(6) <= i_LSSigned;
  tempSignalIn(11 downto 7) <= i_ALUOp;
  tempSignalIn(16 downto 12) <= i_Rt;
  tempSignalIn(21 downto 17) <= i_Rs;
  tempSignalIn(53 downto 22) <= i_PCplus4;

  AllTheSignals : Nbit_reg
    port MAP( i_CLK => i_CLK,
              i_RST => i_RST,
              i_WE  => i_WE,
              i_D   => tempSignalIn,
              o_Q   => tempSignalOut);

  o_Branch   <= tempSignalOut(0);
  o_RegDst   <= tempSignalOut(1);
  o_Jump     <= tempSignalOut(2);
  o_JR       <= tempSignalOut(3);
  o_EqNe     <= tempSignalOut(4);
  o_LtGt     <= tempSignalOut(5);
  o_LSSigned <= tempSignalOut(6);
  o_ALUOp    <= tempSignalOut(11 downto 7);
  o_Rt       <= tempSignalOut(16 downto 12);
  o_Rs       <= tempSignalOut(21 downto 17);
  o_PCplus4  <= tempSignalOut(53 downto 22);

end veeandbee;
