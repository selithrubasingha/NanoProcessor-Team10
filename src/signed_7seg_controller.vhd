library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Signed_7Seg_Controller is
    Port (
        Clk         : in  STD_LOGIC; -- Fast 100MHz clock
        Reset       : in  STD_LOGIC;
        Reg_Data    : in  STD_LOGIC_VECTOR (3 downto 0); -- Input from R7
        SevenSeg    : out STD_LOGIC_VECTOR (6 downto 0); 
        Anode       : out STD_LOGIC_VECTOR (3 downto 0)  
    );
end Signed_7Seg_Controller;

architecture Behavioral of Signed_7Seg_Controller is

    -- UPDATED: address must be 5 bits to reach indices 16 and 17
    component sevenseg_rom
        port (
            address : in std_logic_vector (4 downto 0); 
            data    : out std_logic_vector (6 downto 0)
        );
    end component;

    signal abs_val      : std_logic_vector(3 downto 0);
    signal rom_address  : std_logic_vector(4 downto 0); -- UPDATED to 5 bits
    signal refresh_cnt  : unsigned(16 downto 0) := (others => '0');
    signal display_sel  : std_logic;

begin

    -- 1. Magnitude Logic (2's complement absolute value)
    abs_val <= std_logic_vector(unsigned(not Reg_Data) + 1) when Reg_Data(3) = '1' else Reg_Data;

    -- 2. Refresh Counter for Multiplexing
    process(Clk)
    begin
        if rising_edge(Clk) then
            if Reset = '1' then
                refresh_cnt <= (others => '0');
            else
                refresh_cnt <= refresh_cnt + 1;
            end if;
        end if;
    end process;

    -- Using bit 15 provides a faster refresh rate to reduce ghosting
    display_sel <= refresh_cnt(1); 

    -- 3. UPDATED: Logic for Sign and Anode Control[cite: 1, 2]
    process(display_sel, Reg_Data, abs_val)
    begin
        -- Default: All Anodes OFF (High) to prevent bleeding/ghosting[cite: 1]
        Anode <= "1111"; 
        
        case display_sel is
            when '0' =>
                Anode <= "1110";         -- Enable Digit 0 (Rightmost)
                rom_address <= "0" & abs_val; -- Map 4-bit mag to 5-bit address
                
            when '1' =>
                Anode <= "1101";         -- Enable Digit 1 (Sign digit)
                if Reg_Data(3) = '1' then
                    rom_address <= "10000"; -- Index 16: '-'[cite: 2]
                else
                    rom_address <= "10001"; -- Index 17: Blank[cite: 2]
                end if;
                
            when others =>
                Anode <= "1111";
        end case;
    end process;

    -- 4. Instantiate the ROM
    ROM_Inst : sevenseg_rom
        port map (
            address => rom_address,
            data    => SevenSeg
        );

end Behavioral;