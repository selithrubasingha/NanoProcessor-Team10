library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_seve_seg is
end tb_seve_seg;

architecture Behavioral of tb_seve_seg is

    -- Component declaration
    component sevenseg_rom
        port (
            address : in  std_logic_vector(3 downto 0);
            data    : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Signals
    signal address : std_logic_vector(3 downto 0) := "0000";
    signal data    : std_logic_vector(6 downto 0);

begin

    -- Instantiate Unit Under Test (UUT)
    UUT: sevenseg_rom
        port map (
            address => address,
            data    => data
        );

    -- Stimulus process
    stimulus: process
    begin
        for i in 0 to 15 loop
            address <= std_logic_vector(to_unsigned(i, 4));
            wait for 20 ns;
        end loop;

        wait;
    end process;

end Behavioral;
