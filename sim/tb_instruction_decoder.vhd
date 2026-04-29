
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_instruction_decoder is
end tb_instruction_decoder;

architecture Behavioral of tb_instruction_decoder is

    signal Instruction : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
    signal Zero        : STD_LOGIC := '0';
    signal RegSel      : STD_LOGIC_VECTOR(2 downto 0);
    signal RegEn       : STD_LOGIC;
    signal MuxA_Sel    : STD_LOGIC_VECTOR(2 downto 0);
    signal MuxB_Sel    : STD_LOGIC_VECTOR(2 downto 0);
    signal AddSub      : STD_LOGIC;
    signal ImmVal      : STD_LOGIC_VECTOR(3 downto 0);
    signal ImmMuxSel   : STD_LOGIC;
    signal JumpFlag    : STD_LOGIC;
    signal JumpAddr    : STD_LOGIC_VECTOR(2 downto 0);

begin
    UUT : entity work.instruction_decoder
        port map (Instruction, Zero, RegSel, RegEn, MuxA_Sel, MuxB_Sel,
                  AddSub, ImmVal, ImmMuxSel, JumpFlag, JumpAddr);

    process
    begin
        
        -- Test 1: MOVI R1, 10  -> 10 001 000 1010
        Instruction <= "100010001010"; Zero <= '0';
        wait for 20 ns;
        assert RegSel    = "001" report "FAIL MOVI: RegSel"    severity error;
        assert RegEn     = '1'   report "FAIL MOVI: RegEn"     severity error;
        assert ImmMuxSel = '1'   report "FAIL MOVI: ImmMuxSel" severity error;
        assert ImmVal    = "1010" report "FAIL MOVI: ImmVal"   severity error;
        assert JumpFlag  = '0'   report "FAIL MOVI: JumpFlag"  severity error;

        
        -- Test 2: ADD R1, R2  -> 00 001 010 0000
        Instruction <= "000010100000"; Zero <= '0';
        wait for 20 ns;
        assert RegSel    = "001" report "FAIL ADD: RegSel"    severity error;
        assert RegEn     = '1'   report "FAIL ADD: RegEn"     severity error;
        assert MuxA_Sel  = "001" report "FAIL ADD: MuxA_Sel"  severity error;
        assert MuxB_Sel  = "010" report "FAIL ADD: MuxB_Sel"  severity error;
        assert AddSub    = '0'   report "FAIL ADD: AddSub"    severity error;
        assert ImmMuxSel = '0'   report "FAIL ADD: ImmMuxSel" severity error;
        assert JumpFlag  = '0'   report "FAIL ADD: JumpFlag"  severity error;

        
        -- Test 3: NEG R2  -> 01 010 000 0000
        Instruction <= "010100000000"; Zero <= '0';
        wait for 20 ns;
        assert RegSel    = "010" report "FAIL NEG: RegSel"    severity error;
        assert RegEn     = '1'   report "FAIL NEG: RegEn"     severity error;
        assert MuxA_Sel  = "000" report "FAIL NEG: MuxA_Sel"  severity error;
        assert MuxB_Sel  = "010" report "FAIL NEG: MuxB_Sel"  severity error;
        assert AddSub    = '1'   report "FAIL NEG: AddSub"    severity error;
        assert ImmMuxSel = '0'   report "FAIL NEG: ImmMuxSel" severity error;

        
        -- Test 4: JZR R1, 7  -> 11 001 0000 111   (Zero='0' -> no jump)
        Instruction <= "110010000111"; Zero <= '0';
        wait for 20 ns;
        assert RegEn    = '0'   report "FAIL JZR: RegEn should be 0" severity error;
        assert JumpFlag = '0'   report "FAIL JZR: JumpFlag should be 0 when Zero=0" severity error;
        assert JumpAddr = "111" report "FAIL JZR: JumpAddr" severity error;
        assert MuxA_Sel = "000" report "FAIL JZR: MuxA_Sel" severity error;
        assert MuxB_Sel = "001" report "FAIL JZR: MuxB_Sel" severity error;
        assert AddSub   = '1'   report "FAIL JZR: AddSub" severity error;

       
        -- Test 5: JZR R1, 7 with Zero='1' -> jump should be taken
        Instruction <= "110010000111"; Zero <= '1';
        wait for 20 ns;
        assert RegEn    = '0'   report "FAIL JZR taken: RegEn" severity error;
        assert JumpFlag = '1'   report "FAIL JZR taken: JumpFlag should be 1" severity error;
        assert JumpAddr = "111" report "FAIL JZR taken: JumpAddr" severity error;

    
        -- Test 6: JZR R0, 3  -> 11 000 0000 011  (R0=0, always jumps when Zero=1)
        Instruction <= "110000000011"; Zero <= '1';
        wait for 20 ns;
        assert JumpFlag = '1'   report "FAIL JZR R0: JumpFlag" severity error;
        assert JumpAddr = "011" report "FAIL JZR R0: JumpAddr" severity error;

        report "instruction_decoder: ALL TESTS PASSED" severity note;
        wait;
    end process;
end Behavioral;
