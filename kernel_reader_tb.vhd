----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2023 09:51:24 PM
-- Design Name: 
-- Module Name: kernel_reader_tb - Behavioral
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
use work.my_util.all;
entity kernel_reader_tb is
--  Port ( );
end kernel_reader_tb;

architecture Behavioral of kernel_reader_tb is

component kernel_reader is
Port (
    clk: in std_logic;
    o: out matrix := id_mat
);
end component;
signal clk: std_logic := '0';
signal o: matrix;
begin
clk <= not clk after 5 ns;
uut: kernel_reader port map(clk => clk, o => o);

end Behavioral;
