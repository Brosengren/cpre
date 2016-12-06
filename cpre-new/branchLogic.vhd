library IEEE;
use IEEE.std_logic_1164.all;

entity branchLogic is
	port(	rs			: in std_logic_vector(31 downto 0);
		 	rt			: in std_logic_vector(31 downto 0);
		 	EQNE		: in std_logic;
		 	LTGT		: in std_logic;
		 	numorzero	: in std_logic;
			zero		:out std_logic);
end branchLogic;

architecture BV of branchLogic is

	component ALU is
		port(	A			: in std_logic_vector(31 downto 0);
				B			: in std_logic_vector(31 downto 0);
				op	   		: in std_logic_vector(4 downto 0);
				Cout	 	: out std_logic;
				overflow 	: out std_logic;
				zero	 	: out std_logic;
				o_F	  		: out std_logic_vector(31 downto 0));
	end component;

	component mux is
		port( 	i_A : in std_logic;
				i_B : in std_logic;
				i_S : in std_logic;
				o_F : out std_logic);
	end component;

	signal s1, s2, s3, s4, s5, s6, s7, s8, s9 : std_logic;
	signal s10 : std_logic_vector(31 downto 0);

	begin

	mather_i_hardly_know_her : ALU
		port MAP(	A			=> rs,
					B			=> rt,
					op			=> "01010",
					overflow	=> s9,
					zero		=> s1,
					o_F			=> s10);

	s2 <= s10(31);

	s3 <= not(s1);
	mux1 : mux
		port MAP(	i_A	=> s3,
					i_B	=> s1,
					i_S	=> EQNE,
					o_F	=> s4);

	s5 <= not(s2);

	mux2 : mux
		port MAP(	i_A	=> s2,
					i_B	=> s5,
					i_S	=> LTGT,
					o_F	=> s6);

	mux3 : mux
		port MAP(	i_A	=> s6,
					i_B	=> s4,
					i_S	=> numorzero,
					o_F	=> zero);

end BV;