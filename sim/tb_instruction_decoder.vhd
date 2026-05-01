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
    signal ALUop       : STD_LOGIC_VECTOR(3 downto 0);
    signal ImmVal      : STD_LOGIC_VECTOR(3 downto 0);
    signal ImmMuxSel   : STD_LOGIC;
    signal JumpFlag    : STD_LOGIC;
    signal JumpAddr    : STD_LOGIC_VECTOR(2 downto 0);

begin

    UUT : entity work.instruction_decoder
        port map (
            Instruction => Instruction,
            Zero        => Zero,
            RegSel      => RegSel,
            RegEn       => RegEn,
            MuxA_Sel    => MuxA_Sel,
            MuxB_Sel    => MuxB_Sel,
            ALUop       => ALUop,
            ImmVal      => ImmVal,
            ImmMuxSel   => ImmMuxSel,
            JumpFlag    => JumpFlag,
            JumpAddr    => JumpAddr
        );

    process
    begin


        -- Test 1: MOVI R1, 10  ->  10 001 000 1010
     
        Instruction <= "100010001010"; Zero <= '0';
        wait for 100 ns;
        assert RegSel    = "001"  report "FAIL MOVI: RegSel"    severity error;
        assert RegEn     = '1'    report "FAIL MOVI: RegEn"     severity error;
        assert ImmMuxSel = '1'    report "FAIL MOVI: ImmMuxSel" severity error;
        assert ImmVal    = "1010" report "FAIL MOVI: ImmVal"    severity error;
        assert JumpFlag  = '0'    report "FAIL MOVI: JumpFlag"  severity error;

  
        -- Test 2: ADD Ra=R1, Rb=R2  ->  00 001 010 0000
        -- ALUop = 0000 (ADD)
      
        Instruction <= "000010100000"; Zero <= '0';
        wait for 100 ns;
        assert RegSel    = "001"  report "FAIL ADD: RegSel"    severity error;
        assert RegEn     = '1'    report "FAIL ADD: RegEn"     severity error;
        assert MuxA_Sel  = "001"  report "FAIL ADD: MuxA_Sel"  severity error;
        assert MuxB_Sel  = "010"  report "FAIL ADD: MuxB_Sel"  severity error;
        assert ALUop     = "0000" report "FAIL ADD: ALUop"     severity error;
        assert ImmMuxSel = '0'    report "FAIL ADD: ImmMuxSel" severity error;
        assert JumpFlag  = '0'    report "FAIL ADD: JumpFlag"  severity error;

       
        -- Test 3: AND Ra=R1, Rb=R2  ->  00 001 010 0010
        -- ALUop = 0010 (AND)
  
        Instruction <= "000010100010"; Zero <= '0';
        wait for 100 ns;
        assert RegSel    = "001"  report "FAIL AND: RegSel"    severity error;
        assert RegEn     = '1'    report "FAIL AND: RegEn"     severity error;
        assert MuxA_Sel  = "001"  report "FAIL AND: MuxA_Sel"  severity error;
        assert MuxB_Sel  = "010"  report "FAIL AND: MuxB_Sel"  severity error;
        assert ALUop     = "0010" report "FAIL AND: ALUop"     severity error;
        assert ImmMuxSel = '0'    report "FAIL AND: ImmMuxSel" severity error;
        assert JumpFlag  = '0'    report "FAIL AND: JumpFlag"  severity error;

        
        -- Test 4: OR Ra=R3, Rb=R4  ->  00 011 100 0011
        -- ALUop = 0011 (OR)
      
        Instruction <= "000111000011"; Zero <= '0';
        wait for 100 ns;
        assert RegSel    = "011"  report "FAIL OR: RegSel"    severity error;
        assert RegEn     = '1'    report "FAIL OR: RegEn"     severity error;
        assert MuxA_Sel  = "011"  report "FAIL OR: MuxA_Sel"  severity error;
        assert MuxB_Sel  = "100"  report "FAIL OR: MuxB_Sel"  severity error;
        assert ALUop     = "0011" report "FAIL OR: ALUop"     severity error;
        assert ImmMuxSel = '0'    report "FAIL OR: ImmMuxSel" severity error;

  
        -- Test 5: XOR Ra=R5, Rb=R6  ->  00 101 110 0100
        -- ALUop = 0100 (XOR)
      
        Instruction <= "001011100100"; Zero <= '0';
        wait for 100 ns;
        assert RegSel    = "101"  report "FAIL XOR: RegSel"    severity error;
        assert RegEn     = '1'    report "FAIL XOR: RegEn"     severity error;
        assert MuxA_Sel  = "101"  report "FAIL XOR: MuxA_Sel"  severity error;
        assert MuxB_Sel  = "110"  report "FAIL XOR: MuxB_Sel"  severity error;
        assert ALUop     = "0100" report "FAIL XOR: ALUop"     severity error;

 
        -- Test 6: NEG R2  ->  01 010 000 0000
        -- Computes 0 - R2: MuxA=R0, MuxB=R2, ALUop=0001 (SUB)
      
        Instruction <= "010100000000"; Zero <= '0';
        wait for 100 ns;
        assert RegSel    = "010"  report "FAIL NEG: RegSel"    severity error;
        assert RegEn     = '1'    report "FAIL NEG: RegEn"     severity error;
        assert MuxA_Sel  = "000"  report "FAIL NEG: MuxA_Sel"  severity error;
        assert MuxB_Sel  = "010"  report "FAIL NEG: MuxB_Sel"  severity error;
        assert ALUop     = "0001" report "FAIL NEG: ALUop"     severity error;
        assert ImmMuxSel = '0'    report "FAIL NEG: ImmMuxSel" severity error;

 
        -- Test 7: JZR R1, 7  ->  11 001 0000 111   (Zero='0' -> no jump)
     
        Instruction <= "110010000111"; Zero <= '0';
        wait for 100 ns;
        assert RegEn    = '0'   report "FAIL JZR: RegEn should be 0"             severity error;
        assert JumpFlag = '0'   report "FAIL JZR: JumpFlag should be 0 (Zero=0)" severity error;
        assert JumpAddr = "111" report "FAIL JZR: JumpAddr"                       severity error;
        assert MuxA_Sel = "000" report "FAIL JZR: MuxA_Sel"                      severity error;
        assert MuxB_Sel = "001" report "FAIL JZR: MuxB_Sel"                      severity error;
        assert ALUop    = "0000" report "FAIL JZR: ALUop"                         severity error;

      
        -- Test 8: JZR R1, 7  (Zero='1' -> jump taken)
        
        Instruction <= "110010000111"; Zero <= '1';
        wait for 100 ns;
        assert RegEn    = '0'   report "FAIL JZR taken: RegEn"                severity error;
        assert JumpFlag = '1'   report "FAIL JZR taken: JumpFlag should be 1" severity error;
        assert JumpAddr = "111" report "FAIL JZR taken: JumpAddr"              severity error;

   
        -- Test 9: JZR R0, 3  ->  11 000 0000 011  (Zero='1')
   
        Instruction <= "110000000011"; Zero <= '1';
        wait for 100 ns;
        assert JumpFlag = '1'   report "FAIL JZR R0: JumpFlag" severity error;
        assert JumpAddr = "011" report "FAIL JZR R0: JumpAddr" severity error;

        report "instruction_decoder: ALL TESTS PASSED" severity note;
        wait;
    end process;

end Behavioral;