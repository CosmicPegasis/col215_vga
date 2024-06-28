library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use work.my_util.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity selection_logic is
Port (
i : in integer;
j : in integer;
o: out matrix);
-- Mapping of out is in the following manner ( because I'm too lazy to make shared enumerations - Aviral)
-- 0 to 3 all corners in clockwise manner starting with top left
-- 4 to 7 all edges in clockwise manner starting with left edge
-- 8 normal pixel
end selection_logic;

architecture Behavioral of selection_logic is
type matrix is array(2 downto 0, 2 downto 0) of std_logic_vector(3 downto 0);
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
-- Can't think of something better than just hardcoding the addresses.
process(i, j) begin
    if(is_tl_corner(i,j)) then
        o <= ((0, 0, 0), 
              (0, 1, 1), 
              (0, 1, 1));
    elsif (is_tr_corner(i,j)) then
        o <= ((0, 0, 0),
               (1, 1, 0),
               (1, 1, 0));
    elsif (is_br_corner(i,j)) then
         o <= ((1, 1, 0),
               (1, 1, 0),
               (0, 0, 0));
    elsif (is_bl_corner(i,j)) then
        o <= ((0, 1, 1),
              (0, 1, 1),
              (0, 0, 0));
    elsif (is_left_edge(i,j)) then
        o <= ((0, 1, 1),
              (0, 1, 1),
              (0, 1, 1));
    elsif (is_top_edge(i,j)) then
        o <= ((0, 0, 0),
              (1, 1, 1),
              (1, 1, 1));
    elsif (is_right_edge(i,j)) then
        o <= ((1, 1, 0),
              (1, 1, 0),
              (1, 1, 0));
    elsif (is_bottom_edge(i,j)) then
        o <= ((1, 1, 1),
              (1, 1, 1),
              (0, 0, 0));
    else
        o <= ((1, 1, 1),
              (1, 1, 1),
              (1, 1, 1));
    end if;
end process;
end Behavioral;
