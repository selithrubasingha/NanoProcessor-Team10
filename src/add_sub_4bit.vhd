library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Required for arithmetic

entity add_sub_4bit is
    Port (
        A        : in  STD_LOGIC_VECTOR(3 downto 0);
        B        : in  STD_LOGIC_VECTOR(3 downto 0);
        AddSub   : in  STD_LOGIC;
        Result   : out STD_LOGIC_VECTOR(3 downto 0);
        Overflow : out STD_LOGIC;
        Zero     : out STD_LOGIC
    );
end add_sub_4bit;

architecture Behavioral of add_sub_4bit is
    signal a_ext, b_ext, res_ext : signed(4 downto 0);
begin
    -- Convert to signed and extend to 5 bits to detect overflow/carry
    a_ext <= signed('0' & A);
    b_ext <= signed('0' & B);

    process(a_ext, b_ext, AddSub)
    begin
        if AddSub = '0' then
            res_ext <= a_ext + b_ext;
        else
            res_ext <= a_ext - b_ext;
        end if;
    end process;

    Result <= std_logic_vector(res_ext(3 downto 0));
    Zero   <= '1' when res_ext(3 downto 0) = "0000" else '0';
    
    -- Overflow detection (simplified for Vivado optimization)
    Overflow <= res_ext(4); 
end Behavioral;