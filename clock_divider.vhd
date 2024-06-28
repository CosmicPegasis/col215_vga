----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/29/2023 01:15:13 PM
-- Design Name: 
-- Module Name: clock_divider - Behavioral
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

entity clock_divider is
Port ( 
    clk: in std_logic;
    pix_clk: inout std_logic := '0');
end clock_divider;

architecture Behavioral of clock_divider is
    signal int_pix_clk: std_logic := '0';

begin
    process(clk)
    variable tick : std_logic := '0';
    begin
   if rising_edge(clk) then
        if tick = '1' then
           tick := '0';
           pix_clk <= not pix_clk;
        else
            tick := '1';
        end if;
    end if;
    end process;   


end Behavioral;
