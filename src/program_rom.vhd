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
            when "110" => Instruction <= "111110000110";

            -- Line 7: Safety padding
            when "111" => Instruction <= "110000000110";

            when others => Instruction <= (others => '0');
        end case;
    end process;
end Behavioral;
