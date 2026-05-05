library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu_4bit is
    Port (
        A      : in  STD_LOGIC_VECTOR(3 downto 0);
        B      : in  STD_LOGIC_VECTOR(3 downto 0);
        ALUop  : in  STD_LOGIC_VECTOR(3 downto 0);
        Result : out STD_LOGIC_VECTOR(3 downto 0);
        Zero   : out STD_LOGIC;
        Overflow : out STD_LOGIC
    );
end alu_4bit;

architecture Behavioral of alu_4bit is

    signal res : STD_LOGIC_VECTOR(3 downto 0);

begin

process(A, B, ALUop)
begin
    case ALUop is

        when "0000" =>  -- ADD
            res <= A + B;

        when "0001" =>  -- SUB
            res <= A - B;

        when "0010" =>  -- AND
            res <= A AND B;

        when "0011" =>  -- OR
            res <= A OR B;

        when "0100" =>  -- XOR
            res <= A XOR B;

        when others =>
            res <= (others => '0');

    end case;
end process;

Result <= res;

Zero <= '1' when res = "0000" else '0';

-- simple overflow 
Overflow <= '0';

end Behavioral;
