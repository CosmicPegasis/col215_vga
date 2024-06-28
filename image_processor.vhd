library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
--use IEEE.std_logic_arith.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
use work.my_util.all;
entity image_processor is
Port (
    clk : in std_logic;
    address: out unsigned(11 downto 0);
    pixel: inout signed(19 downto 0);
    done: inout std_logic := '0';
    max: inout signed(19 downto 0) := (19 => '1', others => '0');
    min: inout signed(19 downto 0) := (19 => '0',others => '1')
);
end image_processor;

architecture Behavioral of image_processor is
    signal index: unsigned(11 downto 0) := (others => '0');
    use work.img_reader;
    use work.kernel_reader;
    use work.sasta_matrix_multiplier;
    use work.accumulator;
    signal kernel : kernel_matrix;
   -- signal kernel: matrix;
   signal img: matrix;
   signal raw: mmatrix;
   signal intermediate_pixel: signed (19 downto 0);
   signal start_acc: std_logic := '0';
   signal En: std_logic := '0';
begin
    reader_img: entity img_reader port map(clk => clk, index => index, o => img);
    reader_kernel: entity kernel_reader port map(clk => clk, o => kernel);
    multiplier: entity sasta_matrix_multiplier port map(clk => clk, i1 => img, i2 => kernel, o => raw);
    accumulate: entity accumulator port map(En => En, clk => clk, in_mat => raw, address => index, 
    o => intermediate_pixel);
    address <= index;
    process(clk) 
        variable tick: unsigned(9 downto 0) := (others => '0');
    begin
        FSM: if rising_edge(clk) then
            if done = '0' then
                tick := tick + 1;
                if (index = 4095 and tick = 22) then
                    tick := (others => '0');
                    done <= '1';
                    index <= (others => '1');
                end if;
                if (tick = 19) then
                    En <= '1';
                end if;
                if (tick = 22) then
                    index <= index + 1;
                    tick := (others => '0');
                  --  start_acc <= '0';
                    En <= '0';
                end if;
            else
                index <= (others => '1');
                done <= '1';
            end if;
        end if;
    end process;
--    process(index) begin
--        if intermediate_pixel > 255 then
--            pixel <= (others => '1');
--        elsif intermediate_pixel < 0 then
--            pixel <= (others => '0');
--        else
--            pixel <= to_signed(intermediate_pixel, 16);
--        end if;
--    end process; 
    process(index) begin
        pixel <= intermediate_pixel;
    end process;
    
    process(index, clk)
        variable waited: std_logic := '0';
    begin
        if rising_edge(clk) then
             if (waited = '1') then
                if max < intermediate_pixel then
                    max <= intermediate_pixel;
                    
                 end if;
                if min > intermediate_pixel then
                    min <= intermediate_pixel;
                end if;
            else
                waited := '1';
            end if;
        end if;
    end process;
end Behavioral;
