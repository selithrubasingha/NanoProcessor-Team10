LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity sevenseg_rom is
    port (
        address : in std_logic_vector (3 downto 0);
        data : out std_logic_vector (6 downto 0));
end sevenseg_rom;

architecture behavioral of sevenseg_rom is

    type seg7_t is array (0 to 17) of std_logic_vector(6 downto 0);

    signal sevenseg_rom : seg7_t := (
        "1000000", --0
        "1111001", --1
        "0100100", --2
        "0110000", --3
        "0011001", --4
        "0010010", --5
        "0000010", --6
        "1111000", --7
        "0000000", --8
        "0010000", --9
        "0001000", --a
        "0000011", --b
        "1000110", --c
        "0100001", --d
        "0000110", --e
        "0001110", --f
        "0111111", --Minus Sign (Index 16)
        "1111111"  --Blank (Index 17)
    );

begin
    data <= sevenseg_rom(to_integer(unsigned(address)));

end behavioral;
