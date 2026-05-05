library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_program_counter is
end tb_program_counter;

architecture Behavioral of tb_program_counter is

    component program_counter
        Port (
            NextAddr : in  STD_LOGIC_VECTOR(2 downto 0);
            Clk      : in  STD_LOGIC;
            Reset    : in  STD_LOGIC;
            CurrAddr : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    -- Signals
    signal NextAddr : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal Clk      : STD_LOGIC := '0';
    signal Reset    : STD_LOGIC := '0';
    signal CurrAddr : STD_LOGIC_VECTOR(2 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    
    DUT: program_counter
        port map (
            NextAddr => NextAddr,
            Clk      => Clk,
            Reset    => Reset,
            CurrAddr => CurrAddr
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            Clk <= '0';
            wait for CLK_PERIOD/2;
            Clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Stimulus
    stim_proc: process
    begin

   
        Reset <= '1';
        wait for 15 ns;
        Reset <= '0';

        
        NextAddr <= "001";
        wait for CLK_PERIOD;

        NextAddr <= "010";
        wait for CLK_PERIOD;

        NextAddr <= "011";
        wait for CLK_PERIOD;

        NextAddr <= "100";
        wait for CLK_PERIOD;

        NextAddr <= "101";
        wait for CLK_PERIOD;

        NextAddr <= "110";
        wait for CLK_PERIOD;

        NextAddr <= "111";
        wait for CLK_PERIOD;

        wait;
    end process;

end Behavioral;
