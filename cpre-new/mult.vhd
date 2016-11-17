library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity mult is
	port( A  : in std_logic_vector(31 downto 0);
	      B  : in std_logic_vector(31 downto 0);
	      lo : out std_logic_vector(31 downto 0);
	      hi : out std_logic_vector(31 downto 0));
end mult;


architecture BradenVenecia of mult is
  
  component BVadder is
		port( A : in std_logic_vector(31 downto 0);
					B : in std_logic_vector(31 downto 0);
					Set : out std_logic;
					F : out std_logic_vector(31 downto 0));
	end component;
  
  component ander is
    port( A : in std_logic_vector(31 downto 0);
          B : in std_logic;
          F : out std_logic_vector(31 downto 0));
  end component;
    
  signal s_A, s_B : std_logic_vector(31 downto 0);

  type results is array (31 downto 0) of std_logic_vector(31 downto 0);
  signal ands    : results;

	type results2 is array (30 downto 1) of std_logic_vector(31 downto 0);
  signal sums    : results2;

	signal f    : std_logic_vector(63 downto 0);
	signal s_f  : std_logic_vector(63 downto 0);
	signal first   : std_logic_vector(31 downto 0);

	begin

	comp_2a : process(A, B)
  begin 
		if (A(31) = '1') then
			s_A <= std_logic_vector(unsigned(not A) + 1);
		else
		  s_A <= A;
		end if;
		
		if (B(31) = '1') then
			s_B <= std_logic_vector(unsigned(not B) + 1);
		else
		  s_B <= B;
		end if;
	end process;
	
  GO0 : for i in 0 to 31 generate
    and_ALL : ander
      port MAP( A => s_A,
                B => s_B(i),
                F => ands(i));
  end generate;
	
	f(0) <= ands(0)(0);
	first(30 downto 0) <= ands(0)(31 downto 1);

	first(31) <= '0';
  riperoni : BVadder
    port MAP( A   => first,
              B   => ands(1),
              F   => sums(1),
              Set => f(1));
              

  GO1 : for i in 1 to 29 generate  
    rip : BVadder
      port MAP( A   => ands(i + 1),
                B   => sums(i),
                F   => sums(i + 1),
                Set => f(i + 1));
    end generate;

	riperoni2 : BVadder
		port MAP( A   => ands(31),
							B   => sums(30),
							F   => f(63 downto 32),
							Set => f(31));

	comp_2b : process(A, B, f)
	begin
    if( (A(31) xor B(31)) = '1' ) then
			s_f <= std_logic_vector( not unsigned(f) + 1);
		else
			s_f <= f;
		end if;
	end process;

	lo <= s_f(31 downto  0);
	hi <= s_f(63 downto 32);
	
end BradenVenecia;
	
