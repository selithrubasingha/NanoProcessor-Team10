library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity instruction_decoder is
    Port (
        Instruction : in  STD_LOGIC_VECTOR(11 downto 0);
        Zero        : in  STD_LOGIC;
        Negative    : in  STD_LOGIC;
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

    -- Basic field extraction
    opcode   <= Instruction(11 downto 10);
    RegSel   <= Instruction(9 downto 7);
    ImmVal   <= Instruction(3 downto 0);
    JumpAddr <= Instruction(2 downto 0); -- RESTORED!

    -- Opcode decoding
    isALU  <= '1' when opcode = "00" else '0';
    isNEG  <= '1' when opcode = "01" else '0';
    isMOVI <= '1' when opcode = "10" else '0';
    isJZR  <= '1' when opcode = "11" else '0';

    -- Register enable
    RegEn <= isALU OR isNEG OR isMOVI;

    -- ALU operation (New ALU features)
    --  0000=ADD  0001=SUB  0010=AND  0011=OR  0100=XOR
    ALUop <= Instruction(3 downto 0) when isALU = '1' else
             "0001"                  when isNEG = '1' else
             "0000";

    -- Immediate handling
    ImmMuxSel <= isMOVI;

    -- Jump control (Bit 3 = '0' for JZR, Bit 3 = '1' for JNEG)
    JumpFlag <= isJZR AND ( (Zero AND NOT Instruction(3)) OR (Negative AND Instruction(3)) );

    -- Mux A selection
    -- If NEG, force MuxA to R0 (0). Otherwise, use RegSel (Dest).
    MuxA_Sel <= "000" when isNEG = '1' else Instruction(9 downto 7);

    -- Mux B selection
    -- If NEG or JZR, force MuxB to the register we want to check/negate (RegSel). 
    -- Otherwise, use the standard Source field (Instruction 6 downto 4).
    MuxB_Sel <= Instruction(9 downto 7) when isNEG = '1' else 
                Instruction(9 downto 7) when isJZR = '1' else 
                Instruction(6 downto 4);

end Behavioral;
