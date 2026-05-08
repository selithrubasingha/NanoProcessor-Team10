library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_sevenseg_rom is
-- Testbench has no ports
end tb_sevenseg_rom;

architecture Behavioral of tb_sevenseg_rom is

    -- Component Declaration
    component sevenseg_rom
        port (
            address : in std_logic_vector (4 downto 0);
            data : out std_logic_vector (6 downto 0)
        );
    end component;

    -- Signals
    signal address : std_logic_vector(4 downto 0) := (others => '0');
    signal data    : std_logic_vector(6 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: sevenseg_rom port map (
        address => address,
        data => data
    );

    -- Stimulus process
    stim_proc: process
    begin		
        -- Test digits 0 to 9
        for i in 0 to 9 loop
            address <= std_logic_vector(to_unsigned(i, 5));
            wait for 20 ns;
        end loop;

        -- Test Hex letters A to F
        for i in 10 to 15 loop
            address <= std_logic_vector(to_unsigned(i, 5));
            wait for 20 ns;
        end loop;

        -- Test the Minus Sign (Index 16)
        address <= "10000"; -- Decimal 16
        wait for 20 ns;

        -- Test the Blank State (Index 17)
        address <= "10001"; -- Decimal 17
        wait for 20 ns;

        -- Final wait
        wait;
    end process;

end Behavioral;