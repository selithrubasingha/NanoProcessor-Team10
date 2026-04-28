---------------------------------------------------------------------------
-- register_bank.vhd
-- Layer 3 – Sub-System
-- 8 × 4-bit register file (R0 – R7).
--
-- Internals:
--   • A decoder_3to8 converts RegSel (3-bit) into a one-hot enable vector.
--   • Each decoded enable is AND-gated with the master RegEn signal.
--   • R1–R7 are register_4bit instances sharing the same Data Bus, Clk, Reset.
--   • R0 is SPECIAL: its output is hardwired to "0000" permanently.
--     EnableVec(0) is always '0', so R0 can never be written.
--     This design decision allows NEG and JZR to use R0 as a
--     guaranteed zero source without a dedicated ZERO register.
--
-- Ports:
--   D(3:0)      – data to write (from Data Bus in top level)
--   RegSel(2:0) – which register to write (from instruction decoder)
--   RegEn       – master write enable  ('0' disables all writes, e.g. JZR)
--   Clk, Reset  – shared clock and active-high asynchronous reset
--   R0..R7      – individual 4-bit register outputs (always readable)
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_bank is
    Port (
        D      : in  STD_LOGIC_VECTOR(3 downto 0);
        RegSel : in  STD_LOGIC_VECTOR(2 downto 0);
        RegEn  : in  STD_LOGIC;
        Clk    : in  STD_LOGIC;
        Reset  : in  STD_LOGIC;
        R0     : out STD_LOGIC_VECTOR(3 downto 0);
        R1     : out STD_LOGIC_VECTOR(3 downto 0);
        R2     : out STD_LOGIC_VECTOR(3 downto 0);
        R3     : out STD_LOGIC_VECTOR(3 downto 0);
        R4     : out STD_LOGIC_VECTOR(3 downto 0);
        R5     : out STD_LOGIC_VECTOR(3 downto 0);
        R6     : out STD_LOGIC_VECTOR(3 downto 0);
        R7     : out STD_LOGIC_VECTOR(3 downto 0)
    );
end register_bank;

architecture Structural of register_bank is

    signal DecoderOut : STD_LOGIC_VECTOR(7 downto 0);
    signal EnableVec  : STD_LOGIC_VECTOR(7 downto 0);

begin
    -- ----------------------------------------------------------------
    -- 3-to-8 decoder: converts RegSel to one-hot
    -- ----------------------------------------------------------------
    DEC : entity work.decoder_3to8
        port map (
            A => RegSel,
            Y => DecoderOut
        );

    -- ----------------------------------------------------------------
    -- Gate each decoded output with the master RegEn signal.
    -- EnableVec(0) is permanently '0' so R0 can never be written.
    -- ----------------------------------------------------------------
    EnableVec(0) <= '0';                          -- R0: read-only
    EnableVec(1) <= DecoderOut(1) AND RegEn;
    EnableVec(2) <= DecoderOut(2) AND RegEn;
    EnableVec(3) <= DecoderOut(3) AND RegEn;
    EnableVec(4) <= DecoderOut(4) AND RegEn;
    EnableVec(5) <= DecoderOut(5) AND RegEn;
    EnableVec(6) <= DecoderOut(6) AND RegEn;
    EnableVec(7) <= DecoderOut(7) AND RegEn;

    -- ----------------------------------------------------------------
    -- R0: hardwired to "0000" – no flip-flop needed
    -- ----------------------------------------------------------------
    R0 <= "0000";

    -- ----------------------------------------------------------------
    -- R1 – R7: writable 4-bit registers
    -- ----------------------------------------------------------------
    REG1 : entity work.register_4bit port map (D, Clk, Reset, EnableVec(1), R1);
    REG2 : entity work.register_4bit port map (D, Clk, Reset, EnableVec(2), R2);
    REG3 : entity work.register_4bit port map (D, Clk, Reset, EnableVec(3), R3);
    REG4 : entity work.register_4bit port map (D, Clk, Reset, EnableVec(4), R4);
    REG5 : entity work.register_4bit port map (D, Clk, Reset, EnableVec(5), R5);
    REG6 : entity work.register_4bit port map (D, Clk, Reset, EnableVec(6), R6);
    REG7 : entity work.register_4bit port map (D, Clk, Reset, EnableVec(7), R7);

end Structural;
