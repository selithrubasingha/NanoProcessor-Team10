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
        AddSub      : out STD_LOGIC;
        ImmVal      : out STD_LOGIC_VECTOR(3 downto 0);
        ImmMuxSel   : out STD_LOGIC;
        JumpFlag    : out STD_LOGIC;
        JumpAddr    : out STD_LOGIC_VECTOR(2 downto 0)
    );
end instruction_decoder;

architecture Behavioral of instruction_decoder is

    signal isALU  : STD_LOGIC;
    signal isNEG  : STD_LOGIC;
    signal isMOVI : STD_LOGIC;
    signal isJZR  : STD_LOGIC;

begin

    -- Basic field extraction

    RegSel   <= Instruction(9 downto 7);
    ImmVal   <= Instruction(3 downto 0);
    JumpAddr <= Instruction(2 downto 0);


    -- Opcode decoding

    isALU  <= NOT Instruction(11) AND NOT Instruction(10); -- 00
    isNEG  <= NOT Instruction(11) AND Instruction(10);     -- 01
    isMOVI <= Instruction(11) AND NOT Instruction(10);     -- 10
    isJZR  <= Instruction(11) AND Instruction(10);         -- 11


    -- ALU control (ADD / AND)

    AddSub <= '1' when isNEG = '1' else 
            Instruction(0) when isALU = '1' else 
            '0';    -- 0 = ADD, 1 = AND

    -- Register enable

    RegEn <= isALU OR isNEG OR isMOVI;


    -- Immediate handling

    ImmMuxSel <= isMOVI;

    -- Jump control
-- Jump control (Bit 3 = '0' for JZR, Bit 3 = '1' for JNEG)

    JumpFlag <= isJZR AND ( (Zero AND NOT Instruction(3)) OR (Negative AND Instruction(3)) );

    -- Mux A selection
    -- If NEG, force MuxA to R0 (0). Otherwise, use RegSel (Dest).
    MuxA_Sel <= "000" when isNEG = '1' else Instruction(9 downto 7);

    -- Mux B selection
    -- If NEG, force MuxB to the register we want to negate (RegSel). 
    -- Otherwise, use the standard Source field (Instruction 6 downto 4).
    MuxB_Sel <= Instruction(9 downto 7) when isNEG = '1' else Instruction(6 downto 4);

end Behavioral;
