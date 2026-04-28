----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 10:54:00 PM
-- Design Name: 
-- Module Name: PC_3bit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC_3bit is
    Port ( Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           load_value : in STD_LOGIC_VECTOR (2 downto 0);
           out_value : out STD_LOGIC_VECTOR (2 downto 0));
end PC_3bit;

architecture Structural of PC_3bit is

    component D_FF
        port (
            D : in std_logic;
            Res : in std_logic;
            Clk : in std_logic;
            Q : out std_logic;
            Qbar : out std_logic
        );
    end component;

begin

    
    D_FF0 : D_FF
        port map (
            D => load_value(0),
            Res => Reset,
            Clk => Clk,
            Q => out_value(0)
            
        );

    D_FF1 : D_FF
        port map (
            D => load_value(1),
            Res => Reset,
            Clk => Clk,
            Q => out_value(1)
        );

    D_FF2 : D_FF
        port map (
            D => load_value(2),
            Res => Reset,
            Clk => Clk,
            Q => out_value(2)
        );

end Structural;