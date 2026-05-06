library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nanoprocessor is
    Port (
        Clk      : in  STD_LOGIC;
        Reset    : in  STD_LOGIC;
        R7_Out   : out STD_LOGIC_VECTOR(3 downto 0);
        Overflow : out STD_LOGIC;
        ZeroFlag : out STD_LOGIC;
        NegFlag  : out STD_LOGIC;
        SevenSeg : out std_logic_vector(6 downto 0); 
        Anode    : out STD_LOGIC_VECTOR(3 downto 0)
    );
end nanoprocessor;

architecture Structural of nanoprocessor is

------------------------------------------------------------------
    -- COMPONENT DECLARATIONS
    ------------------------------------------------------------------
    
    component Slow_Clk
        Port (
            Clk_in  : in STD_LOGIC;
            Clk_out : out STD_LOGIC
        );
    end component;

    -- KEEP THIS (From your display branch)
    component Signed_7Seg_Controller
        Port (
            Clk         : in  STD_LOGIC;
            Reset       : in  STD_LOGIC;
            Reg_Data    : in  STD_LOGIC_VECTOR (3 downto 0);
            SevenSeg    : out STD_LOGIC_VECTOR (6 downto 0);
            Anode       : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    -- [KEEP YOUR OTHER COMPONENTS HERE: PC, ROM, DECODER, REG_BANK, MUXES, ADDER]

   

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
            Negative    : in  STD_LOGIC;
            MuxA_Sel    : out STD_LOGIC_VECTOR(2 downto 0);
            MuxB_Sel    : out STD_LOGIC_VECTOR(2 downto 0);

            ALUop       : out STD_LOGIC_VECTOR(3 downto 0);

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

    component alu_4bit
        Port (
            A        : in  STD_LOGIC_VECTOR(3 downto 0);
            B        : in  STD_LOGIC_VECTOR(3 downto 0);
            ALUop    : in  STD_LOGIC_VECTOR(3 downto 0);
            Result   : out STD_LOGIC_VECTOR(3 downto 0);
            Overflow : out STD_LOGIC;
            Zero     : out STD_LOGIC;
            Negative : out STD_LOGIC
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
        
    -- component sevenseg_rom
    --     Port (
    --         address : in  std_logic_vector(3 downto 0);
    --         data    : out std_logic_vector(6 downto 0)
    --     );
    -- end component;

    ------------------------------------------------------------------
    -- INTERNAL SIGNALS
    ------------------------------------------------------------------
    
    signal clk_slow : STD_LOGIC;
    signal seg_out  : std_logic_vector(6 downto 0);
    
    signal InstructionBus : STD_LOGIC_VECTOR(11 downto 0);
    signal PCCurrAddr     : STD_LOGIC_VECTOR(2 downto 0);
    signal PCNextAddr     : STD_LOGIC_VECTOR(2 downto 0);
    signal PCPlusOne      : STD_LOGIC_VECTOR(2 downto 0);

    signal MuxA_Out       : STD_LOGIC_VECTOR(3 downto 0);
    signal MuxB_Out       : STD_LOGIC_VECTOR(3 downto 0);
    signal ALU_Result     : STD_LOGIC_VECTOR(3 downto 0);
    signal DataBus        : STD_LOGIC_VECTOR(3 downto 0);

    signal ALU_Zero       : STD_LOGIC;
    signal ALU_Overflow   : STD_LOGIC;
    signal ALU_Negative : STD_LOGIC;

    signal RegSel         : STD_LOGIC_VECTOR(2 downto 0);
    signal RegEn          : STD_LOGIC;
    signal MuxA_Sel       : STD_LOGIC_VECTOR(2 downto 0);
    signal MuxB_Sel       : STD_LOGIC_VECTOR(2 downto 0);
    signal ALUop_Sig     : STD_LOGIC_VECTOR(3 downto 0);
    signal ImmVal         : STD_LOGIC_VECTOR(3 downto 0);
    signal ImmMuxSel      : STD_LOGIC;
    signal JumpFlag       : STD_LOGIC;
    signal JumpAddr       : STD_LOGIC_VECTOR(2 downto 0);

    signal R0, R1, R2, R3, R4, R5, R6, R7 : STD_LOGIC_VECTOR(3 downto 0);

begin

    ------------------------------------------------------------------
    -- COMPONENT INSTANTIATIONS
    ------------------------------------------------------------------

    CLOCK_DIVIDER : Slow_Clk
        port map (
            Clk_in  => Clk,       -- Raw 100 MHz from the board
            Clk_out => clk_slow   -- The 1 Hz slowed down clock
        );

    -- NEW: Display Controller on the FAST clock
    DISPLAY_CTRL : Signed_7Seg_Controller
        port map (
            Clk      => Clk,      -- RAW 100 MHz here for multiplexing
            Reset    => Reset,
            Reg_Data => R7,
            SevenSeg => SevenSeg,
            Anode    => Anode
        );

    PC : program_counter
        port map (
            NextAddr => PCNextAddr, 
            Clk      => clk_slow, -- Driven by slow clock
            Reset    => Reset, 
            CurrAddr => PCCurrAddr
        );

    ROM : program_rom
        port map (
            Addr        => PCCurrAddr, 
            Instruction => InstructionBus
        );

DECODER : instruction_decoder
        port map (
            Instruction => InstructionBus,
            Zero        => ALU_Zero,
            Negative    => ALU_Negative, -- MUST keep this for Jump logic!
            RegSel      => RegSel,
            RegEn       => RegEn,
            MuxA_Sel    => MuxA_Sel,
            MuxB_Sel    => MuxB_Sel,
            ALUop       => ALUop_Sig,    -- Using the new 4-bit control
            ImmVal      => ImmVal,
            ImmMuxSel   => ImmMuxSel,
            JumpFlag    => JumpFlag,
           
            JumpAddr    => JumpAddr
        );

    REGBANK : register_bank
        port map (
            D      => DataBus, 
            RegSel => RegSel, 
            RegEn  => RegEn,
            Clk    => clk_slow,   -- Driven by slow clock
            Reset  => Reset,
            R0     => R0, R1 => R1, R2 => R2, R3 => R3,
            R4     => R4, R5 => R5, R6 => R6, R7 => R7
        );

    MUX_A : mux_8way_4bit
        port map (
            I0 => R0, I1 => R1, I2 => R2, I3 => R3, I4 => R4, I5 => R5, I6 => R6, I7 => R7, 
            Sel => MuxA_Sel, 
            Y   => MuxA_Out
        );

    MUX_B : mux_8way_4bit
        port map (
            I0 => R0, I1 => R1, I2 => R2, I3 => R3, I4 => R4, I5 => R5, I6 => R6, I7 => R7, 
            Sel => MuxB_Sel, 
            Y   => MuxB_Out
        );

ALU : alu_4bit
        port map (
            A        => MuxA_Out,
            B        => MuxB_Out,
            ALUop    => ALUop_Sig,
            Result   => ALU_Result,
            Overflow => ALU_Overflow,
            Zero     => ALU_Zero,
            Negative => ALU_Negative
        );

    IMM_MUX : mux_2way_4bit
        port map (
            A   => ALU_Result, 
            B   => ImmVal, 
            Sel => ImmMuxSel, 
            Y   => DataBus
        );

    PC_INC : adder_3bit
        port map (
            A   => PCCurrAddr, 
            B   => "001", 
            Sum => PCPlusOne
        );

    PC_MUX : mux_2way_3bit
        port map (
            A   => PCPlusOne, 
            B   => JumpAddr, 
            Sel => JumpFlag, 
            Y   => PCNextAddr
        );
        


    ------------------------------------------------------------------
    -- OUTPUT WIRING
    ------------------------------------------------------------------
    
    R7_Out   <= R7;
    ZeroFlag <= ALU_Zero;
    Overflow <= ALU_Overflow;
    NegFlag <= ALU_Negative;

end Structural;