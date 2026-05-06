library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_program_rom is
end tb_program_rom;

architecture Behavioral of tb_program_rom is

    -- Component declaration
    component program_rom
        Port (
            Addr        : in  STD_LOGIC_VECTOR(2 downto 0);
            Instruction : out STD_LOGIC_VECTOR(11 downto 0)
        );
    end component;

    -- Signals
    signal Addr        : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal Instruction : STD_LOGIC_VECTOR(11 downto 0);

begin

    -- Instantiate the ROM
    uut: program_rom
        port map (
            Addr => Addr,
            Instruction => Instruction
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Loop through all addresses
        Addr <= "000"; wait for 10 ns;
        Addr <= "001"; wait for 10 ns;
        Addr <= "010"; wait for 10 ns;
        Addr <= "011"; wait for 10 ns;
        Addr <= "100"; wait for 10 ns;
        Addr <= "101"; wait for 10 ns;
        Addr <= "110"; wait for 10 ns;
        Addr <= "111"; wait for 10 ns;

        wait; -- stop simulation
    end process;

end Behavioral;
