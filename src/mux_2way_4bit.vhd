
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2way_4bit is
    Port (
        A   : in  STD_LOGIC_VECTOR(3 downto 0);   -- ALU result
        B   : in  STD_LOGIC_VECTOR(3 downto 0);   -- immediate value
        Sel : in  STD_LOGIC;                       -- 0=A(ALU), 1=B(Imm)
        Y   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end mux_2way_4bit;

architecture Behavioral of mux_2way_4bit is
begin
    Y <= B when Sel = '1' else A;
end Behavioral;
