---------------------------------------------------------------------------
-- program_counter.vhd
-- 3-bit Program Counter (Component-based structural style)
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity program_counter is
    Port (
        NextAddr : in  STD_LOGIC_VECTOR(2 downto 0);
        Clk      : in  STD_LOGIC;
        Reset    : in  STD_LOGIC;
        CurrAddr : out STD_LOGIC_VECTOR(2 downto 0)
    );
end program_counter;

architecture Structural of program_counter is

    -- Component declaration for D Flip-Flop
    component d_flip_flop
        Port (
            D     : in  STD_LOGIC;
            Clk   : in  STD_LOGIC;
            Reset : in  STD_LOGIC;
            Enable    : in  STD_LOGIC;
            Q     : out STD_LOGIC
        );
    end component;

    constant ALWAYS_EN : STD_LOGIC := '1';

begin

    DFF0 : d_flip_flop
        port map (
            D     => NextAddr(0),
            Clk   => Clk,
            Reset => Reset,
            Enable    => ALWAYS_EN,
            Q     => CurrAddr(0)
        );

    DFF1 : d_flip_flop
        port map (
            D     => NextAddr(1),
            Clk   => Clk,
            Reset => Reset,
            Enable    => ALWAYS_EN,
            Q     => CurrAddr(1)
        );

    DFF2 : d_flip_flop
        port map (
            D     => NextAddr(2),
            Clk   => Clk,
            Reset => Reset,
            Enable    => ALWAYS_EN,
            Q     => CurrAddr(2)
        );

end Structural;
