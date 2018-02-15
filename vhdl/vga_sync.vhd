-- *******************************
-- * VGA synchronization circuit *
-- *******************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_sync is

  port( 
    clk     , rst     : in  std_logic;  -- 50 MHz clock
    px_clk  , data_en : out std_logic;  -- Video on
    hsync   , vsync   : out std_logic;
    pixel_x , pixel_y : out std_logic_vector (9 downto 0)
  );

end vga_sync;

architecture arch of vga_sync is

  -- VGA 640-by-480 sync parameters
  constant HD: integer := 640;  -- horizontal display area
  constant HF: integer :=  16;  -- h. front porch
  constant HB: integer :=  48;  -- h. back porch
  constant HR: integer :=  96;  -- h. retrace

  constant VD: integer := 480;  -- vertical display area
  constant VF: integer :=  10;  -- v. front porch
  constant VB: integer :=  33;  -- v. back porch
  constant VR: integer :=   2;  -- v. retrace

  -- mod-2 counter
  signal mod2_reg, mod2_next: std_logic;

  -- sync counters
  signal h_count_reg, h_count_next: unsigned(9 downto 0);
  signal v_count_reg, v_count_next: unsigned(9 downto 0);

  -- output buffer
  signal h_sync_reg, h_sync_next: std_logic;
  signal v_sync_reg, v_sync_next: std_logic;

  -- status signal
  signal pixel_tick, h_end, v_end: std_logic;

begin

  -- registers
  process (clk,rst) begin

    if rst='0' then
      mod2_reg    <= '0';
      v_count_reg <= (others=>'0');
      h_count_reg <= (others=>'0');
      v_sync_reg  <= '0';
      h_sync_reg  <= '0';

    elsif rising_edge(clk) then
      mod2_reg    <= mod2_next;
      v_count_reg <= v_count_next;
      h_count_reg <= h_count_next;
      v_sync_reg  <= v_sync_next;
      h_sync_reg  <= h_sync_next;

    end if;

  end process;

  -- mod-2 circuit to generate 25 MHz enable tick
  mod2_next <= not mod2_reg;

  -- 25 MHz pixel tick
  pixel_tick <= mod2_reg;  -- '1' when mod2_reg='1' else '0';

  -- status
  h_end <=  -- end of horizontal counter
    '1' when h_count_reg = (HD + HF + HB + HR - 1) else -- 799
    '0';
  v_end <=  -- end of vertical counter
    '1' when v_count_reg = (VD + VF + VB + VR - 1) else -- 524
    '0';

  -- mod-800 horizontal sync counter
  process (pixel_tick, h_count_reg, h_end) begin

    if pixel_tick = '1' then  -- 25 MHz tick

      if h_end = '1' then
        h_count_next <= (others=>'0');

      else
        h_count_next <= h_count_reg + 1;

      end if;

    else
      h_count_next <= h_count_reg;

    end if;

  end process;

  -- mod-525 vertical sync counter
  process (pixel_tick, v_count_reg, h_end,v_end) begin

    if pixel_tick = '1' and h_end = '1' then

      if v_end = '1' then
        v_count_next <= (others=>'0');

      else
        v_count_next <= v_count_reg + 1;

      end if;

    else
      v_count_next <= v_count_reg;

    end if;
 
 end process;

  -- horizontal and vertical sync, buffered to avoid glitch
  h_sync_next <=
    '1' when (h_count_reg <  (HD + HF))                -- 656
          or (h_count_reg >= (HD + HF + HR - 1)) else  -- 751
    '0';
  v_sync_next <=
    '1' when (v_count_reg <  (VD + VF))                -- 490
          or (v_count_reg >= (VD + VF + VR - 1)) else  -- 491
    '0';

  -- video on/off
  data_en <=
    '1' when (h_count_reg < HD) and (v_count_reg < VD) else
    '0';

  -- output signal
  px_clk <= pixel_tick;
  pixel_x <= std_logic_vector(h_count_reg);
  hsync   <= h_sync_reg;
  pixel_y <= std_logic_vector(v_count_reg);
  vsync   <= v_sync_reg;
  
end arch;
