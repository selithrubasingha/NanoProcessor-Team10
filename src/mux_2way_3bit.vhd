
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2way_3bit is
    Port (
        A   : in  STD_LOGIC_VECTOR(2 downto 0);   -- PC + 1
        B   : in  STD_LOGIC_VECTOR(2 downto 0);   -- jump target address
        Sel : in  STD_LOGIC;                       -- 0=A, 1=B
        Y   : out STD_LOGIC_VECTOR(2 downto 0)
    );
end mux_2way_3bit;

architecture Behavioral of mux_2way_3bit is
begin
    Y <= B when Sel = '1' else A;
end Behavioral;
