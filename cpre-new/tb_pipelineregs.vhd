-- tb_pipelineregs.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_pipelineregs is
  generic(gCLK_HPER   : time := 50 ns);
end tb_pipelineregs;

architecture behavior of tb_pipelineregs is

component IF_Register2 is
  port( i_CLK     : in std_logic;
        i_RST     : in std_logic;
        i_WE      : in std_logic;

        i_instr   : in std_logic_vector(31 downto 0);
        i_PCplus4 : in std_logic_vector(31 downto 0);

        o_instr   : out std_logic_vector(31 downto 0);
        o_PCplus4 : out std_logic_vector(31 downto 0));
end component;

component ID_Register is
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
        o_PCplus4 : out std_logic_vector(31 downto 0));
		end component;

component EX_register is
	port(	CLK		: in std_logic;
			Reset	: in std_logic;

			MemWr 	: in std_logic;
			MemSign	: in std_logic;
			MemHW	: in std_logic;
			MemByte	: in std_logic;

			MemWr_o		: out std_logic;
			MemSign_o	: out std_logic;
			MemHW_o : out std_logic;
			MemByte_o : out std_logic);
end component;

component MEM_register is
	port( CLK       : in std_logic;
				Reset     : in std_logic;
				Data2Reg  : in std_logic_vector(1 downto 0);
				RegWrite  : in std_logic;
				MemOut    : in std_logic_vector(31 downto 0);
				RdRt      : in std_logic_vector(31 downto 0);
				AluOut    : in std_logic_vector(31 downto 0);
				Data2Reg_o : out std_logic_vector(1 downto 0);
				RegWrite_o : out std_logic;
				MemOut_o   : out std_logic_vector(31 downto 0);
				RdRt_o     : out std_logic_vector(31 downto 0);
				ALUOut_o   : out std_logic_vector(31 downto 0));
		end component;

  constant cCLK_PER  : time := gCLK_HPER * 2;

  signal s_CLK, s_RST, s_WE      : std_logic;

  //IF signals
  signal IF_i_instr, IF_o_instr  : std_logic_vector(31 downto 0);
  signal IF_i_PCplus4, IF_o_PCplus4 : std_logic_vector(31 downto 0);

  //ID signals
  signal ID_i_Branch, ID_o_Branch : std_logic;
  signal ID_i_RegDst, ID_o_RegDst: std_logic;
  signal ID_i_Jump, ID_o_Jump : std_logic;
  signal ID_i_JR, ID_o_JR : std_logic;
  signal ID_i_EqNe, ID_o_EqNe : std_logic;
  signal ID_i_LtGt, ID_o_LtGt : std_logic;
  signal ID_i_LSSigned, ID_o_LSSigned : std_logic;
  signal ID_i_ALUOp, ID_o_ALUOp : std_logic_vector(4 downto 0);
  signal ID_i_Rt, ID_o_Rt : std_logic_vector(4 downto 0);
  signal ID_i_Rs, ID_o_Rs : std_logic_vector(4 downto 0);
  signal ID_i_PCplus4, ID_o_PCplus4 : std_logic_vector(31 downto 0);

begin

  testIF : IF_Register2
    port map( i_CLK     => s_CLK,
              i_RST     => s_RST,
              i_WE      => s_WE,
              i_instr   => IF_i_instr,
              i_PCplus4 => IF_i_PCplus4,
              o_instr   => IF_o_instr,
              o_PCplus4 => IF_o_PCplus4);

  -- Clock
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;

  -- Testbench process
  P_TB: process
  begin

    s_RST <= '1';
    wait for cCLK_PER;

    IF_i_instr <= x"10101010";
    wait for cCLK_PER;

    IF_i_instr <= x"11111111";
    IF_i_PCplus4 <= x"11110000";
    wait for cCLK_PER;

    wait;
  end process;

end behavior;
