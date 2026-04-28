library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_3to8 is
    Port ( A : in STD_LOGIC_VECTOR (2 downto 0);
           Y : out STD_LOGIC_VECTOR (7 downto 0));
end decoder_3to8;

architecture Structural of decoder_3to8 is
    
    component decoder_2to4
        Port ( I : in STD_LOGIC_VECTOR (1 downto 0);
               EN : in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    signal I_0, I_1 : STD_LOGIC_VECTOR (1 downto 0);
    signal Y0, Y1 : STD_LOGIC_VECTOR (3 downto 0);
    signal en0, en1 : STD_LOGIC;

begin
    
    Decoder_2_to_4_0: decoder_2to4 port map(
        I => I_0,
        EN => en0,
        Y => Y0
    );

    Decoder_2_to_4_1: decoder_2to4 port map(
        I => I_1,
        EN => en1,
        Y => Y1
    );

    -- Internal enable logic derived from the MSB, no external EN port needed
    en0 <= not A(2);
    en1 <= A(2);
    
    I_0 <= A(1 downto 0);
    I_1 <= A(1 downto 0);
    
    Y(3 downto 0) <= Y0;
    Y(7 downto 4) <= Y1;

end Structural;