library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nanoprocessor is
    Port (
        Clk      : in  STD_LOGIC;
        Reset    : in  STD_LOGIC;
        R7_Out   : out STD_LOGIC_VECTOR(3 downto 0);
        Overflow : out STD_LOGIC;
        ZeroFlag : out STD_LOGIC;
        SevenSeg : out STD_LOGIC_VECTOR(6 downto 0);
        Anode    : out STD_LOGIC_VECTOR(3 downto 0)
    );
end nanoprocessor;

architecture Structural of nanoprocessor is

    signal InstructionBus : STD_LOGIC_VECTOR(11 downto 0);
    
    -- PC Signals
    signal PCAddr   : STD_LOGIC_VECTOR(2 downto 0);
    signal PCNext   : STD_LOGIC_VECTOR(2 downto 0);
    signal PCPlus1  : STD_LOGIC_VECTOR(2 downto 0);
    
    -- Datapath Signals
    signal DataBus    : STD_LOGIC_VECTOR(3 downto 0);
    signal MuxA_Out   : STD_LOGIC_VECTOR(3 downto 0);
    signal MuxB_Out   : STD_LOGIC_VECTOR(3 downto 0);
    signal ALU_Res    : STD_LOGIC_VECTOR(3 downto 0);
    signal ImmVal     : STD_LOGIC_VECTOR(3 downto 0);
    signal StackData  : STD_LOGIC_VECTOR(3 downto 0);
    
    -- Control & Flags
    signal ALU_Zero   : STD_LOGIC;
    signal ALU_Over   : STD_LOGIC;
    signal JumpFlag   : STD_LOGIC;
    signal RegEn      : STD_LOGIC;
    signal WB_sel     : STD_LOGIC_VECTOR(1 downto 0);
    signal RegSel     : STD_LOGIC_VECTOR(2 downto 0);
    signal MuxA_Sel   : STD_LOGIC_VECTOR(2 downto 0);
    signal MuxB_Sel   : STD_LOGIC_VECTOR(2 downto 0);
    signal JumpAddr   : STD_LOGIC_VECTOR(2 downto 0);
    signal ALUop_Sig  : STD_LOGIC_VECTOR(3 downto 0);
    
    -- Stack Signals
    signal SWrite : STD_LOGIC;
    signal SRead  : STD_LOGIC;
    signal SInc   : STD_LOGIC;
    signal SDec   : STD_LOGIC;
    signal SFull  : STD_LOGIC;
    signal SEmpty : STD_LOGIC;
    
    -- Register Outputs
    signal R0, R1, R2, R3, R4, R5, R6, R7 : STD_LOGIC_VECTOR(3 downto 0);

    component program_counter
        Port (
            NextAddr : in  STD_LOGIC_VECTOR(2 downto 0);
            Clk      : in  STD_LOGIC;
            Reset    : in  STD_LOGIC;
            CurrAddr : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    component program_rom
        Port (
            Addr        : in  STD_LOGIC_VECTOR(2 downto 0);
            Instruction : out STD_LOGIC_VECTOR(11 downto 0)
        );
    end component;

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

    component register_bank
        Port (
            D      : in  STD_LOGIC_VECTOR(3 downto 0);
            RegSel : in  STD_LOGIC_VECTOR(2 downto 0);
            RegEn  : in  STD_LOGIC;
            Clk    : in  STD_LOGIC;
            Reset  : in  STD_LOGIC;
            R0, R1, R2, R3, R4, R5, R6, R7 : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    component mux_8way_4bit
        Port (
            I0, I1, I2, I3, I4, I5, I6, I7 : in  STD_LOGIC_VECTOR(3 downto 0);
            Sel : in  STD_LOGIC_VECTOR(2 downto 0);
            Y   : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    component alu_4bit
        Port (
            A        : in  STD_LOGIC_VECTOR(3 downto 0);
            B        : in  STD_LOGIC_VECTOR(3 downto 0);
            ALUop    : in  STD_LOGIC_VECTOR(3 downto 0);
            Result   : out STD_LOGIC_VECTOR(3 downto 0);
            Overflow : out STD_LOGIC;
            Zero     : out STD_LOGIC
        );
    end component;

    component stack_unit
        Port (
            Clk        : in  STD_LOGIC;
            Reset      : in  STD_LOGIC;
            DataIn     : in  STD_LOGIC_VECTOR(3 downto 0);
            DataOut    : out STD_LOGIC_VECTOR(3 downto 0);
            StackWrite : in  STD_LOGIC;
            SP_inc     : in  STD_LOGIC;
            SP_dec     : in  STD_LOGIC;
            StackFull  : out STD_LOGIC;
            StackEmpty : out STD_LOGIC
        );
    end component;

    component mux_3way_4bit
        Port (
            A   : in  STD_LOGIC_VECTOR(3 downto 0);
            B   : in  STD_LOGIC_VECTOR(3 downto 0);
            C   : in  STD_LOGIC_VECTOR(3 downto 0);
            Sel : in  STD_LOGIC_VECTOR(1 downto 0);
            Y   : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    component adder_3bit
        Port (
            A   : in  STD_LOGIC_VECTOR(2 downto 0);
            B   : in  STD_LOGIC_VECTOR(2 downto 0);
            Sum : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    component mux_2way_3bit
        Port (
            A   : in  STD_LOGIC_VECTOR(2 downto 0);
            B   : in  STD_LOGIC_VECTOR(2 downto 0);
            Sel : in  STD_LOGIC;
            Y   : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    component sevenseg_rom
        Port (
            address : in  STD_LOGIC_VECTOR(3 downto 0);
            data    : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

begin

    PC : program_counter
        port map (
            NextAddr => PCNext,
            Clk      => Clk,
            Reset    => Reset,
            CurrAddr => PCAddr
        );

    ROM : program_rom
        port map (
            Addr        => PCAddr,
            Instruction => InstructionBus
        );

    DECODER : instruction_decoder
        port map (
            Instruction => InstructionBus,
            Zero        => ALU_Zero,
            Negative    => ALU_Res(3),
            StackFull   => SFull,
            StackEmpty  => SEmpty,
            RegSel      => RegSel,
            RegEn       => RegEn,
            MuxA_Sel    => MuxA_Sel,
            MuxB_Sel    => MuxB_Sel,
            ALUop       => ALUop_Sig,
            ImmVal      => ImmVal,
            WB_sel      => WB_sel,
            JumpFlag    => JumpFlag,
            JumpAddr    => JumpAddr,
            StackWrite  => SWrite,
            StackRead   => SRead,
            SP_inc      => SInc,
            SP_dec      => SDec
        );

    REGBANK : register_bank
        port map (
            D      => DataBus,
            RegSel => RegSel,
            RegEn  => RegEn,
            Clk    => Clk,
            Reset  => Reset,
            R0 => R0, R1 => R1, R2 => R2, R3 => R3,
            R4 => R4, R5 => R5, R6 => R6, R7 => R7
        );

    STACK : stack_unit
        port map (
            Clk        => Clk,
            Reset      => Reset,
            DataIn     => MuxA_Out,
            DataOut    => StackData,
            StackWrite => SWrite,
            SP_inc     => SInc,
            SP_dec     => SDec,
            StackFull  => SFull,
            StackEmpty => SEmpty
        );

    MUX_A : mux_8way_4bit
        port map (R0, R1, R2, R3, R4, R5, R6, R7, MuxA_Sel, MuxA_Out);

    MUX_B : mux_8way_4bit
        port map (R0, R1, R2, R3, R4, R5, R6, R7, MuxB_Sel, MuxB_Out);

    ALU_UNIT : alu_4bit
        port map (
            A        => MuxA_Out,
            B        => MuxB_Out,
            ALUop    => ALUop_Sig,
            Result   => ALU_Res,
            Overflow => ALU_Over,
            Zero     => ALU_Zero
        );

    WB_MUX : mux_3way_4bit
        port map (
            A   => ALU_Res,
            B   => ImmVal,
            C   => StackData,
            Sel => WB_sel,
            Y   => DataBus
        );

    PC_INC : adder_3bit
        port map (
            A   => PCAddr,
            B   => "001",
            Sum => PCPlus1
        );

    PC_MUX : mux_2way_3bit
        port map (
            A   => PCPlus1,
            B   => JumpAddr,
            Sel => JumpFlag,
            Y   => PCNext
        );

    SEG7 : sevenseg_rom
        port map (
            address => R7,
            data    => SevenSeg
        );

    Anode    <= "1110"; -- Select rightmost display
    R7_Out   <= R7;
    ZeroFlag <= ALU_Zero;
    Overflow <= ALU_Over;

end Structural;