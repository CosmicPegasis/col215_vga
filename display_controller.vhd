library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;
use work.my_util.all;
entity display_controller is
Port (
    -- FIXME clk
    clk: in std_logic;
    
    Hsync: inout std_logic;
    Vsync: inout std_logic;
--    inter_wraddress: inout std_logic_vector(11 downto 0);
--    t_norm_wdata: inout std_logic_vector(7 downto 0);
--    cur_state: inout state_type;
    vgaRed: out std_logic_vector(3 downto 0);
    vgaBlue: out std_logic_vector(3 downto 0);
    vgaGreen: out std_logic_vector(3 downto 0);
    done: out std_logic
    );
end display_controller;

architecture Behavioral of display_controller is
    use work.hcounter;
    use work.clock_divider;
    use work.vcounter;
    use work.image_processor;
    use work.image_normalizer;
    constant chsync : integer := 96;
    constant chback : integer := 48;
    constant chfront : integer := 16;
    constant chactive : integer := 640;
    constant cvsync : integer := 2;
    constant cvback : integer := 33;
    constant cvfront : integer := 10;
    constant cvactive : integer := 480;
    type state_type is (FILTER, NORM, DISP);
    
    signal pclk : std_logic;
    signal En: std_logic;
    signal hcnt: std_logic_vector(9 downto 0);
    signal vcnt: std_logic_vector(9 downto 0);
    signal inter_we: std_logic := '1';
    signal t_inter_wraddress: unsigned(11 downto 0) := (others => '0');
    signal t_norm_wraddress: std_logic_vector(11 downto 0) := (others => '0');
    signal t_disp_wraddress: std_logic_vector(11 downto 0) := (others => '0');
   -- signal t_wdata: integer;
    signal rst: std_logic;
    
    signal filter_done: std_logic := '0';
    signal norm_done: std_logic := '0';
    signal tvgaRed: std_logic_vector(3 downto 0);
    --signal norm_pixel: integer;
   component dist_mem_gen_2 is
        port( a: in std_logic_vector(11 downto 0);
              we: in std_logic;
              spo: out std_logic_vector(19 downto 0);
              d: in std_logic_vector(19 downto 0);
              clk: in std_logic);
    end component;
    component dist_mem_gen_3 is
        port( a: in std_logic_vector(11 downto 0);
              we: in std_logic;
              spo: out std_logic_vector(7 downto 0);
              d: in std_logic_vector(7 downto 0);
              clk: in std_logic);
    end component;
    signal fin_wraddress: std_logic_vector(11 downto 0) := ( others => '0');
    signal fin_spo: std_logic_vector(7 downto 0) := (others => '0');
    signal fin_wdata: std_logic_vector(7 downto 0) := (others => '0');
    signal fin_we: std_logic := '1';
    
    signal max: signed(19 downto 0);
    signal min: signed(19 downto 0);
  --  signal norm_en : std_logic;
    
    signal t_filter_wraddress: unsigned(11 downto 0) := (others => '0');
 --   signal t_fin_wdata: signed(15 downto 0) := (others => '1');
  --  signal t_done: std_logic;
    
--    signal inter_we : std_logic;
  --  signal inter_wraddress : std_logic_vector(11 downto 0);
  
     signal inter_wraddress: std_logic_vector(11 downto 0);
     signal cur_state: state_type := FILTER;
   signal t_norm_wdata : std_logic_vector(7 downto 0);
   signal inter_spo : std_logic_vector(19 downto 0);
 signal inter_wdata : std_logic_vector(19 downto 0);
    signal t_inter_wdata : signed(19 downto 0);
    
    
    signal mux_min: signed(19 downto 0) := (others => '0');
    signal mux_max : signed(19 downto 0) := (0 => '1', others => '0');
 --   signal norm_pixel : integer range 0 to 255;
