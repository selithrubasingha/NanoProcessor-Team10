library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity adder_3bit is
    Port (
        A   : in  STD_LOGIC_VECTOR(2 downto 0);
        B   : in  STD_LOGIC_VECTOR(2 downto 0);
        Sum : out STD_LOGIC_VECTOR(2 downto 0)
    );
end adder_3bit;
 
architecture Structural of adder_3bit is
 
    signal Sum_4bit : STD_LOGIC_VECTOR(3 downto 0);
 
begin
    RCA : entity work.rca_4bit
        port map (
            A    => '0' & A,     
            B    => '0' & B,   
            Cin  => '0',
            Sum  => Sum_4bit,
            Cout => open,
            C3   => open
        );
 
    Sum <= Sum_4bit(2 downto 0);
 
end Structural;