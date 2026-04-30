library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instruction_decoder is
    Port (
        Instruction : in  STD_LOGIC_VECTOR(11 downto 0);
        Zero        : in  STD_LOGIC;
        RegSel      : out STD_LOGIC_VECTOR(2 downto 0);
        RegEn       : out STD_LOGIC;
        MuxA_Sel    : out STD_LOGIC_VECTOR(2 downto 0);
        MuxB_Sel    : out STD_LOGIC_VECTOR(2 downto 0);
        AddSub      : out STD_LOGIC;
        ImmVal      : out STD_LOGIC_VECTOR(3 downto 0);
        ImmMuxSel   : out STD_LOGIC;
        JumpFlag    : out STD_LOGIC;
        JumpAddr    : out STD_LOGIC_VECTOR(2 downto 0)
    );
end instruction_decoder;

architecture Behavioral of instruction_decoder is
    signal isADD : STD_LOGIC;

begin
    RegSel   <= Instruction(9 downto 7);
    AddSub   <= Instruction(10);
    ImmVal   <= Instruction(3 downto 0);
    JumpAddr <= Instruction(2 downto 0);

    isADD <= NOT Instruction(11) AND NOT Instruction(10);

    RegEn     <= NOT (Instruction(11) AND Instruction(10));
    ImmMuxSel <= Instruction(11) AND NOT Instruction(10);
    JumpFlag  <= Zero AND Instruction(11) AND Instruction(10);

    MuxA_Sel <= Instruction(9 downto 7) when isADD = '1' else "000";

    MuxB_Sel(0) <= (Instruction(4) AND isADD) OR (Instruction(7) AND Instruction(10));
    MuxB_Sel(1) <= (Instruction(5) AND isADD) OR (Instruction(8) AND Instruction(10));
    MuxB_Sel(2) <= (Instruction(6) AND isADD) OR (Instruction(9) AND Instruction(10));

end Behavioral;