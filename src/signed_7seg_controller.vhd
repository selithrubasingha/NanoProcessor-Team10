library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Signed_7Seg_Controller is
    Port (
        Clk         : in  STD_LOGIC;
        Reset       : in  STD_LOGIC;
        Reg_Data    : in  STD_LOGIC_VECTOR (3 downto 0); -- Input from R7
        SevenSeg    : out STD_LOGIC_VECTOR (6 downto 0); -- To Basys 3 Segments
        Anode       : out STD_LOGIC_VECTOR (3 downto 0)  -- To Basys 3 Anodes
    );
end Signed_7Seg_Controller;

architecture Behavioral of Signed_7Seg_Controller is

    -- Component Declaration of your existing ROM
    component sevenseg_rom
        port (
            address : in std_logic_vector (3 downto 0);
            data : out std_logic_vector (6 downto 0)
        );
    end component;

    signal abs_val      : std_logic_vector(3 downto 0);
    signal rom_address  : std_logic_vector(3 downto 0);
    signal refresh_cnt  : unsigned(16 downto 0) := (others => '0');
    signal display_sel  : std_logic;

begin

    -- 1. Logic for Magnitude: 2's complement negation if negative
    abs_val <= std_logic_vector(unsigned(not Reg_Data) + 1) when Reg_Data(3) = '1' else Reg_Data;

    -- 2. Refresh Counter for Multiplexing digits
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

    display_sel <= refresh_cnt(16); -- Toggle bit for switching digits

    -- 3. Logic for Sign and Anode Control
    process(display_sel, Reg_Data, abs_val)
    begin
        case display_sel is
            when '0' =>
                Anode <= "1110";         -- Enable Rightmost Digit
                rom_address <= abs_val;  -- Show Magnitude
            when '1' =>
                Anode <= "1101";         -- Enable Second Digit
                if Reg_Data(3) = '1' then
                    rom_address <= "1010"; -- Custom Index for '-' in ROM
                else
                    rom_address <= "1011"; -- Custom Index for Blank in ROM
                end if;
            when others =>
                Anode <= "1111";
        end case;
    end process;

    -- 4. Instantiate the ROM
    ROM_Inst : sevenseg_rom
        port map (
            address => rom_address,
            data => SevenSeg
        );

end Behavioral;