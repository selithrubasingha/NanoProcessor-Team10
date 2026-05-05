library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity instruction_decoder is
    Port (
        Instruction : in  STD_LOGIC_VECTOR(11 downto 0);
        Zero        : in  STD_LOGIC;
        Negative    : in  STD_LOGIC;  -- NEW WIRE ADDED HERE

        RegSel      : out STD_LOGIC_VECTOR(2 downto 0);
        RegEn       : out STD_LOGIC;

        MuxA_Sel    : out STD_LOGIC_VECTOR(2 downto 0);
        MuxB_Sel    : out STD_LOGIC_VECTOR(2 downto 0);

        ALUop       : out STD_LOGIC_VECTOR(3 downto 0);

        ImmVal      : out STD_LOGIC_VECTOR(3 downto 0);
        ImmMuxSel   : out STD_LOGIC;

        JumpFlag    : out STD_LOGIC;
        JumpAddr    : out STD_LOGIC_VECTOR(2 downto 0)
    );
end instruction_decoder;

architecture Behavioral of instruction_decoder is

    signal I11, I10 : STD_LOGIC;
    signal nI11, nI10 : STD_LOGIC;

    signal isALU, isNEG, isMOVI, isJZR : STD_LOGIC;

begin
    I11 <= Instruction(11);
    I10 <= Instruction(10);

    nI11 <= NOT I11;
    nI10 <= NOT I10;

    isALU  <= nI11 AND nI10;   -- 00
    isNEG  <= nI11 AND I10;    -- 01
    isMOVI <= I11 AND nI10;    -- 10
    isJZR  <= I11 AND I10;     -- 11

    RegSel   <= Instruction(9 downto 7);
    ImmVal   <= Instruction(3 downto 0);
    JumpAddr <= Instruction(2 downto 0);

    RegEn <= isALU OR isNEG OR isMOVI;

    MuxA_Sel(0) <= Instruction(7) AND isALU;
    MuxA_Sel(1) <= Instruction(8) AND isALU;
    MuxA_Sel(2) <= Instruction(9) AND isALU;

    MuxB_Sel(0) <= (Instruction(4) AND isALU) OR (Instruction(7) AND (isNEG OR isJZR));
    MuxB_Sel(1) <= (Instruction(5) AND isALU) OR (Instruction(8) AND (isNEG OR isJZR));
    MuxB_Sel(2) <= (Instruction(6) AND isALU) OR (Instruction(9) AND (isNEG OR isJZR));

    ALUop(0) <= (Instruction(0) AND isALU) OR isNEG;
    ALUop(1) <= Instruction(1) AND isALU;
    ALUop(2) <= Instruction(2) AND isALU;
    ALUop(3) <= Instruction(3) AND isALU;

    ImmMuxSel <= isMOVI;

    JumpFlag <= isJZR AND (
                    (Zero AND (NOT Instruction(3))) OR
                    (Negative AND Instruction(3))
                 );

end Behavioral;