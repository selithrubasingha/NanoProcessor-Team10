---------------------------------------------------------------------------
-- rca_4bit.vhd
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rca_4bit is
    Port (
        A    : in  STD_LOGIC_VECTOR(3 downto 0);
        B    : in  STD_LOGIC_VECTOR(3 downto 0);
        Cin  : in  STD_LOGIC;
        Sum  : out STD_LOGIC_VECTOR(3 downto 0);
        Cout : out STD_LOGIC;
        C3   : out STD_LOGIC
    );
end rca_4bit;

architecture Structural of rca_4bit is


    component full_adder
        Port (
            A    : in  STD_LOGIC;
            B    : in  STD_LOGIC;
            Cin  : in  STD_LOGIC;
            Sum  : out STD_LOGIC;
            Cout : out STD_LOGIC
        );
    end component;


    signal C : STD_LOGIC_VECTOR(4 downto 0);

begin

    C(0) <= Cin;

    FA0 : full_adder
        port map (
            A    => A(0),
            B    => B(0),
            Cin  => C(0),
            Sum  => Sum(0),
            Cout => C(1)
        );

    FA1 : full_adder
        port map (
            A    => A(1),
            B    => B(1),
            Cin  => C(1),
            Sum  => Sum(1),
            Cout => C(2)
        );

    FA2 : full_adder
        port map (
            A    => A(2),
            B    => B(2),
            Cin  => C(2),
            Sum  => Sum(2),
            Cout => C(3)
        );

    FA3 : full_adder
        port map (
            A    => A(3),
            B    => B(3),
            Cin  => C(3),
            Sum  => Sum(3),
            Cout => C(4)
        );

    C3   <= C(3);
    Cout <= C(4);

end Structural;
