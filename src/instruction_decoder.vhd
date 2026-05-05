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

    signal opcode : STD_LOGIC_VECTOR(1 downto 0);
    signal isALU  : STD_LOGIC;
    signal isNEG  : STD_LOGIC;
    signal isMOVI : STD_LOGIC;
    signal isJZR  : STD_LOGIC;

begin

    opcode <= Instruction(11 downto 10);

    isALU  <= '1' when opcode = "00" else '0';
    isNEG  <= '1' when opcode = "01" else '0';
    isMOVI <= '1' when opcode = "10" else '0';
    isJZR  <= '1' when opcode = "11" else '0';

    -- Destination / source register field [9:7]
    RegSel <= Instruction(9 downto 7);

    -- Write enable: ALU, NEG, and MOVI all write back; JZR does not
    RegEn <= '1' when (isALU = '1' or isNEG = '1' or isMOVI = '1')
             else '0';

    -- ALU input A:
    --   ALU  -> Ra (bits[9:7])
    --   NEG  -> R0 (hardwired 0) so result = 0 - R = -R
    --   JZR  -> R0 so ALU computes 0 - R to produce the Zero flag
    --   MOVI -> don't-care ("000")
    MuxA_Sel <= Instruction(9 downto 7) when isALU = '1'
                else "000";

    -- ALU input B:
    --   ALU  -> Rb (bits[6:4])
    --   NEG  -> R  (bits[9:7])
    --   JZR  -> R  (bits[9:7])
    --   MOVI -> don't-care ("000")
    MuxB_Sel <= Instruction(6 downto 4) when isALU = '1' else
                Instruction(9 downto 7) when isNEG = '1' else
                Instruction(9 downto 7) when isJZR = '1' else
                "000";

    -- ALU operation:
    --   ALU  -> encoded in instruction bits[3:0]
    --  0000=ADD  0001=SUB  0010=AND  0011=OR  0100=XOR
    --   NEG  -> 0001 (SUB) to compute 0 - R
    --   others -> 0000 (result unused for MOVI/JZR)
    ALUop <= Instruction(3 downto 0) when isALU = '1' else
             "0001"                  when isNEG = '1' else
             "0000";

    -- MOVI immediate
    ImmVal    <= Instruction(3 downto 0);
    ImmMuxSel <= isMOVI;

    -- Jump control
-- Jump control (Bit 3 = '0' for JZR, Bit 3 = '1' for JNEG)

    JumpFlag <= isJZR AND ( (Zero AND NOT Instruction(3)) OR (Negative AND Instruction(3)) );

    -- Mux A selection

    MuxA_Sel <= Instruction(9 downto 7);

    -- Mux B selection

    MuxB_Sel <= Instruction(6 downto 4);

end Behavioral;
