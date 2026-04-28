
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_sub_4bit is
    Port (
        A        : in  STD_LOGIC_VECTOR(3 downto 0);
        B        : in  STD_LOGIC_VECTOR(3 downto 0);
        AddSub   : in  STD_LOGIC;   -- '0' = Add,  '1' = Subtract
        Result   : out STD_LOGIC_VECTOR(3 downto 0);
        Overflow : out STD_LOGIC;
        Zero     : out STD_LOGIC
    );
end add_sub_4bit;

architecture Structural of add_sub_4bit is

    signal B_mod  : STD_LOGIC_VECTOR(3 downto 0);  -- B possibly inverted
    signal Sum_s  : STD_LOGIC_VECTOR(3 downto 0);
    signal Cout_s : STD_LOGIC;
    signal C3_s   : STD_LOGIC;

begin
    -- Conditionally invert B bit-by-bit
    B_mod(0) <= B(0) XOR AddSub;
    B_mod(1) <= B(1) XOR AddSub;
    B_mod(2) <= B(2) XOR AddSub;
    B_mod(3) <= B(3) XOR AddSub;

    -- Instantiate the 4-bit RCA
    -- Cin = AddSub: when subtracting, Cin=1 completes two's-complement negation

    RCA : entity work.rca_4bit
        port map (
            A    => A,
            B    => B_mod,
            Cin  => AddSub,
            Sum  => Sum_s,
            Cout => Cout_s,
            C3   => C3_s
        );

    Result   <= Sum_s;
    Overflow <= Cout_s XOR C3_s;   -- signed overflow detection
    Zero     <= '1' when Sum_s = "0000" else '0';

end Structural;
