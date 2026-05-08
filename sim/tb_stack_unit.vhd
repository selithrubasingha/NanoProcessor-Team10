library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_stack_unit is
-- Testbench has no ports
end tb_stack_unit;

architecture Behavioral of tb_stack_unit is

    -- Component Declaration
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

    -- Signals
    signal Clk         : STD_LOGIC := '0';
    signal Reset       : STD_LOGIC := '0';
    signal DataIn      : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal DataOut     : STD_LOGIC_VECTOR(3 downto 0);
    signal StackWrite  : STD_LOGIC := '0';
    signal SP_inc      : STD_LOGIC := '0';
    signal SP_dec      : STD_LOGIC := '0';
    signal StackFull   : STD_LOGIC;
    signal StackEmpty  : STD_LOGIC;

    -- Clock period
    constant clk_period : time := 20 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: stack_unit Port map (
        Clk => Clk,
        Reset => Reset,
        DataIn => DataIn,
        DataOut => DataOut,
        StackWrite => StackWrite,
        SP_inc => SP_inc,
        SP_dec => SP_dec,
        StackFull => StackFull,
        StackEmpty => StackEmpty
    );

    -- Clock Generation
    clk_process : process
    begin
        Clk <= '0';
        wait for clk_period/2;
        Clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus Process
    stim_proc: process
    begin		
        -- 1. Reset the Stack
        Reset <= '1';
        wait for clk_period * 2;
        Reset <= '0';
        wait for clk_period;

        -- 2. PUSH 3 values into the stack
        -- Push Value 5
        DataIn <= "0101"; StackWrite <= '1'; SP_inc <= '1';
        wait for clk_period;
        
        -- Push Value 9
        DataIn <= "1001"; StackWrite <= '1'; SP_inc <= '1';
        wait for clk_period;

        -- Push Value 2
        DataIn <= "0010"; StackWrite <= '1'; SP_inc <= '1';
        wait for clk_period;
        
        -- Stop Pushing
        StackWrite <= '0'; SP_inc <= '0';
        wait for clk_period * 2;

        -- 3. POP 2 values from the stack
        -- Pop the last value (should be 2)
        SP_dec <= '1';
        wait for clk_period;
        SP_dec <= '0';
        wait for clk_period; -- DataOut should now show 9 (the new top)

        -- Pop the next value (should be 9)
        SP_dec <= '1';
        wait for clk_period;
        SP_dec <= '0';
        wait for clk_period; -- DataOut should now show 5

        -- 4. Test StackFull
        -- The stack has 8 slots (0 to 7). We currently have 1 item left (5).
        -- Let's fill it up to the max.
        StackWrite <= '1'; SP_inc <= '1';
        DataIn <= "0001"; wait for clk_period; -- Index 1
        DataIn <= "0010"; wait for clk_period; -- Index 2
        DataIn <= "0011"; wait for clk_period; -- Index 3
        DataIn <= "0100"; wait for clk_period; -- Index 4
        DataIn <= "0101"; wait for clk_period; -- Index 5
        DataIn <= "0110"; wait for clk_period; -- Index 6
        DataIn <= "0111"; wait for clk_period; -- Index 7
        
        StackWrite <= '0'; SP_inc <= '0';
        -- At this point, StackFull should be '1'
        wait for clk_period * 5;

        wait;
    end process;

end Behavioral;