library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instruction_decoder is
    Port (
        Instruction : in  STD_LOGIC_VECTOR(11 downto 0);
        Zero        : in  STD_LOGIC;   -- ALU Zero flag; used for JZR jump decision
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

    -- Convenience aliases for the opcode field
    alias Opcode : STD_LOGIC_VECTOR(1 downto 0) is Instruction(11 downto 10);
    -- Primary register field (Ra for ADD, R for MOVI/NEG/JZR)
    alias RegA   : STD_LOGIC_VECTOR(2 downto 0) is Instruction(9 downto 7);
    -- Secondary register field (Rb for ADD only)
    alias RegB   : STD_LOGIC_VECTOR(2 downto 0) is Instruction(6 downto 4);
    -- Immediate / jump target fields
    alias ImmFull : STD_LOGIC_VECTOR(3 downto 0) is Instruction(3 downto 0);
    alias JmpDest : STD_LOGIC_VECTOR(2 downto 0) is Instruction(2 downto 0);

begin -- Architecture logic starts here

    -- Always drive these from fixed bit positions
    ImmVal   <= ImmFull; 
    JumpAddr <= JmpDest; 

    -- ---------------------------------------------------------------
    -- Main combinational decode process
    -- ---------------------------------------------------------------
    process(Opcode, RegA, RegB, Zero)
    begin
        -- Safe defaults
        RegSel    <= RegA;
        RegEn     <= '0';
        MuxA_Sel  <= "000";
        MuxB_Sel  <= "000";
        AddSub    <= '0';
        ImmMuxSel <= '0';
        JumpFlag  <= '0';

        case Opcode is
            -- ADD Ra, Rb
            when "00" =>
                RegSel    <= RegA;
                RegEn     <= '1';
                MuxA_Sel  <= RegA;
                MuxB_Sel  <= RegB;
                AddSub    <= '0';
                ImmMuxSel <= '0';
                JumpFlag  <= '0';

            -- NEG R
            when "01" =>
                RegSel    <= RegA;
                RegEn     <= '1';
                MuxA_Sel  <= "000";
                MuxB_Sel  <= RegA;
                AddSub    <= '1';
                ImmMuxSel <= '0';
                JumpFlag  <= '0';

            -- MOVI R, d
            when "10" =>
                RegSel    <= RegA;
                RegEn     <= '1';
                MuxA_Sel  <= "000";
                MuxB_Sel  <= "000";
                AddSub    <= '0';
                ImmMuxSel <= '1';
                JumpFlag  <= '0';

            -- JZR R, d
            when "11" =>
                RegSel    <= "000";
                RegEn     <= '0';
                MuxA_Sel  <= "000";
                MuxB_Sel  <= RegA;
                AddSub    <= '1';
                ImmMuxSel <= '0';
                JumpFlag  <= Zero;

            when others =>
                RegSel    <= "000";
                RegEn     <= '0';
                MuxA_Sel  <= "000";
                MuxB_Sel  <= "000";
                AddSub    <= '0';
                ImmMuxSel <= '0';
                JumpFlag  <= '0';
        end case;
    end process;

end Behavioral; -- Architecture ends here