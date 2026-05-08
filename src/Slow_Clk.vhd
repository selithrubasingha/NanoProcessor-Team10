 library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;

 entity Slow_Clk is
     Port ( Clk_in : in STD_LOGIC;
            Clk_out : out STD_LOGIC);
 end Slow_Clk;

-- architecture Behavioral of Slow_Clk is

-- signal count : integer := 1;
-- signal clk_status : std_logic :='0';

-- begin
--     -- For 100 MHz input clock this generates 1 Hz clock
--     process (Clk_in) begin
--         if (rising_edge(Clk_in)) then
--             count <= count + 1;               -- Increment counter
--             if (count = 50000000) then        -- Count 50M pulses (1/2 of period)
--                 clk_status <= not clk_status; -- Invert clock status
--                 Clk_out <= clk_status;
--                 count <= 1;                   -- Reset counter
--             end if;
--         end if;
--     end process;

-- end Behavioral;

architecture Behavioral of Slow_Clk is

signal count : integer := 1;
signal clk_status : std_logic :='0';

begin
    
    process (Clk_in) begin
        if (rising_edge(Clk_in)) then
            count <= count + 1;
            
            if (count = 2) then 
                clk_status <= not clk_status;
                Clk_out <= clk_status;
                count <= 1;
            end if;
        end if;
    end process;

end Behavioral;