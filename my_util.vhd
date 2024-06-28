----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/24/2023 08:47:50 PM
-- Design Name: 
-- Module Name: my_util - Behavioral
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
use IEEE.numeric_std.all;

package my_util is
  type matrix is array(0 to 2, 0 to 2) of unsigned(7 downto 0);
  type mmatrix is array(0 to 2, 0 to 2) of signed(16 downto 0);
  type amatrix is array(0 to 2, 0 to 2) of integer;
  type kernel_matrix is array(0 to 2, 0 to 2) of signed(7 downto 0);
  ---type out_matrix is array(0 to 2, 0 to 2) of integer;
  constant zero : std_logic_vector(11 downto 0) := (others => '0'); 
  constant one : std_logic_vector(11 downto 0) := (0 => '1', others => '0');
 -- constant id_mat: matrix := ((1, 0, 0), (0, 1, 0), (0, 0, 1));
  type state_type is (FILTER, NORM, DISP); 
end my_util;
