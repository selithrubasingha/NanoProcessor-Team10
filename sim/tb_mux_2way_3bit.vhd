library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_mux_2way_3bit is

end tb_mux_2way_3bit;

architecture Behavioral of tb_mux_2way_3bit is

    component mux_2way_3bit
        Port (
            A   : in  STD_LOGIC_VECTOR(2 downto 0);
            B   : in  STD_LOGIC_VECTOR(2 downto 0);
            Sel : in  STD_LOGIC;
            Y   : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    -- Local signals to connect to the UUT
    signal A   : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal B   : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal Sel : STD_LOGIC := '0';
    signal Y   : STD_LOGIC_VECTOR(2 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: mux_2way_3bit
        port map (
            A   => A,
            B   => B,
            Sel => Sel,
            Y   => Y
        );

   
    stim_proc: process
    begin
        -- Case 1: Select A (PC + 1)
        -- Result should be "010"
        A <= "010"; 
        B <= "110";
        Sel <= '0';
        wait for 100 ns;

        -- Case 2: Select B (Jump Target)
        -- Result should be "110"
        Sel <= '1';
        wait for 100 ns;

        -- Case 3: Change Jump Target while Sel is '1'
        -- Result should change to "111"
        B <= "111";
        wait for 100 ns;

        -- Case 4: Switch back to A
        -- Result should be "010"
        Sel <= '0';
        wait for 100 ns;

        -- Stop simulation
        wait;
    end process;

end Behavioral;
