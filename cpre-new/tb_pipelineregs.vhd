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
        i_ALUOp   : in std_logic_vector(4 downto 0);
        i_Rt      : in std_logic_vector(4 downto 0);
        i_Rs      : in std_logic_vector(4 downto 0);
        i_PCplus4 : in std_logic_vector(31 downto 0);
				i_Data2Reg: in std_logic_vector(1 downto 0);
				i_MemWrite: in std_logic;
				i_ALUSrc  : in std_logic_vector(1 downto 0);
				i_RegWrite: in std_logic;
				i_Link    : in std_logic;
				i_ShiftSrc: in std_logic_vector(1 downto 0);
				i_numorzero: in std_logic;
				i_shiftLog: in std_logic;
				i_shiftDir: in std_logic;
				i_LSSize  : in std_logic_vector(1 downto 0);
        o_Branch  : out std_logic;
        o_RegDst  : out std_logic;
        o_Jump    : out std_logic;
        o_JR      : out std_logic; --jump register instruction
        o_EqNe    : out std_logic;
        o_LtGt    : out std_logic;
        o_LSSigned: out std_logic;
        o_ALUOp   : out std_logic_vector(4 downto 0);
        o_Rt      : out std_logic_vector(4 downto 0);
        o_Rs      : out std_logic_vector(4 downto 0);
        o_PCplus4 : out std_logic_vector(31 downto 0);
				o_Data2Reg: out std_logic_vector(1 downto 0);
				o_MemWrite: out std_logic;
				o_ALUSrc  : out std_logic_vector(1 downto 0);
				o_RegWrite: out std_logic;
				o_Link    : out std_logic;
				o_ShiftSrc: out std_logic_vector(1 downto 0);
				o_numorzero: out std_logic;
				o_shiftLog: out std_logic;
				o_shiftDir: out std_logic;
				o_LSSize  : out std_logic_vector(1 downto 0));
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

  signal s_CLK      : std_logic;

  --IF signals
  signal IF_RST, IF_WE              : std_logic;
  signal IF_i_instr, IF_o_instr     : std_logic_vector(31 downto 0);
  signal IF_i_PCplus4, IF_o_PCplus4 : std_logic_vector(31 downto 0);

  --ID signals
  signal ID_RST, ID_WE              : std_logic;
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
  signal ID_i_Data2Reg, ID_o_Data2Reg : std_logic_vector(1 downto 0);
	signal ID_i_MemWrite, ID_o_MemWrite : std_logic;
	signal ID_i_ALUSrc, ID_o_ALUSrc : std_logic_vector(1 downto 0);
  signal ID_i_RegWrite, ID_o_RegWrite : std_logic;
  signal ID_i_Link, ID_o_Link       : std_logic;
  signal ID_i_ShiftSrc, ID_o_ShiftSrc : std_logic_vector(1 downto 0);
  signal ID_i_numorzero, ID_o_numorzero :std_logic;
  signal ID_i_shiftLog, ID_o_shiftLog : std_logic;
  signal ID_i_shiftDir, ID_o_shiftDir : std_logic;
  signal ID_i_LSSize, ID_o_LSSize : std_logic_vector (1 downto 0);
  
  --EX signals
  signal EX_RST: std_logic;
  signal EX_i_MemWr, EX_o_MemWr : std_logic;
  signal EX_i_MemSign, EX_o_MemSign : std_logic;
  signal EX_i_MemHW, EX_o_MemHW : std_logic;
  signal EX_i_MemByte, EX_o_MemByte : std_logic;
  
  --MEM signals
  signal MEM_RST : std_logic;
  signal MEM_i_Data2Reg, MEM_o_Data2Reg : std_logic_vector(1 downto 0);
  signal MEM_i_RegWrite, MEM_o_RegWrite : std_logic;
  signal MEM_i_MemOut, MEM_o_MemOut     : std_logic_vector(31 downto 0);
  signal MEM_i_RdRt, MEM_o_RdRt         : std_logic_vector(31 downto 0);
  signal MEM_i_ALUOut, MEM_o_ALUOut     : std_logic_vector(31 downto 0);

