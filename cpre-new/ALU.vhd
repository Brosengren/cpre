library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.all;

entity ALU is
  port( A             : in std_logic_vector(31 downto 0);
        B             : in std_logic_vector(31 downto 0);
        op            : in std_logic_vector(4 downto 0);
        Cout          : out std_logic;
        overflow      : out std_logic;
        zero          : out std_logic;
        o_F           : out std_logic_vector(31 downto 0));
end ALU;
  

architecture BradenVenecia of ALU is
  
 component ALU1 is
     port( i_A, i_B      : in std_logic;
           a_inv, b_inv  : in std_logic;
           op            : in std_logic_vector(2 downto 0);
           less          : in std_logic;
           Cin           : in std_logic;
           set           : out std_logic;
           overflow      : out std_logic;
           Cout          : out std_logic;
           o_F           : out std_logic);
  end component;
  
  signal s_C       : std_logic_vector(32 downto 1);    
  signal s_S       : std_logic_vector(30 downto 0);
  signal s_O       : std_logic_vector(31 downto 0);
  signal les       : std_logic;
  signal s_Cin     : std_logic;
  signal F         : std_logic_vector(31 downto 0);
  signal z         : std_logic;
  signal an, bn    : std_logic;
  signal oper      : std_logic_vector(2 downto 0);
  
  begin
    
    z      <= '0';
    an     <= op(4);
    bn     <= op(3);
    oper   <= op(2 downto 0);
    
    
    with op select
      s_Cin <= '1' when "01010",
               '1' when "01011",
               '0' when others;
    

    ALU0 : ALU1
      port MAP( i_A      => A(0),
                i_B      => B(0),
                a_inv    => an,
                b_inv    => bn,
                op       => oper,
                less     => les,
                Cin      => s_Cin,
                set      => s_S(0),
                overflow => s_O(0),
                Cout     => s_C(1),
                o_F      => F(0));
    
    PIKACHU_I_CHOOSE_YOU : for i in 1 to 30 generate
      ALUi : ALU1
        port MAP( i_A      => A(i),
                  i_B      => B(i),
                  a_inv    => an,
                  b_inv    => bn,
                  op       => oper,
                  less     => '0',
                  Cin      => s_C(i),
                  set      => s_S(i),
                  overflow => s_O(i),
                  Cout     => s_C(i+1),
                  o_F      => F(i));
    end generate;
    
    ALU31 : ALU1
      port MAP( i_A      => A(31),
                i_B      => B(31),
                a_inv    => an,
                b_inv    => bn,
                op       => oper,
                less     => '0',
                Cin      => s_C(31),
                set      => les,
                overflow => s_O(31),
                Cout     => s_C(32),
                o_F      => F(31));

--    z <= F(0)  or F(1)  or F(2)  or F(3)  or F(4)  or F(5)  or F(6)  or F(7)  or F(8)  or F(9)  
--      or F(10) or F(11) or F(12) or F(13) or F(14) or F(15) or F(16) or F(17) or F(18) or F(19) 
--      or F(20) or F(21) or F(22) or F(23) or F(24) or F(25) or F(26) or F(27) or F(28) or F(29) 
--      or F(30) or F(31);

--    z <= z or F(0);
--    z <= z or F(1);
--    z <= z or F(2);
--    z <= z or F(3);
--    z <= z or F(4);
--    z <= z or F(5);
--    z <= z or F(6);
--    z <= z or F(7);
--    z <= z or F(8);
--    z <= z or F(9);
--    z <= z or F(10);
--    z <= z or F(11);
--    z <= z or F(12);
--    z <= z or F(13);
--    z <= z or F(14);
--    z <= z or F(15);
--    z <= z or F(16);
--    z <= z or F(17);
--    z <= z or F(18);
--    z <= z or F(19);
--    z <= z or F(20);
--    z <= z or F(21);
--    z <= z or F(22);
--    z <= z or F(23);
--    z <= z or F(24);
--    z <= z or F(25);
--    z <= z or F(26);
--    z <= z or F(27);
--    z <= z or F(28);
--    z <= z or F(29);
--    z <= z or F(30);
--    z <= z or F(31);
  


    zero     <= not (or_reduce(F));
    o_F      <= F;
    Cout     <= s_C(32);

    with op select
    overflow <=   s_C(32) when "00101",
		  s_C(32) when "01101",
         	  s_O(31) when others;


end BradenVenecia;
