library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity image_normalizer is
Port (
    clk : in std_logic;
    min, max: in  signed(19 downto 0);
   -- output_pixel: out integer range 0 to 255;
    signal wraddress: inout unsigned(11 downto 0) := (others => '0');
    signal done: inout std_logic := '0';
    signal wdata: out std_logic_vector(7 downto 0);
    signal En : in std_logic;
    signal spo:  in std_logic_vector(19 downto 0)
    );
end image_normalizer;

architecture Behavioral of image_normalizer is
type state is (SUB, MUL, DIV);
signal norm_state : state := SUB;
-- signal temp: integer range -65535 to 65535 := -65535;
--signal temp : integer range -33554432 to 33554432 ;
signal temp: unsigned(19 downto 0);
signal temp2: unsigned(27 downto 0);
signal multi: unsigned(7 downto 0) := (others => '1');
signal temp3 : unsigned(27 downto 0);
signal diff: unsigned(19 downto 0);

begin
   diff <= unsigned(max - min);
  -- output_pixel <= ((input_pixel - min) * 255) / diff;
    FSM: process(clk)
        variable tick : integer range 0 to 100 := 0; 
    begin
        if rising_edge(clk) then
            if done = '0' and En = '1' then
                tick := tick + 1;
                if (tick = 10) then
                    norm_state <= MUL;
                elsif (tick = 50) then
                    norm_state <= DIV;
                elsif (tick = 100) then
                    tick := 0;
                   -- wdata <= std_logic_vector(to_unsigned(temp, 8));
                    norm_state <= SUB;
                    wdata <= std_logic_vector(temp3(7 downto 0));
                    wraddress <= wraddress + 1;
                    if wraddress = 4095 then
                        done <= '1';
                    end if;
                end if;   
            end if;
         end if;
    end process;
    process(norm_state) begin
        if (norm_state = SUB) then
            temp <= unsigned((signed(spo) - min));
        elsif (norm_state = MUL) then
            temp2 <= temp * multi;
        elsif (norm_state = DIV) then
            temp3 <= temp2 / diff;
        end if;
    end process;
end Behavioral;
