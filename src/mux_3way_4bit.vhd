library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_3way_4bit is
    Port (
        A   : in  STD_LOGIC_VECTOR(3 downto 0); -- ALU result
        B   : in  STD_LOGIC_VECTOR(3 downto 0); -- Immediate value
        C   : in  STD_LOGIC_VECTOR(3 downto 0); -- Stack value
        Sel : in  STD_LOGIC_VECTOR(1 downto 0);
        Y   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end mux_3way_4bit;

architecture Behavioral of mux_3way_4bit is
begin
    Y <= A when Sel = "00" else
         B when Sel = "01" else
         C when Sel = "10" else
         A; -- Default to ALU
end Behavioral;