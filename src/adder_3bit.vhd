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

    component rca_4bit
        Port (
            A    : in  STD_LOGIC_VECTOR(3 downto 0);
            B    : in  STD_LOGIC_VECTOR(3 downto 0);
            Cin  : in  STD_LOGIC;
            Sum  : out STD_LOGIC_VECTOR(3 downto 0);
            Cout : out STD_LOGIC;
            C3   : out STD_LOGIC
        );
    end component;
 
begin

   
    RCA : rca_4bit
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
