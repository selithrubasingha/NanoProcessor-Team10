library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_instruction_decoder is
-- Testbench has no ports
end tb_instruction_decoder;

architecture Behavioral of tb_instruction_decoder is

    -- Component Declaration
    component instruction_decoder
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
            WB_sel      : out STD_LOGIC_VECTOR(1 downto 0);
            JumpFlag    : out STD_LOGIC;
            JumpAddr    : out STD_LOGIC_VECTOR(2 downto 0);
            
            StackWrite  : out STD_LOGIC;
            StackRead   : out STD_LOGIC;
            SP_inc      : out STD_LOGIC;
            SP_dec      : out STD_LOGIC
        );
    end component;

    -- Inputs
    signal Instruction : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
    signal Zero        : STD_LOGIC := '0';
    signal Negative    : STD_LOGIC := '0';
    signal StackFull   : STD_LOGIC := '0';
    signal StackEmpty  : STD_LOGIC := '0';

    -- Outputs
    signal RegSel      : STD_LOGIC_VECTOR(2 downto 0);
    signal RegEn       : STD_LOGIC;
    signal MuxA_Sel    : STD_LOGIC_VECTOR(2 downto 0);
    signal MuxB_Sel    : STD_LOGIC_VECTOR(2 downto 0);
    signal ALUop       : STD_LOGIC_VECTOR(3 downto 0);
    signal ImmVal      : STD_LOGIC_VECTOR(3 downto 0);
    signal WB_sel      : STD_LOGIC_VECTOR(1 downto 0);
    signal JumpFlag    : STD_LOGIC;
    signal JumpAddr    : STD_LOGIC_VECTOR(2 downto 0);
    signal StackWrite  : STD_LOGIC;
    signal StackRead   : STD_LOGIC;
    signal SP_inc      : STD_LOGIC;
    signal SP_dec      : STD_LOGIC;

begin

    -- Instantiate the UUT
    uut: instruction_decoder Port map (
        Instruction => Instruction,
        Zero => Zero,
        Negative => Negative,
        StackFull => StackFull,
        StackEmpty => StackEmpty,
        RegSel => RegSel,
        RegEn => RegEn,
        MuxA_Sel => MuxA_Sel,
        MuxB_Sel => MuxB_Sel,
        ALUop => ALUop,
        ImmVal => ImmVal,
        WB_sel => WB_sel,
        JumpFlag => JumpFlag,
        JumpAddr => JumpAddr,
        StackWrite => StackWrite,
        StackRead => StackRead,
        SP_inc => SP_inc,
        SP_dec => SP_dec
    );

    -- Stimulus process
    stim_proc: process
    begin		
        -- Case 1: MOVI R1, 5
        -- Opcode: 10, Mode: 0, Reg: 001, Value: 0101
        Instruction <= "100010000101";
        wait for 100 ns;

        -- Case 2: ADD R1, R2
        -- Opcode: 00, RegDest: 001, RegSrc: 010, ALUop: 0000
        Instruction <= "000010100000";
        wait for 100 ns;

        -- Case 3: PUSH R7 (Assuming Stack is NOT Full)
        -- Opcode: 10, Mode: 1 (Stack), Subop: 00 (Push), Reg: 111
        StackFull <= '0';
        Instruction <= "101111100000";
        wait for 100 ns;

        -- Case 4: PUSH R7 (But Stack IS Full)
        -- Expected: StackWrite and SP_inc should stay '0'
        StackFull <= '1';
        wait for 100 ns;

        -- Case 5: POP R1 (Assuming Stack is NOT Empty)
        -- Opcode: 10, Mode: 1, Subop: 01 (Pop), Reg: 001
        StackFull <= '0'; -- Clear full flag
        StackEmpty <= '0';
        Instruction <= "100011100000"; -- Changed subop to POP
        wait for 100 ns;

        -- Case 6: JZR R0, 3 (When Zero is '1')
        -- Opcode: 11, JumpAddr: 011
        Instruction <= "110000000011";
        Zero <= '1';
        wait for 100 ns;

        -- Case 7: JZR R0, 3 (When Zero is '0')
        -- Expected: JumpFlag should go to '0'
        Zero <= '0';
        wait for 100 ns;

        wait;
    end process;

end Behavioral;