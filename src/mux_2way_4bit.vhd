---------------------------------------------------------------------------
-- mux_2way_4bit.vhd
-- Layer 2 – Functional Unit
-- 2-to-1 multiplexer, 4 bits wide.
--
-- Role in the nanoprocessor (the "Immediate Value Mux"):
--   Sits between the ALU output and the Data Bus feeding the register bank.
--     Sel = '0'  ->  Y = A = ALU Result  (used by ADD and NEG)
--     Sel = '1'  ->  Y = B = Immediate   (used by MOVI; bypasses the ALU)
--   Sel is driven by ImmMuxSel from the instruction decoder.
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4bit_8way is
    Port (
        A   : in  STD_LOGIC_VECTOR(3 downto 0);   -- ALU result
        B   : in  STD_LOGIC_VECTOR(3 downto 0);   -- immediate value
        Sel : in  STD_LOGIC;                       -- 0=A(ALU), 1=B(Imm)
        Y   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end mux_2way_4bit;

architecture Behavioral of mux_4bit_8way is
begin
    Y <= B when Sel = '1' else A;
end Behavioral;
