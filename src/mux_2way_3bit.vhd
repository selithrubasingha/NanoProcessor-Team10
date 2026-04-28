---------------------------------------------------------------------------
-- mux_2way_3bit.vhd
--Layer 2 – Functional Unit
-- 2-to-1 multiplexer, 3 bits wide.
--
-- Role in the nanoprocessor:
--   Selects the NEXT Program Counter value:
--     Sel = '0'  ->  Y = A = PCPlusOne   (normal sequential execution)
--     Sel = '1'  ->  Y = B = JumpAddr    (taken branch from JZR)
--   Sel is driven by JumpFlag from the instruction decoder.
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2way_3bit is
    Port (
        A   : in  STD_LOGIC_VECTOR(2 downto 0);   -- PC + 1
        B   : in  STD_LOGIC_VECTOR(2 downto 0);   -- jump target address
        Sel : in  STD_LOGIC;                       -- 0=A, 1=B
        Y   : out STD_LOGIC_VECTOR(2 downto 0)
    );
end mux_2way_3bit;

architecture Behavioral of mux_2way_3bit is
begin
    Y <= B when Sel = '1' else A;
end Behavioral;
