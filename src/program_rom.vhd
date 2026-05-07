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
            -- Line 0: MOVI R7, -6 (1010) -> Load initial value
            when "000" => Instruction <= "101110001010";

            -- Line 1: PUSH R7 -> Save -6 to the stack
            when "001" => Instruction <= "101111000000";

            -- Line 2: POP R1 -> Retrieve -6 from the stack into R1
            when "010" => Instruction <= "100011010000";

            -- Line 3: ADD R7, R1 -> -6 + -6 = 4 (Overflow handles it!)
            when "011" => Instruction <= "001110010000";

            -- Line 4: OR R7, R1 -> 4 OR -6 = -2
            when "100" => Instruction <= "001110010011";

            -- Line 5: XOR R7, R1 -> -2 XOR -6 = 4
            when "101" => Instruction <= "001110010100";

            -- Line 6: AND R7, R1 -> 4 AND -6 = 0
            when "110" => Instruction <= "001110010010";

            -- Line 7: SUB R7, R1 -> 0 - (-6) = 6
            when "111" => Instruction <= "001110010001";

            when others => Instruction <= (others => '0');
        end case;
    end process;
end Behavioral;
-- library IEEE;
-- use IEEE.STD_LOGIC_1164.ALL;

-- entity program_rom is
--     Port (
--         Addr        : in  STD_LOGIC_VECTOR(2 downto 0);
--         Instruction : out STD_LOGIC_VECTOR(11 downto 0)
--     );
-- end program_rom;

-- architecture Behavioral of program_rom is
-- begin
--     -- process(Addr)
--     -- begin
--     --     case Addr is
--     --         -- Line 0: MOVI R1, 1
--     --         when "000" => Instruction <= "100010000001";

--     --         -- Line 1: MOVI R2, 2
--     --         when "001" => Instruction <= "100100000010";

--     --         -- Line 2: MOVI R3, 3
--     --         when "010" => Instruction <= "100110000011";

--     --         -- Line 3: ADD R1, R2  -> R1 = 1+2 = 3
--     --         when "011" => Instruction <= "000010100000";

--     --         -- Line 4: ADD R1, R3  -> R1 = 3+3 = 6
--     --         when "100" => Instruction <= "000010110000";

--     --         -- Line 5: ADD R7, R1  -> R7 = 0+6 = 6  (store result)
--     --         when "101" => Instruction <= "001110010000";

--     --         -- Line 6: JZR R0, 6  -> R0=0, always jump to address 6 (halt)
--     --         when "110" => Instruction <= "111110000110";

--     --         -- Line 7: Safety padding
--     --         when "111" => Instruction <= "110000000110";

--     --         when others => Instruction <= (others => '0');
--     --     end case;
--     -- end process;
--     -- process(Addr)
--     -- begin
--     --     case Addr is
--     --         -- Line 0: MOVI R1, 2
--     --         when "000" => Instruction <= "100010000010";

--     --         -- Line 1: MOVI R2, 4
--     --         when "001" => Instruction <= "100100000100";

--     --         -- Line 2: SUB R1, R2  -> R1 = 2 - 4 = -2
--     --         -- Opcode 00 (ALU), Dest R1 (001), Src R2 (010). Bit 0 is '1' for Subtract!
--     --         -- SUB R1, R2: bit 10 = '1', bit 0 = '0'
--     --         when "010" => Instruction <= "000110100000";
--     --         --                                ^-- bit 10 is now '1'

--     --         -- Line 3: ADD R7, R1  -> R7 = 0 + (-2) = -2 (Moves result to Output)
--     --         when "011" => Instruction <= "001110010000";

--     --         -- Line 4: JZR R0, 4  -> R0 is hardwired 0, so this creates an infinite loop (Halt)
--     --         when "100" => Instruction <= "110000000100";

--     --         -- Safety padding
--     --         when others => Instruction <= (others => '0');
--     --     end case;
--     -- end process;

--     process(Addr)
-- begin
--     case Addr is
-- -- Line 0: MOVI R1, 1
--         when "000" => Instruction <= "100010000001";

--         -- Line 1: MOVI R2, 5
--         when "001" => Instruction <= "100100000101";

--         -- Line 2: NEG R2  →  R2 = -5
--         when "010" => Instruction <= "010100000000";

--         -- Line 3: ADD R1, R2  →  R1 = 1 + (-5) = -4
--         when "011" => Instruction <= "000010100000";

--         -- Line 4: ADD R7, R1  →  R7 = -4
--         when "100" => Instruction <= "001110010000";

--         -- Line 5: JZR R0, 5  →  halt
--         when "101" => Instruction <= "110000000101";

--         when others => Instruction <= (others => '0');
--     end case;
-- end process;
-- end Behavioral;
