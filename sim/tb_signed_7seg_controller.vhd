library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_signed_controller is
end tb_signed_controller;

architecture Behavioral of tb_signed_controller is
    component Signed_7Seg_Controller
        Port (
            Clk, Reset : in STD_LOGIC;
            Reg_Data   : in STD_LOGIC_VECTOR(3 downto 0);
            SevenSeg   : out STD_LOGIC_VECTOR(6 downto 0);
            Anode      : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    signal Clk, Reset : STD_LOGIC := '0';
    signal Reg_Data   : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal SevenSeg   : STD_LOGIC_VECTOR(6 downto 0);
    signal Anode      : STD_LOGIC_VECTOR(3 downto 0);

begin
    uut: Signed_7Seg_Controller port map (Clk, Reset, Reg_Data, SevenSeg, Anode);

    -- 100 MHz Clock
    Clk <= not Clk after 5 ns;

    stim_proc: process
    begin
        Reset <= '1'; wait for 20 ns; Reset <= '0';

        -- INPUT 1: Positive 6 (Should show '6' and 'Blank')
        Reg_Data <= "0110";
        wait for 800 us; -- Wait for multiple multiplexing cycles

        -- INPUT 2: Negative 2 (Should show '2' and '-')
        Reg_Data <= "1110";
        wait for 800 us;

        -- INPUT 3: Negative 6 (Should show '6' and '-')
        Reg_Data <= "1010";
        wait for 800 us;

        wait;
    end process;
end Behavioral;