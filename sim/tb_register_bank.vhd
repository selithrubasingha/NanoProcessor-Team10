library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_register_bank is
end tb_register_bank;

architecture Behavioral of tb_register_bank is

    -- Component Declaration
    component register_bank
        Port (
            D      : in  STD_LOGIC_VECTOR(3 downto 0);
            RegSel : in  STD_LOGIC_VECTOR(2 downto 0);
            RegEn  : in  STD_LOGIC;
            Clk    : in  STD_LOGIC;
            Reset  : in  STD_LOGIC;
            R0     : out STD_LOGIC_VECTOR(3 downto 0);
            R1     : out STD_LOGIC_VECTOR(3 downto 0);
            R2     : out STD_LOGIC_VECTOR(3 downto 0);
            R3     : out STD_LOGIC_VECTOR(3 downto 0);
            R4     : out STD_LOGIC_VECTOR(3 downto 0);
            R5     : out STD_LOGIC_VECTOR(3 downto 0);
            R6     : out STD_LOGIC_VECTOR(3 downto 0);
            R7     : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    -- Test Signals
    signal D_TB      : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal RegSel_TB : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal RegEn_TB  : STD_LOGIC := '0';
    signal Clk_TB    : STD_LOGIC := '0';
    signal Reset_TB  : STD_LOGIC := '0';

    signal R0_TB, R1_TB, R2_TB, R3_TB,
           R4_TB, R5_TB, R6_TB, R7_TB : STD_LOGIC_VECTOR(3 downto 0);

    constant Clock_Period : time := 100 ns;

begin

    -- Instantiate UUT
    UUT: register_bank
        port map (
            D      => D_TB,
            RegSel => RegSel_TB,
            RegEn  => RegEn_TB,
            Clk    => Clk_TB,
            Reset  => Reset_TB,
            R0     => R0_TB,
            R1     => R1_TB,
            R2     => R2_TB,
            R3     => R3_TB,
            R4     => R4_TB,
            R5     => R5_TB,
            R6     => R6_TB,
            R7     => R7_TB
        );

    -- Clock process
    Clock_process: process
    begin
        while now < 1200 ns loop
            Clk_TB <= '0';
            wait for Clock_Period/2;
            Clk_TB <= '1';
            wait for Clock_Period/2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    Stim_process: process
    begin

        -- RESET
        Reset_TB <= '1';
        wait for Clock_Period;
        Reset_TB <= '0';

        -- Enable writing
        RegEn_TB <= '1';

        -- R1
        wait until falling_edge(Clk_TB);
        RegSel_TB <= "001";
        D_TB <= "0101";
        wait for Clock_Period;

        -- R2
        wait until falling_edge(Clk_TB);
        RegSel_TB <= "010";
        D_TB <= "1010";
        wait for Clock_Period;

        -- R3
        wait until falling_edge(Clk_TB);
        RegSel_TB <= "011";
        D_TB <= "1111";
        wait for Clock_Period;

        -- R4
        wait until falling_edge(Clk_TB);
        RegSel_TB <= "100";
        D_TB <= "0011";
        wait for Clock_Period;

        -- R5
        wait until falling_edge(Clk_TB);
        RegSel_TB <= "101";
        D_TB <= "0111";
        wait for Clock_Period;

        -- R6
        wait until falling_edge(Clk_TB);
        RegSel_TB <= "110";
        D_TB <= "1001";
        wait for Clock_Period;

        -- R7
        wait until falling_edge(Clk_TB);
        RegSel_TB <= "111";
        D_TB <= "1100";
        wait for Clock_Period;

       
        wait until falling_edge(Clk_TB);
        RegSel_TB <= "000";
        D_TB <= "1111";
        wait for Clock_Period;

  
        wait until falling_edge(Clk_TB);
        Reset_TB <= '1';
        wait for Clock_Period;
        Reset_TB <= '0';

        wait;
    end process;

end Behavioral;
