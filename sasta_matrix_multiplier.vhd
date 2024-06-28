----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/24/2023 09:22:20 PM
-- Design Name: 
-- Module Name: matrix_multiplier - Behavioral
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
use work.my_util.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sasta_matrix_multiplier is
port(
clk : in std_logic;
i1: in matrix;
i2: in kernel_matrix;
o: out mmatrix
);
end sasta_matrix_multiplier;

architecture Behavioral of sasta_matrix_multiplier is
begin
--    process(clk)
--        variable i : integer range -1 to 3 := 0;
--        variable j : integer range -1 to 3 := 0;
--        begin
--            if rising_edge(clk) then
--                o(i,j) <= i1(i,j) * i2(i,j);
--                if j = 2 then
--                    j := -1;
--                    i := i + 1;
--                end if;
--                if i = 3 then
--                    i := 0;
--                end if;
--                j := j + 1;
--            end if;
--    end process;
o(0,0) <= signed("0" & i1(0,0)) * i2(0,0);
o(0,1) <= signed("0" & i1(0,1)) * i2(0,1);
o(0,2) <= signed("0" & i1(0,2)) * i2(0,2);

o(1,0) <= signed("0" & i1(1,0)) * i2(1,0);
o(1,1) <= signed("0" & i1(1,1)) * i2(1,1);
o(1,2) <= signed("0" & i1(1,2)) * i2(1,2);

o(2,0) <= signed("0" & i1(2,0)) * i2(2,0);
o(2,1) <= signed("0" & i1(2,1)) * i2(2,1);
o(2,2) <= signed("0" & i1(2,2)) * i2(2,2);
 
-- o(0,1) <= i1(0,1) * i2(0,1);
-- o(0,2) <= i1(0,2) * i2(0,2);
 
-- o(1,0) <= i1(1,0) * i2(1,0);
-- o(1,1) <= i1(1,1) * i2(1,1);
-- o(1,2) <= i1(1,2) * i2(1,2);
 
--  o(2,0) <= i1(2,0) * i2(2,0);
-- o(2,1) <= i1(2,1) * i2(2,1);
-- o(2,2) <= i1(2,2) * i2(2,2);
end Behavioral;
