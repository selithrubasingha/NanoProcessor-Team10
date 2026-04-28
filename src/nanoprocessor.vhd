
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nanoprocessor is
    Port (
        Clk      : in  STD_LOGIC;
        Reset    : in  STD_LOGIC;
        -- Result output (R7) wired to LD0-LD3
        R7_Out   : out STD_LOGIC_VECTOR(3 downto 0);
        -- Status flags wired to LD14 and LD15
        Overflow : out STD_LOGIC;
        ZeroFlag : out STD_LOGIC
    );
end nanoprocessor;

architecture Structural of nanoprocessor is

   

    -- Instruction Bus: ROM -> Decoder
    signal InstructionBus : STD_LOGIC_VECTOR(11 downto 0);

    -- Program Counter signals
    signal PCCurrAddr : STD_LOGIC_VECTOR(2 downto 0);  -- PC output
    signal PCNextAddr : STD_LOGIC_VECTOR(2 downto 0);  -- PC input (from 2-way 3-bit mux)
    signal PCPlusOne  : STD_LOGIC_VECTOR(2 downto 0);  -- 3-bit adder output

    -- ALU operand signals
    signal MuxA_Out   : STD_LOGIC_VECTOR(3 downto 0);  -- 8-way mux A output
    signal MuxB_Out   : STD_LOGIC_VECTOR(3 downto 0);  -- 8-way mux B output
    signal ALU_Result : STD_LOGIC_VECTOR(3 downto 0);  -- add_sub_4bit result

    -- Data Bus: 2-way 4-bit mux output -> Register Bank D input
    signal DataBus    : STD_LOGIC_VECTOR(3 downto 0);

    -- ALU flag signals
    signal ALU_Zero     : STD_LOGIC;
    signal ALU_Overflow : STD_LOGIC;

    -- Control signals from Instruction Decoder
    signal RegSel    : STD_LOGIC_VECTOR(2 downto 0);
    signal RegEn     : STD_LOGIC;
    signal MuxA_Sel  : STD_LOGIC_VECTOR(2 downto 0);
    signal MuxB_Sel  : STD_LOGIC_VECTOR(2 downto 0);
    signal AddSub    : STD_LOGIC;
    signal ImmVal    : STD_LOGIC_VECTOR(3 downto 0);
    signal ImmMuxSel : STD_LOGIC;
    signal JumpFlag  : STD_LOGIC;
    signal JumpAddr  : STD_LOGIC_VECTOR(2 downto 0);

    -- Register Bank outputs (all registers always readable)
    signal R0 : STD_LOGIC_VECTOR(3 downto 0);
    signal R1 : STD_LOGIC_VECTOR(3 downto 0);
    signal R2 : STD_LOGIC_VECTOR(3 downto 0);
    signal R3 : STD_LOGIC_VECTOR(3 downto 0);
    signal R4 : STD_LOGIC_VECTOR(3 downto 0);
    signal R5 : STD_LOGIC_VECTOR(3 downto 0);
    signal R6 : STD_LOGIC_VECTOR(3 downto 0);
    signal R7 : STD_LOGIC_VECTOR(3 downto 0);

begin

    
    PC : entity work.program_counter
        port map (
            NextAddr => PCNextAddr,
            Clk      => Clk,
            Reset    => Reset,
            CurrAddr => PCCurrAddr
        );

  
    ROM : entity work.program_rom
        port map (
            Addr        => PCCurrAddr,
            Instruction => InstructionBus
        );

   
   
    DECODER : entity work.instruction_decoder
        port map (
            Instruction => InstructionBus,
            Zero        => ALU_Zero,
            RegSel      => RegSel,
            RegEn       => RegEn,
            MuxA_Sel    => MuxA_Sel,
            MuxB_Sel    => MuxB_Sel,
            AddSub      => AddSub,
            ImmVal      => ImmVal,
            ImmMuxSel   => ImmMuxSel,
            JumpFlag    => JumpFlag,
            JumpAddr    => JumpAddr
        );

   
   
    REGBANK : entity work.register_bank
        port map (
            D      => DataBus,
            RegSel => RegSel,
            RegEn  => RegEn,
            Clk    => Clk,
            Reset  => Reset,
            R0     => R0,
            R1     => R1,
            R2     => R2,
            R3     => R3,
            R4     => R4,
            R5     => R5,
            R6     => R6,
            R7     => R7
        );

   
    MUX_A : entity work.mux_8way_4bit
        port map (
            I0  => R0,
            I1  => R1,
            I2  => R2,
            I3  => R3,
            I4  => R4,
            I5  => R5,
            I6  => R6,
            I7  => R7,
            Sel => MuxA_Sel,
            Y   => MuxA_Out
        );

   
    MUX_B : entity work.mux_8way_4bit
        port map (
            I0  => R0,
            I1  => R1,
            I2  => R2,
            I3  => R3,
            I4  => R4,
            I5  => R5,
            I6  => R6,
            I7  => R7,
            Sel => MuxB_Sel,
            Y   => MuxB_Out
        );

   
    ALU : entity work.add_sub_4bit
        port map (
            A        => MuxA_Out,
            B        => MuxB_Out,
            AddSub   => AddSub,
            Result   => ALU_Result,
            Overflow => ALU_Overflow,
            Zero     => ALU_Zero
        );

    
    IMM_MUX : entity work.mux_2way_4bit
        port map (
            A   => ALU_Result,
            B   => ImmVal,
            Sel => ImmMuxSel,
            Y   => DataBus
        );

   
    PC_INC : entity work.adder_3bit
        port map (
            A   => PCCurrAddr,
            B   => "001",
            Sum => PCPlusOne
        );

    
   
    PC_MUX : entity work.mux_2way_3bit
        port map (
            A   => PCPlusOne,
            B   => JumpAddr,
            Sel => JumpFlag,
            Y   => PCNextAddr
        );

    
    R7_Out   <= R7;
    ZeroFlag <= ALU_Zero;
    Overflow <= ALU_Overflow;

end Structural;
