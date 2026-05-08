---------------------------------------------------------------------------
-- mux_8way_4bit.vhd
-- Two instances are used in the nanoprocessor:
--   MUX_A  :  select signal = MuxA_Sel from decoder
--              feeds operand A of the Add/Sub unit
--   MUX_B  :  select signal = MuxB_Sel from decoder
--              feeds operand B of the Add/Sub unit
--             
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_8way_4bit is
    Port (
        I0  : in  STD_LOGIC_VECTOR(3 downto 0);   -- Register 0 output
        I1  : in  STD_LOGIC_VECTOR(3 downto 0);   -- Register 1 output
        I2  : in  STD_LOGIC_VECTOR(3 downto 0);   -- Register 2 output
        I3  : in  STD_LOGIC_VECTOR(3 downto 0);   -- Register 3 output
        I4  : in  STD_LOGIC_VECTOR(3 downto 0);   -- Register 4 output
        I5  : in  STD_LOGIC_VECTOR(3 downto 0);   -- Register 5 output
        I6  : in  STD_LOGIC_VECTOR(3 downto 0);   -- Register 6 output
        I7  : in  STD_LOGIC_VECTOR(3 downto 0);   -- Register 7 output
        Sel : in  STD_LOGIC_VECTOR(2 downto 0);   -- 3-bit register address
        Y   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end mux_8way_4bit;

architecture Behavioral of mux_8way_4bit is
begin
    process(I0, I1, I2, I3, I4, I5, I6, I7, Sel)
    begin
        case Sel is
            when "000"  => Y <= I0;
            when "001"  => Y <= I1;
            when "010"  => Y <= I2;
            when "011"  => Y <= I3;
            when "100"  => Y <= I4;
            when "101"  => Y <= I5;
            when "110"  => Y <= I6;
            when "111"  => Y <= I7;
            when others => Y <= (others => '0');
        end case;
    end process;
end Behavioral;
