library IEEE;
use IEEE.std_logic_1164.all;

entity ID_Register is
  port( i_CLK     : in std_logic;
		i_RST     : in std_logic;
		i_WE      : in std_logic;

	--	i_Branch  : in std_logic;
		i_RegDst  : in std_logic;
	--	i_Jump    : in std_logic;
	--	i_JR      : in std_logic; --jump register instruction
	--	i_EqNe    : in std_logic;
	--	i_LtGt    : in std_logic;
		i_LSSigned: in std_logic;
		i_ALUOp   : in std_logic_vector(4 downto 0);
		i_Data2Reg: in std_logic_vector(1 downto 0);
		i_MemWrite: in std_logic;
		i_ALUSrc  : in std_logic_vector(1 downto 0);
		i_RegWrite: in std_logic;
	--	i_Link    : in std_logic;
		i_ShiftSrc: in std_logic_vector(1 downto 0);
	--	i_numorzero: in std_logic;
		i_shiftLog: in std_logic;
		i_shiftDir: in std_logic;
		i_LSSize  : in std_logic_vector(1 downto 0);

		i_RegRead1: in std_logic_vector(31 downto 0);
		i_RegRead2: in std_logic_vector(31 downto 0);
		i_SEimm : in std_logic_vector(31 downto 0);
		i_Rd_addr : in std_logic_vector(4 downto 0);
		i_Rt_addr2 : in std_logic_vector(4 downto 0);
		i_Rt_addr1 : in std_logic_vector(4 downto 0);
		i_Rs_addr : in std_logic_vector(4 downto 0);
	--	i_PCplus4 : in std_logic_vector(31 downto 0);
		i_instr		: in std_logic_vector(31 downto 0);
        i_Rt_data  : in std_logic_vector(31 downto 0);


	--	o_Branch  : out std_logic;
		o_RegDst  : out std_logic;
	--	o_Jump    : out std_logic;
	--	o_JR      : out std_logic; --jump register instruction
	--	o_EqNe    : out std_logic;
	--	o_LtGt    : out std_logic;
		o_LSSigned: out std_logic;
		o_ALUOp   : out std_logic_vector(4 downto 0);
		o_Data2Reg: out std_logic_vector(1 downto 0);
		o_MemWrite: out std_logic;
		o_ALUSrc  : out std_logic_vector(1 downto 0);
		o_RegWrite: out std_logic;
	--	o_Link    : out std_logic;
		o_ShiftSrc: out std_logic_vector(1 downto 0);
	--	o_numorzero: out std_logic;
		o_shiftLog: out std_logic;
		o_shiftDir: out std_logic;
		o_LSSize  : out std_logic_vector(1 downto 0);

		o_RegRead1: out std_logic_vector(31 downto 0);
		o_RegRead2: out std_logic_vector(31 downto 0);
		o_SEimm	: out std_logic_vector(31 downto 0);
		o_Rd_addr : out std_logic_vector(4 downto 0);
		o_Rt_addr2 : out std_logic_vector(4 downto 0);
		o_Rt_addr1  : out std_logic_vector(4 downto 0);
		o_Rs_addr   : out std_logic_vector(4 downto 0);
	--	o_PCplus4 : out std_logic_vector(31 downto 0);
		o_instr		: out std_logic_vector(31 downto 0);
        o_Rt_data   : out std_logic_vector(31 downto 0));
end ID_Register;

architecture veeandbee of ID_Register is

  component Nbit_reg is
  generic(N : integer := 239);
  port( i_CLK  : in std_logic;
		i_RST  : in std_logic;
		i_WE   : in std_logic;
		i_D    : in std_logic_vector(N-1 downto 0);
		o_Q    : out std_logic_vector(N-1 downto 0));
  end component;

  signal tempSignalIn : std_logic_vector(238 downto 0) := (others => '0');
  signal tempSignalOut : std_logic_vector(238 downto 0) := (others => '0');

