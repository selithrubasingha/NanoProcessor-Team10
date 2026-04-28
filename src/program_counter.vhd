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
    
    component D_FF
        port (
            D     : in  std_logic;
            Res   : in  std_logic;
            Clk   : in  std_logic;
            Q     : out std_logic;
            Qbar  : out std_logic
        );
    end component;

begin

    DFF0 : D_FF
        port map (
            NextAddr(0),
            Reset,
            Clk,
            CurrAddr(0),
            open
        );

    DFF1 : D_FF
        port map (
            NextAddr(1),
            Reset,
            Clk,
            CurrAddr(1),
            open
        );

    DFF2 : D_FF
        port map (
            NextAddr(2),
            Reset,
            Clk,
            CurrAddr(2),
            open
        );

end Structural;
