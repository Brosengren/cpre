library IEEE;
use IEEE.std_logic_1164.all;

entity pipeline is
	port( CLK	: in std_logic);
end pipeline;

architecture BV of pipeline is

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

	signal s0, s1, s2, s3, s4, s5, s6, s7, s8, s9 	: std_logic;
	signal s10, s11, s12, s13, s14, s15, s16, s17	: std_logic;
	signal s18, s19, s20, s21, s22, s23, s24, s25	: std_logic_vector(31 downto 0);
	signal s26, s27, s28, s29, s30, s31, s32, s33	: std_logic_vector(31 downto 0);
	signal s33, s34, s35, s36, s37, s38, s39, s40	: std_logic_vector(31 downto 0);
	signal s41, s42, s43, s44, s45, s46, s47, s48	: std_logic_vector(31 downto 0);
	signal s49, s50, s51, s52, s53, s54, s55, s56	: std_logic_vector(31 downto 0);
	signal sup : std_logic_vector(4 downto 0);
	signal regDst, jump, jr, branch, memWrite, regWrite, link, numOrZero, eqne, gtlt, shiftlog, shiftdir, zero, lssigned : std_logic;
	signal data2reg, ALUSrc, shiftSrc, lssize : std_logic_vector(1 downto 0);
	signal ALUOp : std_logic_vector(4 downto 0);
	signal garbage1 : std_logic;
	signal garbage32 : std_logic_vector(31 downto 0);
	signal in2ls1 : std_logic_vector(31 downto 0);
	signal intomux1, intomux2, intomux3, intomux4 : std_logic_vector(31 downto 0);







end BV;