begin

  testIF : IF_Register2
    port map( i_CLK     => s_CLK,
              i_RST     => IF_RST,
              i_WE      => IF_WE,
              i_instr   => IF_i_instr,
              i_PCplus4 => IF_i_PCplus4,
              o_instr   => IF_o_instr,
              o_PCplus4 => IF_o_PCplus4);
              
  testID : ID_Register
    port map( i_CLK      => s_CLK,
              i_RST      => ID_RST,
              i_WE       => ID_WE,
              i_Branch   => ID_i_Branch,
              i_RegDst   => ID_i_RegDst,
              i_Jump     => ID_i_Jump,
              i_JR       => ID_i_JR,
              i_EqNe     => ID_i_EqNe,
              i_LtGt     => ID_i_LtGt,
              i_LSSigned => ID_i_LSSigned,
              i_ALUOp    => ID_i_ALUOp,
              i_Rt       => ID_i_Rt,
              i_Rs       => ID_i_Rs,
              i_PCplus4  => ID_i_PCplus4,
              i_Data2Reg => ID_i_Data2Reg,
              i_MemWrite => ID_i_MemWrite,
              i_ALUSrc   => ID_i_ALUSrc,
              i_RegWrite => ID_i_RegWrite,
              i_Link     => ID_i_Link,
              i_ShiftSrc => ID_i_ShiftSrc,
              i_numorzero=> ID_i_numorzero,
              i_shiftLog => ID_i_shiftLog,
              i_shiftDir => ID_i_shiftDir,
              i_LSSize   => ID_i_LSSize,
              o_Branch   => ID_o_Branch,
              o_RegDst   => ID_o_RegDst,
              o_Jump     => ID_o_Jump,
              o_JR       => ID_o_JR,
              o_EqNe     => ID_o_EqNe,
              o_LtGt     => ID_o_LtGt,
              o_LSSigned => ID_o_LSSigned,
              o_ALUOp    => ID_o_ALUOp,
              o_Rt       => ID_o_Rt,
              o_Rs       => ID_o_Rs,
              o_PCplus4  => ID_o_PCplus4,
              o_Data2Reg => ID_o_Data2Reg,
              o_MemWrite => ID_o_MemWrite,
              o_ALUSrc   => ID_o_ALUSrc,
              o_RegWrite => ID_o_RegWrite,
              o_Link     => ID_o_Link,
              o_ShiftSrc => ID_o_ShiftSrc,
              o_numorzero=> ID_o_numorzero,
              o_shiftLog => ID_o_shiftLog,
              o_shiftDir => ID_o_shiftDir,
              o_LSSize   => ID_o_LSSize
              );
              
  testEX: EX_Register
      port map( CLK       => s_CLK,
                Reset     => EX_RST,
                MemWr     => EX_i_MemWr,
                MemSign   => EX_i_MemSign,
                MemHW     => EX_i_MemHW,
                MemByte   => EX_i_MemByte,
                MemWr_o   => EX_o_MemWr,
                MemSign_o => EX_o_MemSign,
                MemHW_o   => EX_o_MemHW,
                MemByte_o => EX_o_MemByte);
  
  testMEM: MEM_Register
      port map( CLK        => s_CLK,
                Reset      => MEM_RST,
                Data2Reg   => MEM_i_Data2Reg,
                RegWrite   => MEM_i_RegWrite,
                MemOut     => MEM_i_MemOut,
                RdRt       => MEM_i_RdRt,
                AluOut     => MEM_i_ALUOut,
                Data2Reg_o => MEM_o_Data2Reg,
                RegWrite_o => MEM_o_RegWrite,
                MemOut_o   => MEM_o_MemOut,
                RdRt_o     => MEM_o_RdRt,
                ALUOut_o   => MEM_o_ALUOut);
                

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

    IF_RST  <= '1';
    ID_RST  <= '1';
    EX_RST  <= '1';
    MEM_RST <= '1';
    wait for cCLK_PER;

    IF_i_instr <= x"10101010";
    wait for cCLK_PER;

    IF_i_instr <= x"11111111";
    IF_i_PCplus4 <= x"11110000";
    wait for cCLK_PER;

    wait;
  end process;

end behavior;
