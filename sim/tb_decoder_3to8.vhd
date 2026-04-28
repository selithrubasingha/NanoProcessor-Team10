library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_decoder_3to8 is
end tb_decoder_3to8;

architecture Behavioral of tb_decoder_3to8 is
    component decoder_3to8
        Port ( A : in STD_LOGIC_VECTOR (2 downto 0);
               Y : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    signal A : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal Y : STD_LOGIC_VECTOR(7 downto 0);

begin
    uut: decoder_3to8 port map (A => A, Y => Y);

    stim_proc: process
    begin
        A <= "111"; wait for 100 ns;
        A <= "011"; wait for 100 ns;
        A <= "101"; wait for 100 ns;
        A <= "010"; wait for 100 ns;
        A <= "000"; wait for 100 ns;

        wait;
    end process;
end Behavioral;