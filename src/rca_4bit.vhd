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
        Cout : out STD_LOGIC;   -- carry out of bit 3 (MSB)
        C3   : out STD_LOGIC    -- carry into bit 3; used for overflow detection
    );
end rca_4bit;

architecture Structural of rca_4bit is

    -- Internal carry chain: C(0)=Cin, C(1..4) are inter-stage carries
    signal C : STD_LOGIC_VECTOR(4 downto 0);

begin
    C(0) <= Cin;

    FA0 : entity work.full_adder port map (A(0), B(0), C(0), Sum(0), C(1));
    FA1 : entity work.full_adder port map (A(1), B(1), C(1), Sum(1), C(2));
    FA2 : entity work.full_adder port map (A(2), B(2), C(2), Sum(2), C(3));
    FA3 : entity work.full_adder port map (A(3), B(3), C(3), Sum(3), C(4));

    C3   <= C(3);   -- carry INTO the MSB full adder
    Cout <= C(4);   -- carry OUT  of  the MSB full adder

end Structural;