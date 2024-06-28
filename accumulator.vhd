----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2023 10:16:41 PM
-- Design Name: 
-- Module Name: accumulator - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
use work.my_util.all;
entity accumulator is
Port (
    in_mat: in mmatrix;
    address: in unsigned(11 downto 0);
    clk: in std_logic;
    En: in std_logic;
    o : inout signed(19 downto 0)
);
end accumulator;

architecture Behavioral of accumulator is
    signal i: integer range 0 to 63;
    signal j: integer range 0 to 63;
    signal acc_done : std_logic := '0'; 
    signal correction: matrix;
    signal selected: matrix;
 --   type state is (RST, ACC, DONE);
   -- signal cur_state : state := RST;
   pure function is_left_edge(i : integer; j : integer) return boolean is begin
    if j = 0 then
        return true;
    else
        return false;
    end if;
    end function;
    pure function is_right_edge(i : integer; j : integer) return boolean is begin
        if j = 63 then -- hard coding 64x64 value as
             return true;
        else
            return false;
        end if;
    end function;
    pure function is_top_edge(i : integer; j : integer) return boolean is begin
        if i = 0 then
            return true;
        else
            return false;
        end if;
    end function;
    pure function is_bottom_edge(i : integer; j : integer) return boolean is begin
        if i = 63 then -- hard coding 64x64 value as
             return true;
        else
            return false;
        end if;
    end function;
    pure function is_tl_corner(i : integer; j : integer) return boolean is begin
        if is_top_edge(i,j) and is_left_edge(i,j) then
            return true;
        else
            return false;
        end if;
    end function;
    pure function is_tr_corner(i : integer; j : integer) return boolean is begin
        if is_top_edge(i,j) and is_right_edge(i,j) then
            return true;
        else
            return false;
        end if;
    end function;
    pure function is_bl_corner(i : integer; j : integer) return boolean is begin
        if is_bottom_edge(i,j) and is_left_edge(i,j) then
            return true;
        else
            return false;
        end if;
    end function;
    pure function is_br_corner(i : integer; j : integer) return boolean is begin
        if is_bottom_edge(i,j) and is_right_edge(i,j) then
            return true;
        else
            return false;
        end if;
    end function;
begin
    i <= to_integer(address / 64);
    j <= to_integer(address mod 64);
 --   selector: selection_logic port map(i => i, j => j, o => correction);
  --  multiplier: sasta_matrix_multiplier port map(clk => clk, i1 => in_mat, i2 => correction, o => selected);

    process(clk) begin
        if (rising_edge(clk) and En = '1') then
            if(is_tl_corner(i,j)) then
                o <=  signed(resize(in_mat(1,1), 20) + in_mat(1,2) + in_mat(2,1) + in_mat(2,2));
            elsif (is_tr_corner(i,j)) then
                o <= signed(resize(in_mat(1,0), 20) + in_mat(1,1) + in_mat(2,0)+ in_mat(2,1));
            elsif (is_br_corner(i,j)) then
                o <= signed(resize(in_mat(0,0), 20) + in_mat(0,1) + in_mat(1,0) + in_mat(1,1));
            elsif (is_bl_corner(i,j)) then
                o <= signed(resize(in_mat(0,1), 20) + in_mat(0,2) + in_mat(1,1) + in_mat(1,2));
            elsif (is_left_edge(i,j)) then
                o <= signed(resize(in_mat(0,1), 20) + in_mat(0,2) + in_mat(1,1) + in_mat(1,2)
                           + in_mat(2,1) + in_mat(2,2));
            elsif (is_top_edge(i,j)) then
                o <= signed(resize(in_mat(1,0), 20) + in_mat(1,1) + in_mat(1,2) + in_mat(2,0)
                           + in_mat(2,1) + in_mat(2,2));
            elsif (is_right_edge(i,j)) then
                o <= signed(resize(in_mat(0,0), 20) + in_mat(0,1) + in_mat(1,0) + in_mat(1,1)
                           + in_mat(2,0) + in_mat(2,1));
            elsif (is_bottom_edge(i,j)) then
                o <= signed(resize(in_mat(0,0), 20) + in_mat(0,1) + in_mat(0,2)
                           + in_mat(1,0) + in_mat(1,1) + in_mat(1,2));
            else
                o <= signed(resize(in_mat(0,0), 20) + in_mat(0,1) + in_mat(0,2)
                           + in_mat(1,0) + in_mat(1,1) + in_mat(1,2)
                           + in_mat(2,0) + in_mat(2,1) + in_mat(2,2));
            end if;
        end if;
    end process;

--     process(clk)
--        variable li : integer range 0 to 3 := 0;
--        variable lj : integer range 0 to 3 := 0;
--        variable sum: signed(19 downto 0) := (others => '0');
--        variable waited : std_logic := '0';
--        variable done: std_logic := '0';
--        begin

--        if (rising_edge(clk))
--        then
--            if start_acc = '1' then
--                if (waited = '1') then
--                    if done = '0' then
--                        sum := sum + selected(li,lj);
--                        lj := lj + 1;
--                        if lj = 3 then
--                            lj := 0;
--                            li := li + 1;
--                        end if;
--                        if li = 3 then
--                            li := 0;
--                            lj := 0;  
--                            o <= sum;
--                            sum := (others => '0');
--                            waited := '0';
--                            done := '1';
--                        end if;
--                    end if;
--                 else
--                    waited := '1';
--                 end if;
--            end if;
--        end if;
--        end process;
        
--    FSM: process(in_mat, address, clk) begin
--        if rising_edge(clk) then
--            if (address'event or in_mat'event) then
--                cur_state <= rst;
--            elsif (acc_done = '1') then
--                cur_state <= done;
--            else
--                cur_state <= acc;
--            end if;
--        end if;
--    end process;
end Behavioral;
