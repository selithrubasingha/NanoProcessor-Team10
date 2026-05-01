library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nanoprocessor is
    Port (
        Clk      : in  STD_LOGIC;
        Reset    : in  STD_LOGIC;
        R7_Out   : out STD_LOGIC_VECTOR(3 downto 0);
        Overflow : out STD_LOGIC;
        ZeroFlag : out STD_LOGIC;
        SevenSeg : out std_logic_vector(6 downto 0);
        Anode    : out STD_LOGIC_VECTOR(3 downto 0)
    );
end nanoprocessor;

architecture Structural of nanoprocessor is

    signal InstructionBus : STD_LOGIC_VECTOR(11 downto 0);

    signal PCCurrAddr : STD_LOGIC_VECTOR(2 downto 0);
    signal PCNextAddr : STD_LOGIC_VECTOR(2 downto 0);
    signal PCPlusOne  : STD_LOGIC_VECTOR(2 downto 0);

    signal MuxA_Out   : STD_LOGIC_VECTOR(3 downto 0);
    signal MuxB_Out   : STD_LOGIC_VECTOR(3 downto 0);
    signal ALU_Result : STD_LOGIC_VECTOR(3 downto 0);

    signal DataBus    : STD_LOGIC_VECTOR(3 downto 0);

    signal ALU_Zero     : STD_LOGIC;
    signal ALU_Overflow : STD_LOGIC;

    signal RegSel    : STD_LOGIC_VECTOR(2 downto 0);
    signal RegEn     : STD_LOGIC;
    signal MuxA_Sel  : STD_LOGIC_VECTOR(2 downto 0);
    signal MuxB_Sel  : STD_LOGIC_VECTOR(2 downto 0);
    signal AddSub    : STD_LOGIC;
    signal ImmVal    : STD_LOGIC_VECTOR(3 downto 0);
    signal ImmMuxSel : STD_LOGIC;
    signal JumpFlag  : STD_LOGIC;
    signal JumpAddr  : STD_LOGIC_VECTOR(2 downto 0);

    signal R0 : STD_LOGIC_VECTOR(3 downto 0);
    signal R1 : STD_LOGIC_VECTOR(3 downto 0);
    signal R2 : STD_LOGIC_VECTOR(3 downto 0);
    signal R3 : STD_LOGIC_VECTOR(3 downto 0);
    signal R4 : STD_LOGIC_VECTOR(3 downto 0);
    signal R5 : STD_LOGIC_VECTOR(3 downto 0);
    signal R6 : STD_LOGIC_VECTOR(3 downto 0);
    signal R7 : STD_LOGIC_VECTOR(3 downto 0);

    signal seg_out : std_logic_vector(6 downto 0);

    ------------------------------------------------------------------
    -- COMPONENT DECLARATIONS
    ------------------------------------------------------------------

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
    end component;

    component register_bank
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
    end component;

    component mux_8way_4bit
        Port (
            I0,I1,I2,I3,I4,I5,I6,I7 : in STD_LOGIC_VECTOR(3 downto 0);
            Sel : in STD_LOGIC_VECTOR(2 downto 0);
            Y   : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    component add_sub_4bit
        Port (
            A        : in  STD_LOGIC_VECTOR(3 downto 0);
            B        : in  STD_LOGIC_VECTOR(3 downto 0);
            AddSub   : in  STD_LOGIC;
            Result   : out STD_LOGIC_VECTOR(3 downto 0);
            Overflow : out STD_LOGIC;
            Zero     : out STD_LOGIC
        );
    end component;

    component mux_2way_4bit
        Port (
            A   : in  STD_LOGIC_VECTOR(3 downto 0);
            B   : in  STD_LOGIC_VECTOR(3 downto 0);
            Sel : in  STD_LOGIC;
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
    port (
        address : in  std_logic_vector(3 downto 0);
        data    : out std_logic_vector(6 downto 0)
    );
    end component;
        
begin

    PC : program_counter
        port map (NextAddr => PCNextAddr, Clk => Clk, Reset => Reset, CurrAddr => PCCurrAddr);

    ROM : program_rom
        port map (Addr => PCCurrAddr, Instruction => InstructionBus);

    DECODER : instruction_decoder
        port map (
            Instruction => InstructionBus, Zero => ALU_Zero,
            RegSel => RegSel, RegEn => RegEn,
            MuxA_Sel => MuxA_Sel, MuxB_Sel => MuxB_Sel,
            AddSub => AddSub, ImmVal => ImmVal,
            ImmMuxSel => ImmMuxSel, JumpFlag => JumpFlag, JumpAddr => JumpAddr
        );

    REGBANK : register_bank
        port map (
            D => DataBus, RegSel => RegSel, RegEn => RegEn,
            Clk => Clk, Reset => Reset,
            R0 => R0, R1 => R1, R2 => R2, R3 => R3,
            R4 => R4, R5 => R5, R6 => R6, R7 => R7
        );

    MUX_A : mux_8way_4bit
        port map (R0,R1,R2,R3,R4,R5,R6,R7, MuxA_Sel, MuxA_Out);

    MUX_B : mux_8way_4bit
        port map (R0,R1,R2,R3,R4,R5,R6,R7, MuxB_Sel, MuxB_Out);

    ALU : add_sub_4bit
        port map (
            A => MuxA_Out, B => MuxB_Out, AddSub => AddSub,
            Result => ALU_Result, Overflow => ALU_Overflow, Zero => ALU_Zero
        );

    IMM_MUX : mux_2way_4bit
        port map (A => ALU_Result, B => ImmVal, Sel => ImmMuxSel, Y => DataBus);

    PC_INC : adder_3bit
        port map (A => PCCurrAddr, B => "001", Sum => PCPlusOne);

    PC_MUX : mux_2way_3bit
        port map (A => PCPlusOne, B => JumpAddr, Sel => JumpFlag, Y => PCNextAddr);
    SEG7 : sevenseg_rom
        port map (address => R7, data => seg_out);

    R7_Out   <= R7;
    ZeroFlag <= ALU_Zero;
    Overflow <= ALU_Overflow;
    SevenSeg <= seg_out;

end Structural;
