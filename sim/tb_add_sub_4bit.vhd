library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_add_sub_4bit is
-- Testbench has no ports
end tb_add_sub_4bit;

architecture Behavioral of tb_add_sub_4bit is

    -- Component Declaration matching your source file exactly
    component add_sub_4bit
        Port (
            A        : in  STD_LOGIC_VECTOR(3 downto 0);
            B        : in  STD_LOGIC_VECTOR(3 downto 0);
            AddSub   : in  STD_LOGIC;
            Result   : out STD_LOGIC_VECTOR(3 downto 0);
            Overflow : out STD_LOGIC;
            Zero     : out STD_LOGIC;
            Negative : out STD_LOGIC
        );
    end component;

    -- Local signals for stimulus
    signal A, B     : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal AddSub   : STD_LOGIC := '0';
    signal Result   : STD_LOGIC_VECTOR(3 downto 0);
    signal Overflow : STD_LOGIC;
    signal Zero     : STD_LOGIC;
    signal Negative : STD_LOGIC;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: add_sub_4bit 
        port map (
            A        => A,
            B        => B,
            AddSub   => AddSub,
            Result   => Result,
            Overflow => Overflow,
            Zero     => Zero,
            Negative => Negative
        );

    -- Stimulus process to fill the full 1000ns window
    stim_proc: process
    begin		
        -- 0ns to 200ns: Test Addition (5 + 2 = 7)
        A <= "0101"; B <= "0010"; AddSub <= '0'; 
        wait for 200 ns;

        -- 200ns to 400ns: Test Subtraction (5 - 2 = 3)
        A <= "0101"; B <= "0010"; AddSub <= '1'; 
        wait for 200 ns;

        -- 400ns to 600ns: Test Negative Result (2 - 5 = -3)
        -- Result should be "1101" (2's complement for -3)
        A <= "0010"; B <= "0101"; AddSub <= '1'; 
        wait for 200 ns;

        -- 600ns to 800ns: Test Zero Flag (4 - 4 = 0)
        A <= "0100"; B <= "0100"; AddSub <= '1'; 
        wait for 200 ns;

        -- 800ns to 1000ns: Test Signed Overflow (7 + 1 = 8)
        -- In 4-bit signed, this wraps to -8, triggering Overflow
        A <= "0111"; B <= "0001"; AddSub <= '0'; 
        wait for 200 ns;

        wait; -- End of stimulus
    end process;

end Behavioral;