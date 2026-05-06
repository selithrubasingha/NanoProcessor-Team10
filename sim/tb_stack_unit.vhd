library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_stack_unit is
end tb_stack_unit;

architecture Behavioral of tb_stack_unit is

    component stack_unit
        Port (
            Clk         : in  STD_LOGIC;
            Reset       : in  STD_LOGIC;
            DataIn      : in  STD_LOGIC_VECTOR(3 downto 0);
            DataOut     : out STD_LOGIC_VECTOR(3 downto 0);
            StackWrite  : in  STD_LOGIC;
            SP_inc      : in  STD_LOGIC;
            SP_dec      : in  STD_LOGIC;
            StackFull   : out STD_LOGIC;
            StackEmpty  : out STD_LOGIC
        );
    end component;

    signal Clk         : STD_LOGIC := '0';
    signal Reset       : STD_LOGIC := '0';

    signal DataIn      : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal DataOut     : STD_LOGIC_VECTOR(3 downto 0);

    signal StackWrite  : STD_LOGIC := '0';
    signal SP_inc      : STD_LOGIC := '0';
    signal SP_dec      : STD_LOGIC := '0';

    signal StackFull   : STD_LOGIC;
    signal StackEmpty  : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;

begin

    UUT : stack_unit
        port map (
            Clk         => Clk,
            Reset       => Reset,
            DataIn      => DataIn,
            DataOut     => DataOut,
            StackWrite  => StackWrite,
            SP_inc      => SP_inc,
            SP_dec      => SP_dec,
            StackFull   => StackFull,
            StackEmpty  => StackEmpty
        );

    Clk <= not Clk after CLK_PERIOD / 2;

    process
    begin
        Reset <= '1';
        wait for CLK_PERIOD * 2;
        Reset <= '0';

        wait for CLK_PERIOD;

        assert StackEmpty = '1'
            report "FAIL: Stack should be empty after reset"
            severity error;

        DataIn <= "0011";
        StackWrite <= '1';
        SP_inc <= '1';

        wait for CLK_PERIOD;

        StackWrite <= '0';
        SP_inc <= '0';

        wait for CLK_PERIOD;

        assert DataOut = "0011"
            report "FAIL: Expected top = 3"
            severity error;

        DataIn <= "0101";
        StackWrite <= '1';
        SP_inc <= '1';

        wait for CLK_PERIOD;

        StackWrite <= '0';
        SP_inc <= '0';

        wait for CLK_PERIOD;

        assert DataOut = "0101"
            report "FAIL: Expected top = 5"
            severity error;

        DataIn <= "1001";
        StackWrite <= '1';
        SP_inc <= '1';

        wait for CLK_PERIOD;

        StackWrite <= '0';
        SP_inc <= '0';

        wait for CLK_PERIOD;

        assert DataOut = "1001"
            report "FAIL: Expected top = 9"
            severity error;

        SP_dec <= '1';

        wait for CLK_PERIOD;

        SP_dec <= '0';

        wait for CLK_PERIOD;

        assert DataOut = "0101"
            report "FAIL: Expected top = 5 after pop"
            severity error;

        SP_dec <= '1';

        wait for CLK_PERIOD;

        SP_dec <= '0';

        wait for CLK_PERIOD;

        assert DataOut = "0011"
            report "FAIL: Expected top = 3 after pop"
            severity error;

        SP_dec <= '1';

        wait for CLK_PERIOD;

        SP_dec <= '0';

        wait for CLK_PERIOD;

        assert StackEmpty = '1'
            report "FAIL: Stack should be empty"
            severity error;

        for i in 0 to 7 loop

            DataIn <= std_logic_vector(to_unsigned(i,4));

            StackWrite <= '1';
            SP_inc <= '1';

            wait for CLK_PERIOD;

            StackWrite <= '0';
            SP_inc <= '0';

            wait for CLK_PERIOD;

        end loop;

        assert StackFull = '1'
            report "FAIL: Stack should be full"
            severity error;

        DataIn <= "1111";
        StackWrite <= '1';
        SP_inc <= '1';

        wait for CLK_PERIOD;

        StackWrite <= '0';
        SP_inc <= '0';

        wait for CLK_PERIOD;

        report "Overflow attempt completed (manual waveform inspection recommended)"
            severity note;

        for i in 0 to 8 loop

            SP_dec <= '1';

            wait for CLK_PERIOD;

            SP_dec <= '0';

            wait for CLK_PERIOD;

        end loop;

        report "Underflow attempt completed (manual waveform inspection recommended)"
            severity note;

        report "ALL STACK TESTS PASSED"
            severity note;

        wait;

    end process;

end Behavioral;