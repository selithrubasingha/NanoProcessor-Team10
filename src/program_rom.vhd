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
            when "000" => Instruction <= "100010000101"; -- MOVI R1, 5
            when "001" => Instruction <= "100100000011"; -- MOVI R2, 3
            when "010" => Instruction <= "100011000000"; -- PUSH R1 (Stack: [5])
            when "011" => Instruction <= "100101000000"; -- PUSH R2 (Stack: [5, 3])
            when "100" => Instruction <= "100110000000"; -- MOVI R3, 0 (Clear R3)
            when "101" => Instruction <= "100111010000"; -- POP R3  (R3 should be 3)
            when "110" => Instruction <= "100111010000"; -- POP R3  (R3 should be 5)
            when "111" => Instruction <= "110000000111"; -- JZR R0, 7 (Halt)
            when others => Instruction <= (others => '0');
        end case;
    end process;
end Behavioral;
