---------------------------------------------------------------------------
-- tb_add_sub_4bit.vhd
-- Testbench for the 4-bit Add/Subtract unit.
-- Tests: addition, subtraction, overflow, zero flag, NEG simulation.
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_add_sub_4bit is
end tb_add_sub_4bit;

architecture Behavioral of tb_add_sub_4bit is

    signal A, B    : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal AddSub  : STD_LOGIC := '0';
    signal Result  : STD_LOGIC_VECTOR(3 downto 0);
    signal Overflow: STD_LOGIC;
    signal Zero    : STD_LOGIC;

begin
    UUT : entity work.add_sub_4bit
        port map (A, B, AddSub, Result, Overflow, Zero);

    process
    begin
        -- -------------------------------------------------------
        -- Test 1: 3 + 2 = 5  (no overflow)
        A <= "0011"; B <= "0010"; AddSub <= '0';
        wait for 20 ns;
        assert Result = "0101" report "FAIL: 3+2" severity error;
        assert Overflow = '0'  report "FAIL: OV 3+2" severity error;
        assert Zero = '0'      report "FAIL: Z 3+2" severity error;

        -- -------------------------------------------------------
        -- Test 2: 0 + 0 = 0  (zero flag should be '1')
        A <= "0000"; B <= "0000"; AddSub <= '0';
        wait for 20 ns;
        assert Result = "0000" report "FAIL: 0+0" severity error;
        assert Zero = '1'      report "FAIL: Z 0+0" severity error;

        -- -------------------------------------------------------
        -- Test 3: 5 - 3 = 2  (subtraction)
        A <= "0101"; B <= "0011"; AddSub <= '1';
        wait for 20 ns;
        assert Result = "0010" report "FAIL: 5-3" severity error;
        assert Overflow = '0'  report "FAIL: OV 5-3" severity error;

        -- -------------------------------------------------------
        -- Test 4: 3 - 3 = 0  (zero flag after subtraction)
        A <= "0011"; B <= "0011"; AddSub <= '1';
        wait for 20 ns;
        assert Result = "0000" report "FAIL: 3-3" severity error;
        assert Zero = '1'      report "FAIL: Z 3-3" severity error;

        -- -------------------------------------------------------
        -- Test 5: NEG simulation: A=0, B=0011 (3), AddSub='1'
        -- Expects 0 - 3 = -3 = 1101 in 4-bit 2's complement
        A <= "0000"; B <= "0011"; AddSub <= '1';
        wait for 20 ns;
        assert Result = "1101" report "FAIL: NEG 3" severity error;
        assert Zero = '0'      report "FAIL: Z NEG 3" severity error;

        -- -------------------------------------------------------
        -- Test 6: NEG simulation: A=0, B=0000 (0)
        -- Expects 0 - 0 = 0, Zero='1'
        A <= "0000"; B <= "0000"; AddSub <= '1';
        wait for 20 ns;
        assert Result = "0000" report "FAIL: NEG 0" severity error;
        assert Zero = '1'      report "FAIL: Z NEG 0" severity error;

        -- -------------------------------------------------------
        -- Test 7: Signed overflow: 7 + 1 = 8 should overflow
        -- 0111 + 0001 = 1000 (looks like -8 in signed), overflow expected
        A <= "0111"; B <= "0001"; AddSub <= '0';
        wait for 20 ns;
        assert Overflow = '1'  report "FAIL: overflow 7+1" severity error;

        -- -------------------------------------------------------
        -- Test 8: JZR zero check: R=0101 (5), A=0, B=R, Sub
        -- 0 - 5 != 0, so Zero should be '0'
        A <= "0000"; B <= "0101"; AddSub <= '1';
        wait for 20 ns;
        assert Zero = '0' report "FAIL: JZR non-zero check" severity error;

        report "add_sub_4bit: ALL TESTS PASSED" severity note;
        wait;
    end process;
end Behavioral;
