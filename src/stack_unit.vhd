library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity stack_unit is
    Port (
        Clk         : in  STD_LOGIC;
        Reset       : in  STD_LOGIC;
        DataIn      : in  STD_LOGIC_VECTOR(3 downto 0);
        DataOut     : out STD_LOGIC_VECTOR(3 downto 0);
        StackWrite  : in  STD_LOGIC;
        SP_inc      : in  STD_LOGIC;
        SP_dec      : in  STD_LOGIC;
        StackFull   : out STD_LOGIC;
        StackEmpty  : out STD_LOGIC
    );
end stack_unit;

architecture Behavioral of stack_unit is
    type stack_type is array (0 to 7) of STD_LOGIC_VECTOR(3 downto 0);
    signal stack_mem : stack_type := (others => "0000");
    signal sp_reg    : unsigned(2 downto 0) := "000";
    
    signal sp_minus_1 : unsigned(2 downto 0);
begin
    StackFull  <= '1' when sp_reg = "111" else '0';
    StackEmpty <= '1' when sp_reg = "000" else '0';

    sp_minus_1 <= sp_reg - 1;
    DataOut <= stack_mem(to_integer(sp_minus_1));

    process(Clk)
    begin
        if rising_edge(Clk) then
            if Reset = '1' then
                sp_reg <= "000";
            else
                if StackWrite = '1' then
                    stack_mem(to_integer(sp_reg)) <= DataIn;
                end if;

                if SP_inc = '1' then
                    sp_reg <= sp_reg + 1;
                elsif SP_dec = '1' then
                    sp_reg <= sp_reg - 1;
                end if;
            end if;
        end if;
    end process;
end Behavioral;