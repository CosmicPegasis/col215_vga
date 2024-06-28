library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.my_util.all;
use IEEE.std_logic_arith.conv_std_logic_vector;
entity img_reader is
Port (
    clk: in std_logic;
    index: in unsigned(11 downto 0);
    o: out matrix
);
end img_reader;

architecture Behavioral of img_reader is
component dist_mem_gen_1 IS
  PORT (
    a : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    spo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END component;
use work.in_address_proc;
signal a : STD_LOGIC_VECTOR(11 DOWNTO 0);
signal spo : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal add_mat : amatrix;
begin
img: dist_mem_gen_1 port map(a => a, spo => spo);
proc_address: entity in_address_proc port map(address => index, o => add_mat);
process(clk)
    variable i : integer := 0;
    variable j : integer := 0;
    variable tick: integer range 0 to 10;
begin
    if (rising_edge(clk)) then
        if (i = 0 and j = 0) then
            o(2, 2) <= (unsigned(spo));
        elsif (j = 0) then
            o(i-1, 2) <= (unsigned(spo));
          --  report integer'Image(to_integer(unsigned(spo)));
        else
            o(i, j-1) <= (unsigned(spo));
          --  report integer'Image(to_integer(unsigned(spo)));
         end if;
        a <= std_logic_vector(to_unsigned(add_mat(i, j), 12));
        tick := tick + 1;
        if (tick = 1) then
            j := j + 1;
            tick := 0;
        end if;
        if (j = 3) then
            j := 0;
            i := i + 1;
        end if;
        if (i = 3) then
            i := 0;
            j := 0;
        end if;
    end if;
end process;
end Behavioral;