begin
    clk_divider: entity clock_divider  port map(clk => clk, pix_clk => pclk);
  --  clk_divider2: entity clock_divider  port map(clk => pclk, pix_clk => ppclk);
    h : entity hcounter port map(pix_clk => pclk,rst => rst, hcnt => hcnt, En=> En);
    v: entity vcounter port map(pix_clk => pclk,rst=> rst, En=> En,vcnt => vcnt);
    final: dist_mem_gen_3 port map(a => fin_wraddress, spo => fin_spo,
                  d => fin_wdata, we => fin_we, clk => clk);
    prcsr: entity image_processor port map(clk => clk, address => t_filter_wraddress, 
            pixel => t_inter_wdata, done => filter_done, min => min, max => max); 
   single_pix_norm: entity image_normalizer port map(clk => clk, min => mux_min, max => mux_max, 
              wdata => t_norm_wdata, En => filter_done,
              std_logic_vector(wraddress) => t_norm_wraddress,  
              spo => inter_spo, done => norm_done);
    inter: dist_mem_gen_2 port map(clk => clk, a => inter_wraddress, spo => inter_spo, 
                                d => std_logic_vector(t_inter_wdata), we => inter_we);        
    
    vgaRed <= tvgaRed;                  
    vgaGreen <= tvgaRed;
    vgaBlue <= tvgaRed;
    done <= not fin_we;
    fin_we <= not norm_done;
   -- inter_wraddress <= (others => '0');
  --  inter_we <= '0';
   -- t_inter_wdata <= (others => '1');
    inter_we <= not filter_done;
    -- temporary signals
  --  clk <= not clk after 5 ns;
     norm_mux: process(clk) begin
        if rising_edge(clk) then
            if (cur_state = NORM) then
               fin_wraddress <= std_logic_vector(t_norm_wraddress);  
          --     t_norm_wdata <= std_logic_vector(to_unsigned(norm_pixel, 8)); 
            else
               fin_wraddress <= std_logic_vector(t_disp_wraddress);
            end if;
         end if;
    end process;
    
    process(pclk)
    begin
        if rising_edge(pclk) then
            if (hcnt >= chfront + chactive and hcnt < chfront + chactive +  chsync) then
                Hsync <= '0';
            else
                Hsync <= '1';
            end if;
        
            if (vcnt >= cvfront + cvactive and vcnt < cvfront + cvactive +  cvsync) then
                Vsync <= '0';
            else 
                Vsync <= '1';
            end if;
         end if;
    end process;
    
    process(pclk) begin -- FIXME
        if rising_edge(pclk) then
            if (cur_state = DISP) then
                if (HSync = '1' and VSync = '1' and hcnt < 64 and vcnt < 64) then    
                    t_disp_wraddress <= (vcnt(5 downto 0) & "000000") + hcnt;
                    tvgaRed <= fin_spo(7 downto 4);
                else
                    tvgaRed <= "0000";
                    t_disp_wraddress <= (vcnt(5 downto 0) & "000000") + hcnt;
                end if;
                rst <= '0';
            else
                rst <= '1';
                fin_wdata <= t_norm_wdata;
            end if;
        end if;
    end process;
    
    
--    process(pclk)
--        variable tick: integer range 0 to 10000 := 0;
--    begin
--        if rising_edge(pclk) then
--            if (cur_state = NORM) then
--                if tick = 1000 then
--                    if t_norm_wraddress = 4095 then
--                        fin_we <= '0';
--                     --   cur_state <= 2;
--                        norm_done <= '1';
--                    else
--                        t_norm_wraddress <= t_norm_wraddress + 1;
--                        tick := 0;
--                    end if;
--                else
--                  --  t_norm_wdata <= (others => '1');
--                    tick := tick + 1;
--                end if;  
--            end if;   
--       end if; 
--    end process;
    
    process(clk) begin
        if rising_edge(clk) then
            if cur_state = FILTER then
                inter_wraddress <= std_logic_vector(t_filter_wraddress);
           --     inter_we <= '1';
            else
                inter_wraddress <= t_norm_wraddress;
              --  inter_we <= '0';
            end if;
        end if;
    end process;
    
    process(clk) begin
        if rising_edge(clk) then
            if (cur_state = NORM) then
                mux_min <= min;
                mux_max <= max;
             else
                mux_min <= (others => '0');
                mux_max <= (0 => '1', others => '0');
             end if;
        end if;
    end process;
    
    FSM: process(clk) begin
        if rising_edge(clk) then
            if (filter_done = '1' and cur_state = FILTER) then
                cur_state <= NORM;
               -- norm_en <= '1';
            elsif (norm_done = '1' and cur_state = NORM) then
                cur_state <= DISP;
            end if;
        end if;
    end process; 
end Behavioral;

