library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AndGate is
    Port ( sw_a : in STD_LOGIC;
           sw_b : in STD_LOGIC;
           led_out : out STD_LOGIC);
end AndGate;

architecture Behavioral of AndGate is
begin
    led_out <= sw_a and sw_b;
end Behavioral;