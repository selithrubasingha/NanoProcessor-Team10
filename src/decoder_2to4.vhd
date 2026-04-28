library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_2to4 is
    Port ( I : in STD_LOGIC_VECTOR (1 downto 0);
           EN : in STD_LOGIC;
           Y : out STD_LOGIC_VECTOR (3 downto 0));
end decoder_2to4;

architecture Behavioral of decoder_2to4 is
begin
    process(I, EN)
    begin
        Y <= "0000"; 
        
        if EN = '1' then
            case I is
                when "00" => Y <= "0001";
                when "01" => Y <= "0010";
                when "10" => Y <= "0100";
                when "11" => Y <= "1000";
                when others => Y <= "0000";
            end case;
        end if;
    end process;
end Behavioral;