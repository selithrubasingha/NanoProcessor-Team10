library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instruction_decoder is
    Port (
        Instruction : in  STD_LOGIC_VECTOR(11 downto 0);
        Zero        : in  STD_LOGIC;
        Negative    : in  STD_LOGIC;
        StackFull   : in  STD_LOGIC;
        StackEmpty  : in  STD_LOGIC;

        RegSel      : out STD_LOGIC_VECTOR(2 downto 0);
        RegEn       : out STD_LOGIC;
        MuxA_Sel    : out STD_LOGIC_VECTOR(2 downto 0);
        MuxB_Sel    : out STD_LOGIC_VECTOR(2 downto 0);
        ALUop       : out STD_LOGIC_VECTOR(3 downto 0);
        ImmVal      : out STD_LOGIC_VECTOR(3 downto 0);
        WB_sel      : out STD_LOGIC_VECTOR(1 downto 0); -- 00=ALU, 01=IMM, 10=STACK
        JumpFlag    : out STD_LOGIC;
        JumpAddr    : out STD_LOGIC_VECTOR(2 downto 0);
        
        StackWrite  : out STD_LOGIC;
        StackRead   : out STD_LOGIC;
        SP_inc      : out STD_LOGIC;
        SP_dec      : out STD_LOGIC
    );
end instruction_decoder;

architecture GateLevel of instruction_decoder is
    signal I11, I10, I6, I5, I4, I3 : STD_LOGIC;
    signal nI11, nI10, nI6, nI5, nI4, nI3 : STD_LOGIC;

    signal isALU, isNEG, isMOVI, isSTACK, isJZR : STD_LOGIC;
    signal isPUSH, isPOP : STD_LOGIC;
    signal validPUSH, validPOP : STD_LOGIC;
begin
    I11 <= Instruction(11);  nI11 <= NOT Instruction(11);
    I10 <= Instruction(10);  nI10 <= NOT Instruction(10);
    I6  <= Instruction(6);   nI6  <= NOT Instruction(6);
    I5  <= Instruction(5);   nI5  <= NOT Instruction(5);
    I4  <= Instruction(4);   nI4  <= NOT Instruction(4);
    I3  <= Instruction(3);   nI3  <= NOT Instruction(3);

    isALU   <= nI11 AND nI10;
    isNEG   <= nI11 AND I10;
    isMOVI  <= I11 AND nI10 AND nI6;         -- opcode 10, mode 0
    isSTACK <= I11 AND nI10 AND I6;          -- opcode 10, mode 1
    isJZR   <= I11 AND I10;

    isPUSH  <= isSTACK AND nI5 AND nI4;      -- subop 00
    isPOP   <= isSTACK AND nI5 AND I4;       -- subop 01

    validPUSH <= isPUSH AND (NOT StackFull);
    validPOP  <= isPOP AND (NOT StackEmpty);

    RegSel   <= Instruction(9 downto 7);
    RegEn    <= isALU OR isNEG OR isMOVI OR validPOP;

    WB_sel(1) <= validPOP;
    WB_sel(0) <= isMOVI;

    MuxA_Sel(0) <= Instruction(7) AND (isALU OR isPUSH);
    MuxA_Sel(1) <= Instruction(8) AND (isALU OR isPUSH);
    MuxA_Sel(2) <= Instruction(9) AND (isALU OR isPUSH);

    MuxB_Sel(0) <= (Instruction(4) AND isALU) OR (Instruction(7) AND (isNEG OR isJZR));
    MuxB_Sel(1) <= (Instruction(5) AND isALU) OR (Instruction(8) AND (isNEG OR isJZR));
    MuxB_Sel(2) <= (Instruction(6) AND isALU) OR (Instruction(9) AND (isNEG OR isJZR));

    ALUop(0) <= (Instruction(0) AND isALU) OR isNEG;
    ALUop(1) <= Instruction(1) AND isALU;
    ALUop(2) <= Instruction(2) AND isALU;
    ALUop(3) <= Instruction(3) AND isALU;

    ImmVal   <= Instruction(3 downto 0);

    JumpFlag <= isJZR AND ( (Zero AND nI3) OR (Negative AND I3) );
    JumpAddr <= Instruction(2 downto 0);

    StackWrite <= validPUSH;
    StackRead  <= validPOP;
    SP_inc     <= validPUSH;
    SP_dec     <= validPOP;

end GateLevel;
