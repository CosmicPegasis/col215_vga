----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/29/2023 02:20:54 PM
-- Design Name: 
-- Module Name: hcounter - Behavioral
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
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hcounter is
Port (
    pix_clk: in std_logic;
    rst: in std_logic;
    hcnt: inout std_logic_vector(9 downto 0) := (others => '0');
    En: out std_logic
     );
end hcounter;

architecture Behavioral of hcounter is
begin
process(pix_clk, rst)
--variable count : unsigned(9 downto 0) := (others => '0');
begin
if rising_edge(pix_clk) then
    if(hcnt = 799) then
         hcnt <= (others => '0');
         En <= '1';
     elsif ( rst = '1') then
        hcnt <= (others => '0');  
     else
        hcnt <= hcnt + 1;
        En <= '0';
     end if;
end if;
end process;

end Behavioral;
