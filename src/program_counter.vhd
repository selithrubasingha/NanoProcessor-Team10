---------------------------------------------------------------------------
-- program_counter.vhd
-- Layer 3 – Sub-System
-- 3-bit Program Counter.
-- On every rising clock edge it loads NextAddr into its internal register.
-- Asynchronous Reset clears the counter to "000" so the program restarts
-- from instruction 0 whenever the pushbutton is pressed.
--
-- NextAddr comes from the 2-way 3-bit mux in the top level:
--   JumpFlag='0'  ->  NextAddr = PCCurrentAddr + 1   (normal flow)
--   JumpFlag='1'  ->  NextAddr = JumpAddr             (taken JZR)
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity program_counter is
    Port (
        NextAddr    : in  STD_LOGIC_VECTOR(2 downto 0);
        Clk         : in  STD_LOGIC;
        Reset       : in  STD_LOGIC;
        CurrAddr    : out STD_LOGIC_VECTOR(2 downto 0)
    );
end program_counter;

architecture Structural of program_counter is

    -- The Enable pin of every flip-flop is tied high ('1') because the PC
    -- must always update on every rising edge (either PC+1 or jump address).
    constant ALWAYS_EN : STD_LOGIC := '1';

begin
    DFF0 : entity work.d_flip_flop
        port map (NextAddr(0), Clk, Reset, ALWAYS_EN, CurrAddr(0));
    DFF1 : entity work.d_flip_flop
        port map (NextAddr(1), Clk, Reset, ALWAYS_EN, CurrAddr(1));
    DFF2 : entity work.d_flip_flop
        port map (NextAddr(2), Clk, Reset, ALWAYS_EN, CurrAddr(2));

end Structural;
