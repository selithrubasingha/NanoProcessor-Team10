library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_mux_2way_4bit is

end tb_mux_2way_4bit;

architecture Behavioral of tb_mux_2way_4bit is

    component mux_2way_4bit
        Port (
            A   : in  STD_LOGIC_VECTOR(3 downto 0);
            B   : in  STD_LOGIC_VECTOR(3 downto 0);
            Sel : in  STD_LOGIC;
            Y   : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    -- Local signals for simulation
    signal A   : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal B   : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal Sel : STD_LOGIC := '0';
    signal Y   : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- Instantiate the UUT
    uut: mux_2way_4bit
        port map (
            A   => A,
            B   => B,
            Sel => Sel,
            Y   => Y
        );

    -- Stimulus Process
    stim_proc: process
    begin
        -- Initial State: Select ALU Result (A)
        -- Expected Y: "1010" (decimal 10)
        A <= "1010"; 
        B <= "0101";
        Sel <= '0';
        wait for 100 ns;

        -- Scenario: Instruction is MOVI (Move Immediate)
        -- Switch Sel to '1' to pick B
        -- Expected Y: "0101" (decimal 5)
        Sel <= '1';
        wait for 100 ns;

        -- Scenario: ALU finishes a new calculation while MOVI is active
        -- A changes, but Y should stay as B
        -- Expected Y: "0101"
        A <= "1111"; 
        wait for 100 ns;

        -- Scenario: Switch back to ALU result
        -- Expected Y: "1111"
        Sel <= '0';
        wait for 100 ns;

        -- Final test: Both inputs change
        A <= "0001";
        B <= "1110";
        Sel <= '1'; -- Picking B
        wait for 100 ns;

        -- End of testing
        wait;
    end process;

end Behavioral;
