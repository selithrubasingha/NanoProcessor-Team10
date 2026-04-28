library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AndGate_TB is
-- Testbench has no ports
end AndGate_TB;

architecture Behavioral of AndGate_TB is
    signal a, b, output : std_logic;
begin
    UUT: entity work.AndGate port map (sw_a => a, sw_b => b, led_out => output);

    process begin
        a <= '0'; b <= '0'; wait for 10 ns;
        a <= '0'; b <= '1'; wait for 10 ns;
        a <= '1'; b <= '0'; wait for 10 ns;
        a <= '1'; b <= '1'; wait for 10 ns;
        wait;
    end process;
    -- hello (test change)
end Behavioral;