begin

--	tempSignalIn(0) <= i_Branch;
	tempSignalIn(1) <= i_RegDst;
--	tempSignalIn(2) <= i_Jump;
--	tempSignalIn(3) <= i_JR;
--	tempSignalIn(4) <= i_EqNe;
--	tempSignalIn(5) <= i_LtGt;
	tempSignalIn(6) <= i_LSSigned;
	tempSignalIn(11 downto 7) <= i_ALUOp;
	tempSignalIn(16 downto 12) <= i_Rt_addr1;
	tempSignalIn(21 downto 17) <= i_Rs_addr;
--	tempSignalIn(53 downto 22) <= i_PCplus4;
	tempSignalIn(55 downto 54) <= i_Data2Reg;
	tempSignalIn(56) <= i_MemWrite;
--	tempSignalIn(58 downto 57) <= i_ALUSrc;
	tempSignalIn(60) <= i_RegWrite; --skipping bit 59 because i accidentally made RegWrite 2 bits at first
--	tempSignalIn(61) <= i_Link;
	tempSignalIn(63 downto 62) <= i_ShiftSrc;
--	tempSignalIn(64) <= i_numorzero;
	tempSignalIn(65) <= i_shiftLog;
	tempSignalIn(66) <= i_shiftDir;
	tempSignalIn(68 downto 67) <= i_LSSize;
	tempSignalIn(100 downto 69) <= i_RegRead1;
	tempSignalIn(132 downto 101) <= i_RegRead2;
	tempSignalIn(164 downto 133) <= i_SEimm;
	tempSignalIn(169 downto 165) <= i_Rd_addr;
	tempSignalIn(174 downto 170) <= i_Rt_addr2;
	tempSignalIn(206 downto 175) <= i_instr;
    tempSignalIn(238 downto 207) <= i_Rt_data;

	AllTheSignals : Nbit_reg
		port MAP( i_CLK => i_CLK,
				i_RST => i_RST,
				i_WE  => i_WE,
				i_D   => tempSignalIn,
				o_Q   => tempSignalOut);

--	o_Branch   	<= tempSignalOut(0);
	o_RegDst   	<= tempSignalOut(1);
--	o_Jump     	<= tempSignalOut(2);
--	o_JR       	<= tempSignalOut(3);
--	o_EqNe     	<= tempSignalOut(4);
--	o_LtGt     	<= tempSignalOut(5);
	o_LSSigned 	<= tempSignalOut(6);
	o_ALUOp    	<= tempSignalOut(11 downto 7);
	o_Rt_addr1 	<= tempSignalOut(16 downto 12);
	o_Rs_addr  	<= tempSignalOut(21 downto 17);
--	o_PCplus4  	<= tempSignalOut(53 downto 22);
	o_Data2Reg 	<= tempSignalOut(55 downto 54);
	o_MemWrite 	<= tempSignalOut(56);
--	o_ALUSrc   	<= tempSignalOut(58 downto 57);
	o_RegWrite 	<= tempSignalOut(60);
--	o_Link     	<= tempSignalOut(61);
	o_ShiftSrc 	<= tempSignalOut(63 downto 62);
--	o_numorzero	<= tempSignalOut(64);
	o_shiftLog 	<= tempSignalOut(65);
	o_shiftDir 	<= tempSignalOut(66);
	o_LSSize   	<= tempSignalOut(68 downto 67);
	o_RegRead1 	<= tempSignalOut(100 downto 69);
	o_RegRead2 	<= tempSignalOut(132 downto 101);
	o_SEimm    	<= tempSignalOut(164 downto 133);
	o_Rd_addr  	<= tempSignalOut(169 downto 165);
	o_Rt_addr2 	<= tempSignalOut(174 downto 170);
	o_instr		<= tempSignalOut(206 downto 175);
    o_Rt_data	<= tempSignalOut(238 downto 207);

end veeandbee;
