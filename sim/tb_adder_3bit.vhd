library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_adder_3bit is
end tb_adder_3bit;

architecture Behavioral of tb_adder_3bit is

    -- Component declaration
    component adder_3bit
        Port (
            A   : in  STD_LOGIC_VECTOR(2 downto 0);
            B   : in  STD_LOGIC_VECTOR(2 downto 0);
            Sum : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    -- Signals
    signal A   : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal B   : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal Sum : STD_LOGIC_VECTOR(2 downto 0);

begin

    -- Instantiate DUT
    DUT: adder_3bit
        port map (
            A   => A,
            B   => B,
            Sum => Sum
        );

  
    stim_proc: process
    begin

 
        A <= "000"; B <= "000"; wait for 10 ns; -- 0 + 0 = 0
        A <= "001"; B <= "001"; wait for 10 ns; -- 1 + 1 = 2
        A <= "010"; B <= "011"; wait for 10 ns; -- 2 + 3 = 5
        A <= "111"; B <= "001"; wait for 10 ns; -- 7 + 1 = 8 (overflow ignored)
        A <= "101"; B <= "010"; wait for 10 ns; -- 5 + 2 = 7
        A <= "111"; B <= "111"; wait for 10 ns; -- 7 + 7 = 14 (lower 3 bits = 110)

        wait;
    end process;

end Behavioral;
