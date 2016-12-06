--http://courses.cs.vt.edu/cs2506/Spring2013/Assignments/8/ForwardingUnit.pdf
--look here for info on forwarding unit


library IEEE;
use IEEE.std_logic_1164.all;

entity pipeline is
	port( CLK	: in std_logic);
end pipeline;
	
architecture BV of pipeline is
	
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
	  port( i_CLK     	: in std_logic;
	        i_RST     	: in std_logic;
	        i_WE      	: in std_logic;
	
	        i_Branch  	: in std_logic;
	        i_RegDst  	: in std_logic;
	        i_Jump    	: in std_logic;
	        i_JR      	: in std_logic; --jump register instruction
	        i_EqNe    	: in std_logic;
	        i_LtGt    	: in std_logic;
	        i_LSSigned	: in std_logic;
	        i_ALUOp   	: in std_logic_vector(4 downto 0);
	        i_PCplus4 	: in std_logic_vector(31 downto 0);
			i_Data2Reg	: in std_logic_vector(1 downto 0);
			i_MemWrite	: in std_logic;
			i_ALUSrc  	: in std_logic_vector(1 downto 0);
			i_RegWrite	: in std_logic;
			i_Link    	: in std_logic;
			i_ShiftSrc	: in std_logic_vector(1 downto 0);
			i_numorzero	: in std_logic;
			i_shiftLog	: in std_logic;
			i_shiftDir	: in std_logic;
			i_LSSize  	: in std_logic_vector(1 downto 0);
	
	        i_Rt_addr1	: in std_logic_vector(4 downto 0);
	        i_Rs_addr 	: in std_logic_vector(4 downto 0);
			i_RegRead1	: in std_logic_vector(31 downto 0);
			i_RegRead2	: in std_logic_vector(31 downto 0);
			i_SEimm   	: in std_logic_vector(31 downto 0);
			i_Rd_addr 	: in std_logic_vector(4 downto 0);
			i_Rt_addr2	: in std_logic_vector(4 downto 0);
		
	
	        o_Branch  	: out std_logic;
	        o_RegDst  	: out std_logic;
	        o_Jump   	: out std_logic;
	        o_JR     	: out std_logic; --jump register instruction
	        o_EqNe   	: out std_logic;
	        o_LtGt  	: out std_logic;
	        o_LSSigned	: out std_logic;
	        o_ALUOp   	: out std_logic_vector(4 downto 0);
	       
	        o_PCplus4 	: out std_logic_vector(31 downto 0);
			o_Data2Reg	: out std_logic_vector(1 downto 0);
			o_MemWrite	: out std_logic;
			o_ALUSrc  	: out std_logic_vector(1 downto 0);
			o_RegWrite	: out std_logic;
			o_Link    	: out std_logic;
			o_ShiftSrc	: out std_logic_vector(1 downto 0);
			o_numorzero	: out std_logic;
			o_shiftLog	: out std_logic;
			o_shiftDir	: out std_logic;
			o_LSSize  	: out std_logic_vector(1 downto 0);
	
			o_Rt_addr1	: out std_logic_vector(4 downto 0);
	        o_Rs_addr	: out std_logic_vector(4 downto 0);
			o_RegRead1	: out std_logic_vector(31 downto 0);
			o_RegRead2	: out std_logic_vector(31 downto 0);
			o_SEimm   	: out std_logic_vector(31 downto 0);
			o_Rd_addr 	: out std_logic_vector(4 downto 0);
			o_Rt_addr2	: out std_logic_vector(4 downto 0));
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
		port(	CLK       : in std_logic;
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

	component mux is
		port( 	i_A : in std_logic;
				i_B : in std_logic;
				i_S : in std_logic;
				o_F : out std_logic);
		end component;

	component mux21 is
		generic(N 	: integer := 32);
		port(	D1  : in std_logic_vector(N-1 downto 0);
				D0 	: in std_logic_vector(N-1 downto 0);
				i_S : in std_logic;
				o_F : out std_logic_vector(N-1 downto 0));
	end component;

	--component mux31 is
	--	generic(N   : integer := 32);
	--	port(	D2 	: in std_logic_vector(N-1 downto 0);
	--			D1 	: in std_logic_vector(N-1 downto 0);
	--			D0  : in std_logic_vector(N-1 downto 0);
	--			i_S : in std_logic_vector(  1 downto 0);
	--			o_F : out std_logic_vector(N-1 downto 0));
	--end component;

	component mux41 is
		generic(N 	: integer := 32);
		port(	D3  : in std_logic_vector(N-1 downto 0);
				D2  : in std_logic_vector(N-1 downto 0);
				D1  : in std_logic_vector(N-1 downto 0);
				D0  : in std_logic_vector(N-1 downto 0);
				i_S : in std_logic_vector(1 downto 0);
				o_F : out std_logic_vector(N-1 downto 0));
	end component;

	component control is
		port( 	I 			: in std_logic_vector(31 downto 0);
				RegDst		: out std_logic;
				Jump		: out std_logic;
				JR			: out std_logic;
				Branch		: out std_logic;
				MemRead  : out std_logic;
				Data2Reg	: out std_logic_vector(1 downto 0);
				ALUOp		: out std_logic_vector(4 downto 0);
				MemWrite	: out std_logic;
				ALUSrc		: out std_logic_vector(1 downto 0);
				RegWrite	: out std_logic;
				Link		: out std_logic;
				numOrZero	: out std_logic;
				EQNE		: out std_logic;
				GTLT		: out std_logic;
				shiftSrc	: out std_logic_vector(1 downto 0);
				shiftLog	: out std_logic;
				shiftDir	: out std_logic;
				LSSigned  : out std_logic;
				LSSize		: out std_logic_vector(1 downto 0));
	end component;

	component shifter is
		port(	A	 	: in std_logic_vector(31 downto 0);
				shift 	: in std_logic_vector( 4 downto 0);
				logic 	: in std_logic;
				C	 	: in std_logic;
				F	 	: out std_logic_vector(31 downto 0));
	end component;

	component and2 is
		port(	i_A : in std_logic;
				i_B : in std_logic;
				o_F : out std_logic);
	end component;

	component mult is
		port( 	A  : in std_logic_vector(31 downto 0);
				B  : in std_logic_vector(31 downto 0);
				lo : out std_logic_vector(31 downto 0);
				hi : out std_logic_vector(31 downto 0));
	end component;

	component extender16 is
		port( 	i_A : in std_logic_vector(15 downto 0);
				i_C : in std_logic;
				o_F : out std_logic_vector(31 downto 0));
	end component;

	component mem is
		generic(depth_exp_of_2 	: integer := 10;
				mif_filename	: string := "bubbleDmem.mif");
		port(	address			: IN STD_LOGIC_VECTOR (depth_exp_of_2-1 DOWNTO 0) := (OTHERS => '0');
				byteena			: IN STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '1');
				clock			: IN STD_LOGIC := '1';
				data			: IN STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
				wren			: IN STD_LOGIC := '0';
				q				: OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
	end component;

	component MIPS is
		port( 	i_CLK	  	: in std_logic;
				read_rs		: in std_logic_vector(4 downto 0);
				read_rt		: in std_logic_vector(4 downto 0);
				write_data 	: in std_logic_vector(31 downto 0);
				write_addr 	: in std_logic_vector( 4 downto 0);
				write_en   	: in std_logic;
				reset	  	: in std_logic;
				rs		 	: out std_logic_vector(31 downto 0);
				rt		 	: out std_logic_vector(31 downto 0));
	end component;

	component Nbit_reg is
		generic(N : integer := 32);
		port(	i_CLK  : in std_logic;
				i_RST  : in std_logic;
				i_WE   : in std_logic;
				i_D    : in std_logic_vector(N-1 downto 0);
				o_Q    : out std_logic_vector(N-1 downto 0));
	end component;

	component ALU is
		port(	A			: in std_logic_vector(31 downto 0);
				B			: in std_logic_vector(31 downto 0);
				op	   		: in std_logic_vector(4 downto 0);
				Cout	 	: out std_logic;
				overflow 	: out std_logic;
				zero	 	: out std_logic;
				o_F	  		: out std_logic_vector(31 downto 0));
	end component;

	component imem is
		generic(depth_exp_of_2 	: integer := 10;
				mif_filename 	: string := "bubbleImem.mif");
		port(	address			: IN STD_LOGIC_VECTOR (depth_exp_of_2-1 DOWNTO 0) := (OTHERS => '0');
				clock			: IN STD_LOGIC := '1';
				q				: OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
	end component;

	component dmem is
	generic( depth	: integer := 10;
			mif_file : string := "bubbleDmem.mif");
	port( addr  	: in std_logic_vector(31 downto 0);
		data    	: in std_logic_vector(31 downto 0);
		we      	: in std_logic;
		clock1		: in std_logic := '1';
		lssigned	: in std_logic;
		op      	: in std_logic_vector(1 downto 0);
		dataout 	: out std_logic_vector(31 downto 0));
	end component;

	signal s0, s1, s2, s3, s4, s5, s6, s7, s8, s9 	: std_logic_vector(31 downto 0);
	signal s10, s11, s12, s13, s14, s15, s16, s17	: std_logic_vector(31 downto 0);
	signal s18, s19, s20, s21, s22, s23, s24, s25	: std_logic_vector(31 downto 0);
	signal s26, s27, s28, s29, s30, s31, s32, s33	: std_logic_vector(31 downto 0);
	signal s34, s35, s36, s37, s38, s39, s40, s41	: std_logic_vector(31 downto 0);
	signal s42, s43, s44, s45, s46, s47, s48, s49	: std_logic_vector(31 downto 0);
	signal s50, s51, s52, s53, s54, s55, s56, s57	: std_logic_vector(31 downto 0);
	signal s58, s59, s60, s61, s62, s63, s64, s65	: std_logic;

	signal sup : std_logic_vector(4 downto 0);
	signal regDst, jump, jr, branch, memWrite, regWrite, numOrZero	: std_logic;
	signal shiftlog, shiftdir, zero, lssigned, eqne, gtlt, link : std_logic;
	signal data2reg, ALUSrc, shiftSrc, lssize : std_logic_vector(1 downto 0);
	signal ALUOp : std_logic_vector(4 downto 0);
	signal garbage1 : std_logic;
	signal garbage32 : std_logic_vector(31 downto 0);
	signal in2ls1 : std_logic_vector(31 downto 0);
	signal intomux1, intomux2, intomux3, intomux4 : std_logic_vector(31 downto 0);

	begin
		
		




end BV;
