--http://courses.cs.vt.edu/cs2506/Spring2013/Assignments/8/ForwardingUnit.pdf
--look here for info on forwarding unit


library IEEE;
use IEEE.std_logic_1164.all;

entity pipeline is
	port(	CLK		: in std_logic;
			RESET	: in std_logic);
end pipeline;

architecture BV of pipeline is

	component IF_Register2 is
		port( i_CLK		: in std_logic;
			i_RST		: in std_logic;
			i_WE		: in std_logic;

			i_instr		: in std_logic_vector(31 downto 0);
			i_PCplus4	: in std_logic_vector(31 downto 0);

			o_instr		: out std_logic_vector(31 downto 0);
			o_PCplus4	: out std_logic_vector(31 downto 0));
	end component;

	component ID_Register is
		port( i_CLK	 	: in std_logic;
			i_RST	 	: in std_logic;
			i_WE		: in std_logic;

		--	i_Branch	: in std_logic;
			i_RegDst	: in std_logic;
		--	i_Jump		: in std_logic;
		--	i_JR		: in std_logic; --jump register instruction
		--	i_EqNe		: in std_logic;
		--	i_LtGt		: in std_logic;
			i_LSSigned	: in std_logic;
			i_ALUOp		: in std_logic_vector(4 downto 0);
		--	i_PCplus4 	: in std_logic_vector(31 downto 0);
			i_Data2Reg	: in std_logic_vector(1 downto 0);
			i_MemWrite	: in std_logic;
		--	i_ALUSrc	: in std_logic_vector(1 downto 0);
			i_RegWrite	: in std_logic;
		--	i_Link		: in std_logic;
			i_ShiftSrc	: in std_logic_vector(1 downto 0);
		--	i_numorzero	: in std_logic;
			i_shiftLog	: in std_logic;
			i_shiftDir	: in std_logic;
			i_LSSize	: in std_logic_vector(1 downto 0);

			i_Rt_addr1	: in std_logic_vector(4 downto 0);
			i_Rs_addr 	: in std_logic_vector(4 downto 0);
			i_RegRead1	: in std_logic_vector(31 downto 0);
			i_RegRead2	: in std_logic_vector(31 downto 0);
			i_SEimm		: in std_logic_vector(31 downto 0);
			i_Rd_addr 	: in std_logic_vector(4 downto 0);
			i_Rt_addr2	: in std_logic_vector(4 downto 0);
			i_instr		: in std_logic_vector(31 downto 0);

		--	o_Branch	: out std_logic;
			o_RegDst	: out std_logic;
		--	o_Jump		: out std_logic;
		--	o_JR	 	: out std_logic; --jump register instruction
		--	o_EqNe		: out std_logic;
		--	o_LtGt		: out std_logic;
			o_LSSigned	: out std_logic;
			o_ALUOp		: out std_logic_vector(4 downto 0);

		--	o_PCplus4 	: out std_logic_vector(31 downto 0);
			o_Data2Reg	: out std_logic_vector(1 downto 0);
			o_MemWrite	: out std_logic;
		--	o_ALUSrc	: out std_logic_vector(1 downto 0);
			o_RegWrite	: out std_logic;
		--	o_Link		: out std_logic;
			o_ShiftSrc	: out std_logic_vector(1 downto 0);
		--	o_numorzero	: out std_logic;
			o_shiftLog	: out std_logic;
			o_shiftDir	: out std_logic;
			o_LSSize	: out std_logic_vector(1 downto 0);

			o_Rt_addr1	: out std_logic_vector(4 downto 0);
			o_Rs_addr	: out std_logic_vector(4 downto 0);
			o_RegRead1	: out std_logic_vector(31 downto 0);
			o_RegRead2	: out std_logic_vector(31 downto 0);
			o_SEimm		: out std_logic_vector(31 downto 0);
			o_Rd_addr 	: out std_logic_vector(4 downto 0);
			o_Rt_addr2	: out std_logic_vector(4 downto 0);
			o_instr		: out std_logic_vector(31 downto 0));
	end component;

	component EX_register is
		port(	CLK		: in std_logic;
				Reset	: in std_logic;

				memWrite 	: in std_logic;
				LSSigned	: in std_logic;
				LSSize		: in std_logic_vector(1 downto 0);
				Data2Reg  	: in std_logic_vector(1 downto 0);
				RegWrite  	: in std_logic;
				RdRt_addr	: in std_logic_vector(4 downto 0);
				Rt   		: in std_logic_vector(31 downto 0);
			  	Data 		: in std_logic_vector(31 downto 0);

				memWrite_o	: out std_logic;
				LSSigned_o	: out std_logic;
				LSSize_o 	: out std_logic_vector(1 downto 0);
				Data2Reg_o 	: out std_logic_vector(1 downto 0);
				RegWrite_o 	: out std_logic;
				RdRt_addr_o 	: out std_logic_vector(4 downto 0);
				Rt_o  		: out std_logic_vector(31 downto 0);
				Data_o 		: out std_logic_vector(31 downto 0)
			);
	end component;

	component MEM_register is
		port(	CLK			: in std_logic;
				Reset		: in std_logic;
				Data2Reg	: in std_logic_vector(1 downto 0);
				RegWrite	: in std_logic;
				MemOut		: in std_logic_vector(31 downto 0);
				RdRt		: in std_logic_vector(4 downto 0);
				AluOut		: in std_logic_vector(31 downto 0);
				Data2Reg_o	: out std_logic_vector(1 downto 0);
				RegWrite_o	: out std_logic;
				MemOut_o	: out std_logic_vector(31 downto 0);
				RdRt_o		: out std_logic_vector(4 downto 0);
				ALUOut_o	: out std_logic_vector(31 downto 0));
		end component;

	component mux is
		port( 	i_A : in std_logic;
				i_B : in std_logic;
				i_S : in std_logic;
				o_F : out std_logic);
		end component;

	component mux21 is
		generic(N 	: integer := 32);
		port(	D1	: in std_logic_vector(N-1 downto 0);
				D0 	: in std_logic_vector(N-1 downto 0);
				i_S : in std_logic;
				o_F : out std_logic_vector(N-1 downto 0));
	end component;

	--component mux31 is
	--	generic(N	: integer := 32);
	--	port(	D2 	: in std_logic_vector(N-1 downto 0);
	--			D1 	: in std_logic_vector(N-1 downto 0);
	--			D0	: in std_logic_vector(N-1 downto 0);
	--			i_S : in std_logic_vector(	1 downto 0);
	--			o_F : out std_logic_vector(N-1 downto 0));
	--end component;

	component mux41 is
		generic(N 	: integer := 32);
		port(	D3	: in std_logic_vector(N-1 downto 0);
				D2	: in std_logic_vector(N-1 downto 0);
				D1	: in std_logic_vector(N-1 downto 0);
				D0	: in std_logic_vector(N-1 downto 0);
				i_S : in std_logic_vector(1 downto 0);
				o_F : out std_logic_vector(N-1 downto 0));
	end component;

	component control is
		port( 	I 			: in std_logic_vector(31 downto 0);
			--	hazard		: in std_logic;
				RegDst		: out std_logic;
				Jump		: out std_logic;
				JR			: out std_logic;
				Branch		: out std_logic;
				MemRead		: out std_logic;
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
				LSSigned	: out std_logic;
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
		port( 	A	: in std_logic_vector(31 downto 0);
				B	: in std_logic_vector(31 downto 0);
				lo	: out std_logic_vector(31 downto 0);
				hi	: out std_logic_vector(31 downto 0));
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
		port( 	i_CLK		: in std_logic;
				read_rs		: in std_logic_vector(4 downto 0);
				read_rt		: in std_logic_vector(4 downto 0);
				write_data 	: in std_logic_vector(31 downto 0);
				write_addr 	: in std_logic_vector( 4 downto 0);
				write_en	: in std_logic;
				reset		: in std_logic;
				rs		 	: out std_logic_vector(31 downto 0);
				rt		 	: out std_logic_vector(31 downto 0));
	end component;

	component Nbit_reg is
		generic(N : integer := 32);
		port(	i_CLK	: in std_logic;
				i_RST	: in std_logic;
				i_WE	: in std_logic;
				i_D		: in std_logic_vector(N-1 downto 0);
				o_Q		: out std_logic_vector(N-1 downto 0));
	end component;

	component ALU is
		port(	A			: in std_logic_vector(31 downto 0);
				B			: in std_logic_vector(31 downto 0);
				op			: in std_logic_vector(4 downto 0);
				Cout		: out std_logic;
				overflow	: out std_logic;
				zero		: out std_logic;
				o_F			: out std_logic_vector(31 downto 0));
	end component;

	component imem is
		generic(depth_exp_of_2 	: integer := 10;
				mif_filename 	: string := "allinstImem.mif");
		port(	address			: IN STD_LOGIC_VECTOR (depth_exp_of_2-1 DOWNTO 0) := (OTHERS => '0');
				clock			: IN STD_LOGIC := '1';
				q				: OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
	end component;

	component dmem is
		generic(depth		: integer := 10;
				mif_file	: string := "Dmem.mif");
		port(	addr		: in std_logic_vector(31 downto 0);
				data		: in std_logic_vector(31 downto 0);
				we			: in std_logic;
				clock1		: in std_logic := '1';
				lssigned	: in std_logic;
				op			: in std_logic_vector(1 downto 0);
				dataout		: out std_logic_vector(31 downto 0));
	end component;

	component branchLogic is
		port(	rs			: in std_logic_vector(31 downto 0);
				rt			: in std_logic_vector(31 downto 0);
				EQNE		: in std_logic;
				LTGT		: in std_logic;
				numorzero	: in std_logic;
				zero		: out std_logic);
	end component;

	component forwardingunit is
		port(	ID_Rs			: in std_logic_vector(4 downto 0);
				ID_Rt			: in std_logic_vector(4 downto 0);
				MEM_RegWrite		: in std_logic;
				EX_Rd			: in std_logic_vector(4 downto 0);
				WB_RegWrite	: in std_logic;
				MEM_Rd			: in std_logic_vector(4 downto 0);
				ForwardA		: out std_logic_vector(1 downto 0);  --control for first input to ALU
				ForwardB		: out std_logic_vector(1 downto 0)); --control for second input to ALU
	end component;

	component hazarddetection is
		port(	CLK					: in std_logic;
				IF_Rs				: in std_logic_vector(4 downto 0);
				IF_Rt				: in std_logic_vector(4 downto 0);
				ID_MemRead			: in std_logic;
				ID_Rt				: in std_logic_vector(4 downto 0);
				Branch				: in std_logic;
				Jump				: in std_logic;
				LoadUse_Hazard		: out std_logic;
				BranchJump_Hazard	: out std_logic);
	end component;

	signal s1, s2, s3, s4, s5, s6, s7, s8, s9 	: std_logic_vector(31 downto 0);
	signal s10, s11, s12, s17	: std_logic_vector(31 downto 0);
	signal s18, s20, s21, s22, s23, s24	: std_logic_vector(31 downto 0);
	signal s26, s27, s28, s29, s30, s32, s33	: std_logic_vector(31 downto 0);
	signal s37, s38, s39, s40, s41		: std_logic_vector(31 downto 0);
	signal s42, s43, s44, s45, s46, s47, s48, s49	: std_logic_vector(31 downto 0);
	signal s50, s51 : std_logic_vector(31 downto 0);
--	signal s52, s53, s54, s55, s56, s57	
--	signal s58, s59, s60, s61, s62, s63, s64, s65	: std_logic;

	signal s13, s14, s15, s16, s19, s25, s31 : std_logic_vector(4 downto 0);
	signal s35, s36 : std_logic_vector(1 downto 0);
--	signal s34 : std_logic;

	signal luhazard_flag : std_logic;
	signal brjhazard_flag : std_logic;
	signal LU_WE : std_logic;

--	signal sup : std_logic_vector(4 downto 0);
	signal regDst, jump, jr, branch, memWrite, regWrite, numOrZero, datLogicDoh	: std_logic;
	signal shiftlog, shiftdir, zero, lssigned, eqne, gtlt, link, memread : std_logic;
	signal data2reg, ALUSrc, shiftSrc, lssize : std_logic_vector(1 downto 0);
	signal ALUOp : std_logic_vector(4 downto 0);
	signal garbage1 : std_logic;
	signal garbage32 : std_logic_vector(31 downto 0);
	signal in2ls1 : std_logic_vector(31 downto 0);
--signal intomux1, intomux2, intomux3, intomux4 : std_logic_vector(31 downto 0);

	signal ex_regwrite, mem_regwrite, wb_regwrite, ex_shiftlog, ex_shiftdir : std_logic;
	signal ex_shiftSrc : std_logic_vector(1 downto 0);
	signal ex_data2reg : std_logic_vector(1 downto 0);
	signal mem_data2reg : std_logic_vector(1 downto 0);
	signal wb_data2reg : std_logic_vector(1 downto 0);
	signal ex_memwrite, mem_memwrite, ex_lssigned, mem_lssigned, ex_regdst : std_logic;
	signal ex_lssize, mem_lssize : std_logic_vector(1 downto 0);
	signal ex_aluop : std_logic_vector(4 downto 0);




	begin

		LU_WE <= not luhazard_flag;

		PC : Nbit_reg
			port MAP(	i_CLK	=> CLK,
						i_RST	=> RESET,
						i_WE	=> LU_WE,
						i_D		=> s32,
						o_Q		=> s1);

		adder1 : ALU
			port MAP(	A			=> s1,
						B			=> x"00000004",
						op			=> "00010",
						Cout		=> garbage1,
						overflow	=> garbage1,
						zero		=> garbage1,
						o_F			=> s3);

		instr : imem
			port MAP(	address	=> s1(11 downto 2),
						clock	=> CLK,
						q		=> s2);

		datLogicDoh <= (branch and zero) or jump or jr;

		mux1 : mux21
			port MAP(	D0		=> s3,
						D1		=> s10,
						i_S		=> datLogicDoh,
						o_F		=> s32);

		ifid_reg : IF_Register2
			port MAP(	i_CLK		=> CLK,
						i_RST		=> brjhazard_flag,
						i_WE		=> LU_WE,

						i_instr		=> s2,
						i_PCplus4	=> s3,

						o_instr		=> s4,
						o_PCplus4	=> s5);

		CONTROLLER : control
			port MAP(	I 			=> s4,
					--	hazard		=> RESET,
						RegDst		=> regDst,
						Jump		=> jump,
						JR			=> jr,
						Branch		=> branch,
						MemRead		=> MemRead,
						Data2Reg	=> data2reg,
						ALUOp		=> ALUOp,
						MemWrite	=> memWrite,
						ALUSrc		=> ALUSrc,
						RegWrite	=> regWrite,
						Link		=> link,
						numOrZero	=> numOrZero,
						EQNE		=> eqne,
						GTLT		=> gtlt,
						shiftSrc	=> shiftSrc,
						shiftLog	=> shiftlog,
						shiftDir	=> shiftdir,
						LSSigned	=> lssigned,
						LSSize		=> lssize);

		signextende : extender16
			port MAP(	i_A	=> s4(15 downto 0),
						i_C	=> '1',
						o_F	=> s6);

		s48 <= "000000000000000000000000000" & s31;

		mux10 : mux21
			port MAP(	D1  => x"0000001F",
						D0  => s48,
						i_S => link,
						o_F => s47);

		mux11 : mux21
			port MAP(	D1  => s5,
						D0  => s29,
						i_S => link,
						o_F => s46);


		registerFile : MIPS
			port MAP(	i_CLK		=> CLK,
						read_rs		=> s4(25 downto 21),
						read_rt		=> s4(20 downto 16),
						write_data	=> s46,
						write_addr	=> s47(4 downto 0),
						write_en	=> regWrite,
						reset		=> RESET,
						rs			=> s9,
						rt			=> s8);

		mux2 : mux21
			port MAP(	D0	=> s8,
						D1	=> s6,
						i_S => ALUSrc(0),
						o_F => s33);

		are_these_equal : branchLogic
			port MAP(	rs			=> s9,
						rt			=> s8,
						EQNE		=> eqne,
						LTGT		=> gtlt,
						numorzero	=> numOrZero,
						zero		=> zero);

		in2ls1 <= "000000" & s4(25 downto 0);

		ls1 : shifter
			port MAP(	A		=> in2ls1,
						shift	=> "00010",
						logic	=> '0',
						C		=> '0',
						F		=> s42);

		s43 <= s5(31 downto 28) & s42(27 downto 0);

		ls2 : shifter
			port MAP(	A		=> s6,
						shift	=> "00010",
						logic	=> '0',
						C		=> '0',
						F		=> s7);

		adder2 : ALU
			port MAP(	A			=> s5,
						B			=> s7,
						op			=> "00010",
						Cout		=> garbage1,
						overflow	=> garbage1,
						zero		=> garbage1,
						o_F			=> s10);

		mux12 : mux21
			port MAP(	D1  => s43,
						D0  => s10,
						i_S => jump,
						o_F => s44);

		mux13 : mux21
			port MAP(	D1  => s9,
						D0  => s44,
						i_S => jr,
						o_F => s45);

		idex_reg : ID_Register
			port MAP(	i_CLK		=> CLK,
						i_RST		=> RESET,
						i_WE		=> '1',

				--		i_Branch	=>
						i_RegDst	=> regDst,
				--		i_Jump		=>
				--		i_JR		=>
				--		i_EqNe		=>
				--		i_LtGt		=>
						i_LSSigned	=> lssigned,
						i_ALUOp		=> ALUOp,

				--		i_PCplus4	=> s5,
						i_Data2Reg	=> data2reg,
						i_MemWrite	=> memWrite,
				--		i_ALUSrc	=>
						i_RegWrite	=> regWrite,
				--		i_Link		=>
						i_ShiftSrc	=> shiftSrc,
				--		i_numorzero	=>
						i_shiftLog	=> shiftlog,
						i_shiftDir	=> shiftdir,
						i_LSSize	=> lssize,

						i_Rt_addr1	=> s4(20 downto 16),
						i_Rs_addr	=> s4(25 downto 21),
						i_SEimm		=> s6,
						i_RegRead1	=> s9,
						i_RegRead2	=> s33,
						i_Rd_addr	=> s4(15 downto 11),
						i_Rt_addr2	=> s4(20 downto 16),
						i_instr		=> s4, --i dont think this is needed

				--		o_Branch	=>
						o_RegDst	=> ex_regdst,
				--		o_Jump		=>
				--		o_JR		=>
				--		o_EqNe		=>
				--		o_LtGt		=>
						o_LSSigned	=> ex_lssigned,
						o_ALUOp		=> ex_aluop,

				--		o_PCplus4	=>
						o_Data2Reg	=> ex_data2reg,
						o_MemWrite	=> ex_memwrite,
				--		o_ALUSrc	=>
						o_RegWrite	=> ex_regwrite,
				--		o_Link		=>
						o_ShiftSrc	=> ex_shiftSrc,
				--		o_numorzero	=>
						o_shiftLog	=> ex_shiftlog,
						o_shiftDir	=> ex_shiftdir,
						o_LSSize	=> ex_lssize,

						o_Rt_addr1	=> s14,
						o_Rs_addr	=> s13,
						o_SEimm		=> s38,
						o_RegRead1	=> s11,
						o_RegRead2	=> s12,
						o_Rd_addr	=> s16,
						o_Rt_addr2	=> s15,
						o_instr		=> s37);

		mux3 : mux41
			port MAP(	D3	=> s24,
						D2	=> s29,
						D1	=> x"00000000",
						D0	=> s11,
						i_S	=> s36,
						o_F	=> s17);

		mux4 : mux41
			port MAP(	D3	=> s24,
						D2	=> s29,
						D1	=> x"00000000",
						D0	=> s12,
						i_S	=> s35,
						o_F	=> s18);

		s49 <= "000000000000000000000000000" & s15;
		s50 <= "000000000000000000000000000" & s16;

		mux5 : mux21
			port MAP(	D0	=> s49,
						D1	=> s50,
						i_S	=> ex_regdst,
						o_F	=> s51);

		s19 <= s51(4 downto 0);

		mather : ALU
			port MAP(	A			=> s17,
						B			=> s18,
						op			=> ex_aluop,
						Cout		=> garbage1,
						overflow	=> garbage1,
						zero		=> garbage1,
						o_F			=> S22);

		multiplier : mult
			port MAP(	A	=> s17,
						B	=> s18,
						hi	=> garbage32,
						lo	=> s21);

		s41 <= "000000000000000000000000000" & s37(11 downto 7);

		mux9 : mux41
			port MAP(	D3	=> x"00000000",
						D2	=> s17,
						D1	=> x"00000010",
						D0	=> s41,
						i_S	=> ex_shiftSrc,
						o_F	=> s40);

		mux8: mux21
			port MAP(	D1	=> s38,
						D0	=> s18,
						i_S	=> ex_shiftSrc(0),
						o_F	=> s39);

		varshift : shifter
			port MAP(	A		=> s39,
						shift	=> s40(4 downto 0),
						logic	=> ex_shiftlog,
						C		=> ex_shiftdir,
						F		=> s20);

		mux6 : mux41
			port MAP(	D3	=> s20,
						D2	=> s21,
						D1	=> x"00000000",
						D0	=> s22,
						i_S	=> data2Reg,
						o_F	=> s23);

		exmem_reg : EX_register
			port MAP(	CLK			=> CLK,
						Reset		=> RESET,

						memWrite	=> ex_memwrite,
						LSSigned	=> ex_lssigned,
						LSSize		=> ex_lssize,
						Data2Reg	=> ex_data2reg,
						RegWrite	=> ex_regwrite,
						RdRt_addr	=> s19,
						Rt			=> s12,
						Data		=> s23,
						memWrite_o	=> mem_memwrite,
						LSSigned_o	=> mem_lssigned,
						LSSize_o	=> mem_lssize,
						Data2Reg_o	=> mem_data2reg,
						RegWrite_o	=> mem_regwrite,
						RdRt_addr_o	=> s25,
						Rt_o		=> s30,
						Data_o		=> s24);

		memfile : dmem
			port MAP(	addr		=> s24,
						data		=> s30,
						we			=> memWrite,
						clock1		=> CLK,
						lssigned	=> lssigned,
						op			=> lssize,
						dataout		=> s26);

		memwb_reg : MEM_register
			port MAP(	CLK			=> CLK,
						Reset		=> RESET,
						Data2Reg	=> mem_data2reg,
						RegWrite	=> mem_regwrite,
						MemOut		=> s26,
						RdRt		=> s25,
						AluOut		=> s24,
						Data2Reg_o	=> wb_data2reg,
						RegWrite_o	=> wb_regwrite,
						MemOut_o	=> s27,
						RdRt_o		=> s31,
						ALUOut_o	=> s28);

		mux7 : mux41
			port MAP(	D3	=> s28,
						D2	=> s28,
						D1	=> s27,
						D0	=> s28,
						i_S => data2Reg,
						o_F => s29);

		fu : forwardingunit
			port MAP(	ID_Rs			=> s13,
						ID_Rt			=> s14,
						MEM_RegWrite	=> mem_regwrite,
						EX_Rd			=> s25,
						WB_RegWrite	=> wb_regwrite,
						MEM_Rd			=> s31,
						ForwardA		=> s36,
						ForwardB		=> s35);

		hazard : hazarddetection
			port MAP(	CLK					=> CLK,
						IF_Rs				=> s4(25 downto 21),
						IF_Rt				=> s4(20 downto 16),
						ID_MemRead			=> memread,
						ID_Rt				=> s15,
						Branch				=> branch,
						Jump				=> jump,
						LoadUse_Hazard		=> luhazard_flag,
						BranchJump_Hazard	=> brjhazard_flag);



end BV;
