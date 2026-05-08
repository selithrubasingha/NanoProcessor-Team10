library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_nanoprocessor is
end tb_nanoprocessor;

architecture Behavioral of tb_nanoprocessor is
    component nanoprocessor
        Port (
            Clk, Reset : in STD_LOGIC;
            R7_Out : out STD_LOGIC_VECTOR(3 downto 0);
            Overflow, ZeroFlag, NegFlag : out STD_LOGIC;
            SevenSeg : out std_logic_vector(6 downto 0);
            Anode : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    signal Clk, Reset : STD_LOGIC := '0';
    signal R7_Out : STD_LOGIC_VECTOR(3 downto 0);
    signal Overflow, ZeroFlag, NegFlag : STD_LOGIC;
    signal SevenSeg : STD_LOGIC_VECTOR(6 downto 0);
    signal Anode : STD_LOGIC_VECTOR(3 downto 0);

    constant clk_period : time := 10 ns; -- 100MHz master clock

begin
    uut: nanoprocessor port map (Clk, Reset, R7_Out, Overflow, ZeroFlag, NegFlag, SevenSeg, Anode);

    clk_process: process
    begin
        Clk <= '0'; wait for clk_period/2;
        Clk <= '1'; wait for clk_period/2;
    end process;

    stim_proc: process
    begin		
        Reset <= '1'; wait for 50 ns;	
        Reset <= '0';
        
        -- The internal slow clock likely ticks every 100ns or more.
        -- We wait long enough to see the MOVI, PUSH, POP, and SUB instructions.
        wait for 2000 ns; 
        wait;
    end process;
end Behavioral;