----------------------------------------------------------------------------------

-- Engineer: Thiseni Rathnayake

-- Module Name: D_FF - Behavioral


----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity d_flip_flop is
   Port ( D : in STD_LOGIC;
        Clk : in  STD_LOGIC;
        Reset : in  STD_LOGIC;
        Enable : in  STD_LOGIC;
        Q : out STD_LOGIC );
end d_flip_flop;

architecture Behavioral of d_flip_flop is
begin
    process(Clk, Reset)
    begin
        if Reset = '1' then
            Q <= '0';
        elsif rising_edge(Clk) then
            if Enable = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end Behavioral;

