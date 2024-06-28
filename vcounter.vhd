----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/29/2023 02:41:21 PM
-- Design Name: 
-- Module Name: vcounter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vcounter is
    Port (
        pix_clk: in std_logic;
        rst: in std_logic;
        En: in std_logic;
        vcnt: inout std_logic_vector(9 downto 0) := (others => '0')
    );
end vcounter;

architecture Behavioral of vcounter is
begin
    process(pix_clk, En)
    begin
        if rising_edge(pix_clk) then
            if(En = '1') then
                if(vcnt = 524) then
                    vcnt <= (others => '0');
                else
                    vcnt <= vcnt + 1;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
