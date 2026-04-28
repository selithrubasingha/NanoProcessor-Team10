---------------------------------------------------------------------------
-- tb_register_bank.vhd
-- Testbench for the Register Bank.
-- Tests: write to each register, R0 stays zero, Reset clears all.
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_register_bank is
end tb_register_bank;

architecture Behavioral of tb_register_bank is

    signal D      : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal RegSel : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal RegEn  : STD_LOGIC := '0';
    signal Clk    : STD_LOGIC := '0';
    signal Reset  : STD_LOGIC := '0';
    signal R0, R1, R2, R3, R4, R5, R6, R7 : STD_LOGIC_VECTOR(3 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin
    UUT : entity work.register_bank
        port map (D, RegSel, RegEn, Clk, Reset, R0, R1, R2, R3, R4, R5, R6, R7);

    -- Clock generation
    Clk <= not Clk after CLK_PERIOD / 2;

    process
    begin
        -- -------------------------------------------------------
        -- Test: R0 must always be "0000" and cannot be written
        D <= "1111"; RegSel <= "000"; RegEn <= '1';
        wait for CLK_PERIOD;
        assert R0 = "0000" report "FAIL: R0 should be hardwired 0" severity error;

        -- -------------------------------------------------------
        -- Test: Write "1010" to R1
        D <= "1010"; RegSel <= "001"; RegEn <= '1';
        wait for CLK_PERIOD;
        assert R1 = "1010" report "FAIL: R1 write" severity error;

        -- -------------------------------------------------------
        -- Test: Write "0110" to R7
        D <= "0110"; RegSel <= "111"; RegEn <= '1';
        wait for CLK_PERIOD;
        assert R7 = "0110" report "FAIL: R7 write" severity error;

        -- -------------------------------------------------------
        -- Test: RegEn='0' should prevent writing
        D <= "1111"; RegSel <= "001"; RegEn <= '0';
        wait for CLK_PERIOD;
        assert R1 = "1010" report "FAIL: RegEn=0 should hold R1" severity error;

        -- -------------------------------------------------------
        -- Test: Write to R2, R3
        D <= "0011"; RegSel <= "010"; RegEn <= '1';
        wait for CLK_PERIOD;
        assert R2 = "0011" report "FAIL: R2 write" severity error;

        D <= "0101"; RegSel <= "011"; RegEn <= '1';
        wait for CLK_PERIOD;
        assert R3 = "0101" report "FAIL: R3 write" severity error;

        -- -------------------------------------------------------
        -- Test: Reset clears R1..R7 to "0000"
        Reset <= '1';
        wait for CLK_PERIOD;
        assert R1 = "0000" report "FAIL: Reset R1" severity error;
        assert R2 = "0000" report "FAIL: Reset R2" severity error;
        assert R7 = "0000" report "FAIL: Reset R7" severity error;
        assert R0 = "0000" report "FAIL: Reset R0" severity error;
        Reset <= '0';

        report "register_bank: ALL TESTS PASSED" severity note;
        wait;
    end process;
end Behavioral;
