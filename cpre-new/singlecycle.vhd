library IEEE;
use IEEE.std_logic_1164.all;

entity singlecycle is
	port( PCCLK : in std_logic;
				CLK   : in std_logic;
				RESET : in std_logic);
end singlecycle;

architecture BV of singlecycle is

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
	generic( depth : integer := 10;
					mif_file : string := "bubbleDmem.mif");
  port( addr    : in std_logic_vector(31 downto 0);
        data    : in std_logic_vector(31 downto 0);
        we      : in std_logic;
        clock1  : in std_logic := '1';
        lssigned  : in std_logic;
        op      : in std_logic_vector(1 downto 0);
        dataout : out std_logic_vector(31 downto 0)); 
	end component;

	signal s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s13, s14, s15, s16, s19, s20, s21, s22, s29, s30, s31, s32 : std_logic_vector(31 downto 0);
	signal s23, s24, s25, s26, s27, s28 : std_logic;
	signal sup : std_logic_vector(4 downto 0);
	signal regDst, jump, jr, branch, memWrite, regWrite, link, numOrZero, eqne, gtlt, shiftlog, shiftdir, zero, lssigned : std_logic;
	signal data2reg, ALUSrc, shiftSrc, lssize : std_logic_vector(1 downto 0);
	signal ALUOp : std_logic_vector(4 downto 0);
	signal garbage1 : std_logic;
	signal garbage32 : std_logic_vector(31 downto 0);
	signal in2ls1 : std_logic_vector(31 downto 0);
	signal intomux1, intomux2, intomux3, intomux4 : std_logic_vector(31 downto 0);

	begin

		PC : Nbit_reg
			port MAP(	i_CLK => PCCLK,
						i_RST => RESET,
						i_WE  => '1',
						i_D   => s21,
						o_Q   => s1);

		instr : imem
			port MAP(	address => s1(11 downto 2),
						clock   => CLK,
						q       => s2);

		CONTROLLER : control
			port MAP( I 				=> s2,
								RegDst		=> regDst,
								Jump			=> jump,
								JR				=> jr,
								Branch		=> branch,
								Data2Reg	=> data2reg,
								ALUOp			=> ALUOp,
								MemWrite	=> memWrite,
								ALUSrc		=> ALUSrc,
								RegWrite	=> regWrite,
								Link			=> link,
								numOrZero	=> numOrZero,
								EQNE			=> eqne,
								GTLT			=> gtlt,
								shiftSrc	=> shiftSrc,
								shiftLog	=> shiftlog,
								shiftDir	=> shiftdir,
								LSSigned  => lssigned,
								LSSize		=> lssize);

		intomux1 <= "000000000000000000000000000" & s2(20 downto 16);
		intomux2 <= "000000000000000000000000000" & s2(15 downto 11);

		mux1 : mux21
			port MAP(	D0  => intomux1,
						D1  => intomux2,
						i_S => regDst,
						o_F => s3);

		intomux3 <= "000000000000000000000000000" & "11111";

		mux2 : mux21
			port MAP(	D0	=> s3,
						D1	=> intomux3,
						i_S => link,
						o_F => s4);

		mux3 : mux41
			port MAP(	D3	=> x"00000001",
						D2	=> x"00000000" ,
						D1	=> s5,
						D0	=> s7,
						i_S	=> ALUSrc,
						o_F	=> s30);

		s32 <= "000000000000000000000000000" & s5(11 downto 7);

		mux4 : mux41
			port MAP(	D3	=> x"00000000",
						D2	=> s7,
						D1	=> x"00000010",
						D0	=> s32,
						i_S	=> shiftSrc,
						o_F	=> s31);

		s24 <= not s23;

		mux5 : mux
			port MAP(	i_A	=> s23,
						i_B => s24,
						i_S => eqne,
						o_F => s25);

		s26 <= not s22(31);

		mux6 : mux
			port MAP(	i_A => s22(31),
						i_B => s26,
						i_S => gtlt,
						o_F => s27);

		mux7 : mux
			port MAP(	i_A => s25,
						i_B => s27,
						i_S => numOrZero,
						o_F => zero);

		mux8 : mux41
			port MAP(	D3	=> s9,
						D2	=> s8,
						D1	=> s10,
						D0	=> s22,
						i_S => data2Reg,
						o_F => s11);

		mux9 : mux21
			port MAP(	D1	=> s6,
						D0	=> s20,
						i_S => jr,
						o_F => s21);

		s28 <= zero and branch;

		mux10 : mux21
			port MAP(	D1 	=> s16,
						D0 	=> s13,
						i_S => s28,
						o_F => s19);

		mux11 : mux21
			port MAP(	D1 	=> s29,
						D0 	=> s19,
						i_S => jump,
						o_F => s20);

		registerFile : MIPS
			port MAP(	i_CLK 		=> CLK,
						read_rs 	=> s2(25 downto 21),
						read_rt 	=> s2(20 downto 16),
						write_data 	=> s11,
						write_addr 	=> s4(4 downto 0),
						write_en   	=> regWrite,
						reset	  	=> RESET,
						rs		 	=> s6,
						rt		 	=> s7);

		signextende : extender16
			port MAP(	i_A => s2(15 downto 0),
						i_C => '1',
						o_F => s5);

		mather : ALU
			port MAP(	A			=> s6,
						B			=> s30,
						op	   		=> ALUOp,
						Cout	 	=> garbage1,
						overflow 	=> garbage1,
						zero	 	=> s23,
						o_F	  		=> S22);

		multiplier : mult
			port MAP(	A 	=> s6,
						B 	=> s7,
						hi	=> garbage32,
						lo 	=> s8);

		varshift : shifter
			port MAP(	A	 	=> s6,
						shift 	=> s31(4 downto 0),
						logic 	=> shiftlog,
						C	 	=> shiftdir,
						F	 	=> s9);

		in2ls1 <= "000000" & s2(25 downto 0);

		ls1 : shifter
			port MAP(	A		=> in2ls1,
						shift	=> "00010",
						logic 	=> '0',
						C 		=> '1',
						F 		=> s14);

		s29 <= s13(31 downto 28) & s14(27 downto 0);

		ls2 : shifter
			port MAP(	A		=> s5,
						shift	=> "00010",
						logic 	=> '0',
						C 		=> '1',
						F 		=> s15);

		adder1 : ALU
			port MAP(	A			=> s1,
						B			=> x"00000004",
						op	   		=> "00010",
						Cout	 	=> garbage1,
						overflow 	=> garbage1,
						zero	 	=> garbage1,
						o_F	  		=> s13);

		adder2 : ALU
			port MAP(	A			=> s13,
						B			=> s15,
						op	   		=> "00010",
						Cout	 	=> garbage1,
						overflow 	=> garbage1,
						zero	 	=> garbage1,
						o_F	  		=> s16);

		memfile : dmem
		  port MAP( addr    => s22,
  			      data    => s7,
  			      we      => memWrite,
  			      clock1  => CLK,
  			      lssigned=> lssigned,
  			      op      => lssize,
  			      dataout => s10);

end BV;
