
-- register_bank.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_bank is
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
end register_bank;

architecture Structural of register_bank is


    component decoder_3to8
        port (
            A : in  STD_LOGIC_VECTOR(2 downto 0);
            Y : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component register_4bit
        port (
            D      : in  STD_LOGIC_VECTOR(3 downto 0);
            Clk    : in  STD_LOGIC;
            Reset  : in  STD_LOGIC;
            Enable : in  STD_LOGIC;
            Q      : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;


    signal DecoderOut : STD_LOGIC_VECTOR(7 downto 0);
    signal EnableVec  : STD_LOGIC_VECTOR(7 downto 0);

begin

    DEC : decoder_3to8
        port map (
            A => RegSel,
            Y => DecoderOut
        );


    EnableVec(0) <= '0';                       
    EnableVec(1) <= DecoderOut(1) AND RegEn;
    EnableVec(2) <= DecoderOut(2) AND RegEn;
    EnableVec(3) <= DecoderOut(3) AND RegEn;
    EnableVec(4) <= DecoderOut(4) AND RegEn;
    EnableVec(5) <= DecoderOut(5) AND RegEn;
    EnableVec(6) <= DecoderOut(6) AND RegEn;
    EnableVec(7) <= DecoderOut(7) AND RegEn;


    R0 <= "0000";


    REG1 : register_4bit port map (D, Clk, Reset, EnableVec(1), R1);
    REG2 : register_4bit port map (D, Clk, Reset, EnableVec(2), R2);
    REG3 : register_4bit port map (D, Clk, Reset, EnableVec(3), R3);
    REG4 : register_4bit port map (D, Clk, Reset, EnableVec(4), R4);
    REG5 : register_4bit port map (D, Clk, Reset, EnableVec(5), R5);
    REG6 : register_4bit port map (D, Clk, Reset, EnableVec(6), R6);
    REG7 : register_4bit port map (D, Clk, Reset, EnableVec(7), R7);

end Structural;
