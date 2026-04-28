
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instruction_decoder is
    Port (
        Instruction : in  STD_LOGIC_VECTOR(11 downto 0);
        Zero        : in  STD_LOGIC;   -- ALU Zero flag; used for JZR jump decision
        RegSel      : out STD_LOGIC_VECTOR(2 downto 0);
        RegEn       : out STD_LOGIC;
        MuxA_Sel    : out STD_LOGIC_VECTOR(2 downto 0);
        MuxB_Sel    : out STD_LOGIC_VECTOR(2 downto 0);
        AddSub      : out STD_LOGIC;
        ImmVal      : out STD_LOGIC_VECTOR(3 downto 0);
        ImmMuxSel   : out STD_LOGIC;
        JumpFlag    : out STD_LOGIC;
        JumpAddr    : out STD_LOGIC_VECTOR(2 downto 0)
    );
end instruction_decoder;

architecture Behavioral of instruction_decoder is

        -- Convenience aliases for the opcode field
    alias Opcode : STD_LOGIC_VECTOR(1 downto 0) is Instruction(11 downto 10);
    -- Primary register field (Ra for ADD, R for MOVI/NEG/JZR)
    alias RegA   : STD_LOGIC_VECTOR(2 downto 0) is Instruction(9 downto 7);
    -- Secondary register field (Rb for ADD only)
    alias RegB   : STD_LOGIC_VECTOR(2 downto 0) is Instruction(6 downto 4);
    -- Immediate / jump target fields
    alias ImmFull : STD_LOGIC_VECTOR(3 downto 0) is Instruction(3 downto 0);
    alias JmpDest : STD_LOGIC_VECTOR(2 downto 0) is Instruction(2 downto 0);

end Behavioral;

begin

    -- Always drive these from fixed bit positions – they are just
    -- wire assignments, valid regardless of which instruction is running.
    ImmVal   <= ImmFull;         -- bits 3:0  (meaningful only for MOVI)
    JumpAddr <= JmpDest;         -- bits 2:0  (meaningful only for JZR)

    -- ---------------------------------------------------------------
    -- Main combinational decode process
    -- ---------------------------------------------------------------
    process(Opcode, RegA, RegB, Zero)
    begin
        -- Safe defaults (will be overridden below per instruction)
        RegSel    <= RegA;
        RegEn     <= '0';
        MuxA_Sel  <= "000";
        MuxB_Sel  <= "000";
        AddSub    <= '0';
        ImmMuxSel <= '0';
        JumpFlag  <= '0';

        case Opcode is

            -- -------------------------------------------------------
            -- ADD Ra, Rb  (opcode = "00")
            -- Ra <- Ra + Rb
            -- -------------------------------------------------------
            when "00" =>
                RegSel    <= RegA;     -- write result back to Ra
                RegEn     <= '1';
                MuxA_Sel  <= RegA;     -- operand A = Ra
                MuxB_Sel  <= RegB;     -- operand B = Rb
                AddSub    <= '0';      -- perform addition
                ImmMuxSel <= '0';      -- ALU result on Data Bus
                JumpFlag  <= '0';

            -- -------------------------------------------------------
            -- NEG R  (opcode = "01")
            -- R <- 0 - R  (two's complement)
            -- MuxA = R0 = "0000", MuxB = R, AddSub = '1'
            -- -------------------------------------------------------
            when "01" =>
                RegSel    <= RegA;     -- write result back to R
                RegEn     <= '1';
                MuxA_Sel  <= "000";    -- operand A = R0 = 0
                MuxB_Sel  <= RegA;     -- operand B = R (register to negate)
                AddSub    <= '1';      -- perform subtraction: 0 - R = -R
                ImmMuxSel <= '0';      -- ALU result on Data Bus
                JumpFlag  <= '0';

            -- -------------------------------------------------------
            -- MOVI R, d  (opcode = "10")
            -- R <- d  (immediate value bypasses the ALU)
            -- -------------------------------------------------------
            when "10" =>
                RegSel    <= RegA;     -- destination register R
                RegEn     <= '1';
                MuxA_Sel  <= "000";    -- don't care (ALU not used)
                MuxB_Sel  <= "000";    -- don't care (ALU not used)
                AddSub    <= '0';      -- don't care
                ImmMuxSel <= '1';      -- immediate value on Data Bus (bypass ALU)
                JumpFlag  <= '0';

            -- -------------------------------------------------------
            -- JZR R, d  (opcode = "11")
            -- if R == 0 then PC <- d; else PC <- PC+1
            -- Uses ALU to check: 0 - R = 0 iff R = 0
            -- -------------------------------------------------------
            when "11" =>
                RegSel    <= "000";    -- no register written
                RegEn     <= '0';      -- CRITICAL: disable all register writes
                MuxA_Sel  <= "000";    -- operand A = R0 = 0
                MuxB_Sel  <= RegA;     -- operand B = R (register being tested)
                AddSub    <= '1';      -- 0 - R: if Zero=1 then R=0
                ImmMuxSel <= '0';      -- don't care (no write)
                JumpFlag  <= Zero;     -- jump iff ALU says result is zero

            when others =>
                -- Should never happen with a 2-bit opcode and 4 cases,
                -- but synthesis requires an others clause.
                RegSel    <= "000";
                RegEn     <= '0';
                MuxA_Sel  <= "000";
                MuxB_Sel  <= "000";
                AddSub    <= '0';
                ImmMuxSel <= '0';
                JumpFlag  <= '0';

        end case;
    end process;

end Behavioral;

