
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_nanoprocessor is
end tb_nanoprocessor;

architecture Behavioral of tb_nanoprocessor is

    signal Clk      : STD_LOGIC := '0';
    signal Reset    : STD_LOGIC := '1';
    signal R7_Out   : STD_LOGIC_VECTOR(3 downto 0);
    signal Overflow : STD_LOGIC;
    signal ZeroFlag : STD_LOGIC;


    constant CLK_PERIOD : time := 10 ns;

begin
    UUT : entity work.nanoprocessor
        port map (
            Clk      => Clk,
            Reset    => Reset,
            R7_Out   => R7_Out,
            Overflow => Overflow,
            ZeroFlag => ZeroFlag
        );

    -- Clock generation: toggles every half period
    Clk <= not Clk after CLK_PERIOD / 2;

    process
    begin

        Reset <= '1';
        wait for CLK_PERIOD * 2;
        Reset <= '0';


        wait for CLK_PERIOD * 10;

        assert R7_Out = "0110"
            report "FAIL: Expected R7=6 (0110), got " &
                   STD_LOGIC'image(R7_Out(3)) &
                   STD_LOGIC'image(R7_Out(2)) &
                   STD_LOGIC'image(R7_Out(1)) &
                   STD_LOGIC'image(R7_Out(0))
            severity error;


        assert Overflow = '0'
            report "FAIL: Unexpected overflow" severity error;


        Reset <= '1';
        wait for CLK_PERIOD * 2;

        assert R7_Out = "0000"
            report "FAIL: R7 should be 0 after reset" severity error;
        Reset <= '0';

        wait for CLK_PERIOD * 10;
        assert R7_Out = "0110"
            report "FAIL: Second run: Expected R7=6" severity error;

        report "nanoprocessor: ALL TESTS PASSED - R7 = 6 (0110)" severity note;
        wait;
    end process;
end Behavioral;
