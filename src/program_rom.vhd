---------------------------------------------------------------------------
-- program_rom.vhd
-- Layer 3 – Sub-System
-- 8-location × 12-bit Program ROM (combinational LUT).
-- Hardcoded with the Assembly program for Step 4:
--   Calculate the sum of all integers between 1 and 3 (1+2+3 = 6).
--   Final result stored in R7.
--
-- -----------------------------------------------------------------------
-- ASSEMBLY PROGRAM  (using only MOVI, ADD, NEG, JZR)
-- -----------------------------------------------------------------------
--  We compute  R7 = 1 + 2 + 3  using a counting loop:
--
--  Strategy:
--    R1 = accumulator (result)
--    R2 = current number to add (counts 1 -> 2 -> 3)
--    R3 = -1  (decrement step for the counter R2)
--    R5 = loop limit check register (we compare R2 to 0 by subbing until 0)
--    Since we cannot easily compare R2 to a value, we instead:
--      add R2 to R1 three explicit times, then copy to R7.
--
--  Simplest correct approach for a 4-bit / 3-bit PC processor:
--
--  Line 0:  MOVI R1, 1      ; R1 = 1  (first addend)
--  Line 1:  MOVI R2, 2      ; R2 = 2  (second addend)
--  Line 2:  MOVI R3, 3      ; R3 = 3  (third addend)
--  Line 3:  ADD  R1, R2     ; R1 = R1 + R2  = 1+2 = 3
--  Line 4:  ADD  R1, R3     ; R1 = R1 + R3  = 3+3 = 6
--  Line 5:  ADD  R7, R1     ; R7 = R7(0) + R1 = 0+6 = 6  (store result)
--  Line 6:  JZR  R0, 6      ; R0 is always 0 -> infinite loop (halt here)
--  Line 7:  JZR  R0, 6      ; (safety padding, should never execute)
--
--  Result: R7 = 6 = "0110"  displayed on LD3-LD0.
--
-- -----------------------------------------------------------------------
-- INSTRUCTION ENCODING  (refer to instruction_decoder.vhd header)
-- -----------------------------------------------------------------------
--  MOVI R, d  : 10 RRR 000 dddd
--  ADD Ra, Rb : 00 RaRaRa RbRbRb 0000
--  NEG R      : 01 RRR 000 0000
--  JZR R, d   : 11 RRR 0000 ddd
-- -----------------------------------------------------------------------
--  Line 0: MOVI R1, 1  -> 10 001 000 0001  = 10_0010_0000_01 (12 bits)
--           bit11..10=10, bits9..7=001, bits6..4=000, bits3..0=0001
--           = "100010000001"
--
--  Line 1: MOVI R2, 2  -> 10 010 000 0010
--           = "100100000010"
--
--  Line 2: MOVI R3, 3  -> 10 011 000 0011
--           = "100110000011"
--
--  Line 3: ADD R1, R2  -> 00 001 010 0000
--           Ra=001, Rb=010
--           = "000010100000"
--
--  Line 4: ADD R1, R3  -> 00 001 011 0000
--           Ra=001, Rb=011
--           = "000010110000"
--
--  Line 5: ADD R7, R1  -> 00 111 001 0000
--           Ra=111, Rb=001
--           = "001110010000"
--
--  Line 6: JZR R0, 6   -> 11 000 0000 110
--           R=000, d=110 (address 6)
--           = "110000000110"
--
--  Line 7: JZR R0, 6   -> 11 000 0000 110
--           = "110000000110"  (same, safety padding)
-- -----------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity program_rom is
    Port (
        Addr        : in  STD_LOGIC_VECTOR(2 downto 0);
        Instruction : out STD_LOGIC_VECTOR(11 downto 0)
    );
end program_rom;

architecture Behavioral of program_rom is
begin
    process(Addr)
    begin
        case Addr is
            -- Line 0: MOVI R1, 1
            when "000" => Instruction <= "100010000001";

            -- Line 1: MOVI R2, 2
            when "001" => Instruction <= "100100000010";

            -- Line 2: MOVI R3, 3
            when "010" => Instruction <= "100110000011";

            -- Line 3: ADD R1, R2  -> R1 = 1+2 = 3
            when "011" => Instruction <= "000010100000";

            -- Line 4: ADD R1, R3  -> R1 = 3+3 = 6
            when "100" => Instruction <= "000010110000";

            -- Line 5: ADD R7, R1  -> R7 = 0+6 = 6  (store result)
            when "101" => Instruction <= "001110010000";

            -- Line 6: JZR R0, 6  -> R0=0, always jump to address 6 (halt)
            when "110" => Instruction <= "110000000110";

            -- Line 7: Safety padding
            when "111" => Instruction <= "110000000110";

            when others => Instruction <= (others => '0');
        end case;
    end process;
end Behavioral;
