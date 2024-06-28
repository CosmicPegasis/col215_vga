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
use IEEE.std_logic_arith.conv_std_logic_vector;
entity kernel_reader is
Port (
    clk: in std_logic;
    o: out kernel_matrix
);
end kernel_reader;

architecture Behavioral of kernel_reader is
component dist_mem_gen_0 IS
  PORT (
    a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    spo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END component;
    signal a : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal spo : STD_LOGIC_VECTOR(7 DOWNTO 0);
begin
  kernel: dist_mem_gen_0 port map(a => a, spo => spo);
  read: process(clk)
    variable i : integer := 0;
    variable j: integer := 0;
    variable done: integer := 0;
  begin
      if (rising_edge(clk)) then
        if (done < 2) then
            if (i = 0 and j = 0) then
                o(2, 2) <= (signed(spo));
                done := done + 1;
            elsif (j = 0) then
                o(i-1, 2) <= (signed(spo));
            else
                o(i, j-1) <= (signed(spo));
             end if;
            a <= conv_std_logic_vector(i * 3 + j, 4);
            j := j + 1;
            if (j = 3) then
                j := 0;
                i := i + 1;
            end if;
            if (i = 3) then
                i := 0;
                j := 0;
            end if;
        end if;
    end if;
    end process;
end architecture;
