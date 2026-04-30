---------------------------------------------------------------------------
-- register_4bit.vhd
-- Layer 2 – Functional Unit
-- 4-bit parallel-load register built from four d_flip_flop instances.
-- All four flip-flops share the same Clk, Reset, and Enable signals.
-- When Enable='1' on the rising clock edge, all four bits latch D.
-- Asynchronous Reset clears all bits to '0'.
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_4bit is
    Port (
        D      : in  STD_LOGIC_VECTOR(3 downto 0);
        Clk    : in  STD_LOGIC;
        Reset  : in  STD_LOGIC;
        Enable : in  STD_LOGIC;
        Q      : out STD_LOGIC_VECTOR(3 downto 0)
    );
end register_4bit;

architecture Structural of register_4bit is
 component d_flip_flop
        Port (
            D     : in  STD_LOGIC;
            Clk   : in  STD_LOGIC;
            Reset : in  STD_LOGIC;
            Enable    : in  STD_LOGIC;
            Q     : out STD_LOGIC
        );
    end component;

begin

    DFF0 : d_flip_flop
        port map (
            D     => D(0),
            Clk   => Clk,
            Reset => Reset,
            Enable    => Enable,
            Q     => Q(0)
        );

    DFF1 : d_flip_flop
        port map (
            D     => D(1),
            Clk   => Clk,
            Reset => Reset,
            Enable    => Enable,
            Q     => Q(1)
        );

    DFF2 : d_flip_flop
        port map (
            D     => D(2),
            Clk   => Clk,
            Reset => Reset,
            Enable    => Enable,
            Q     => Q(2)
        );

    DFF3 : d_flip_flop
        port map (
            D     => D(3),
            Clk   => Clk,
            Reset => Reset,
            Enable    => Enable,
            Q     => Q(3)
        );

end Structural;
