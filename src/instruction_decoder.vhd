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

        ALUop       : out STD_LOGIC_VECTOR(3 downto 0);

        ImmVal      : out STD_LOGIC_VECTOR(3 downto 0);
        ImmMuxSel   : out STD_LOGIC;

        JumpFlag    : out STD_LOGIC;
        JumpAddr    : out STD_LOGIC_VECTOR(2 downto 0)
    );
end instruction_decoder;

architecture Behavioral of instruction_decoder is

    signal opcode : STD_LOGIC_VECTOR(1 downto 0);
    signal isALU  : STD_LOGIC;
    signal isMOVI : STD_LOGIC;
    signal isJZR  : STD_LOGIC;

begin

    opcode <= Instruction(11 downto 10);

    isALU  <= '1' when opcode = "00" else '0';
    isMOVI <= '1' when opcode = "10" else '0';
    isJZR  <= '1' when opcode = "11" else '0';

    -- Register selection
    RegSel <= Instruction(9 downto 7);

    -- ALU operation (ONLY when ALU instruction)
    ALUop <= Instruction(3 downto 0) when isALU = '1'
             else "0000";

    -- MOVI immediate
    ImmVal <= Instruction(3 downto 0);

    -- Write enable
    RegEn <= '1' when (isALU = '1' or isMOVI = '1')
             else '0';

    -- ALU operands
    MuxA_Sel <= Instruction(9 downto 7) when isALU = '1' else "000";
    MuxB_Sel <= Instruction(6 downto 4) when isALU = '1' else "000";

    -- MOVI control
    ImmMuxSel <= isMOVI;

    -- JZR
    JumpAddr <= Instruction(2 downto 0);

    JumpFlag <= '1' when (isJZR = '1' and Zero = '1')
                else '0';

end Behavioral;
