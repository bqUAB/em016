-- ***************************************************************************
-- Frame Buffer
-- The memory size is determined by the output draw area that in this case is
-- 640x480.
-- 640 -> 10 bits, 480 -> 9 bits
-- address size = 10 + 9 = 19
-- ***************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity frm_buff is

  generic(
    -------------------------------------
    -- Dimensions of the output draw area
    -------------------------------------
    X_DIM     : integer := 640;  -- Desired x dimension
    X_DIM_BITS: integer :=  10;
    Y_DIM     : integer := 480;  -- Desired y dimension
    Y_DIM_BITS: integer :=   9;
    BPP       : integer :=   8  -- Bits per pixel
  );

  port(
    clk     : in  std_logic;
    rst     : in  std_logic;
    w_en    : in  std_logic;
    rgb_in  : in  std_logic_vector(23 downto 0);
    r_addr  : in  std_logic_vector(19 downto 0);
    w_addr  : in  std_logic_vector(19 downto 0);
    rgb_out : out std_logic_vector(23 downto 0)
  );

end frm_buff;

architecture arch of frm_buff is

  signal video_on: std_logic;
  signal r_in , g_in , b_in : std_logic_vector(BPP-1 downto 0);
  signal r_out, g_out, b_out: std_logic_vector(BPP-1 downto 0);
  signal px_xy: std_logic_vector(X_DIM_BITS + Y_DIM_BITS - 1 downto 0);

begin

  -- memory inputs
  r_in <= rgb_in(23 downto 16);
  g_in <= rgb_in(15 downto  8);
  b_in <= rgb_in( 7 downto  0);
  px_xy <= std_logic_vector(px_y(Y_DIM_BITS-1 downto 0) & px_x(X_DIM_BITS-1 downto 0)
  );

  -- Instantiate 3 RAMs
  ram_r_unit: entity work.ram(arch)
    generic map(ADDR_WIDTH => X_DIM_BITS + Y_DIM_BITS,
                DATA_WIDTH => BPP)

    port map(
      clk    => clk,
      we     => w_en,
      w_addr => w_addr,
      r_addr => r_addr,
      d      => din_r,
      q      => dout_r
    );

  ram_g_unit: entity work.ram(arch)
    generic map(ADDR_WIDTH => X_DIM_BITS + Y_DIM_BITS,
                DATA_WIDTH => BPP)

    port map(
             clk    => clk,
             we     => w_en,
             w_addr => w_addr,
             r_addr => r_addr,
             d      => din_g,
             q      => dout_g
    );

  ram_b_unit: entity work.ram(arch)
    generic map(ADDR_WIDTH => X_DIM_BITS + Y_DIM_BITS,
                DATA_WIDTH => BPP)

    port map(
             clk    => clk,
             we     => w_en,
             w_addr => w_addr,
             r_addr => r_addr,
             d      => din_b,
             q      => dout_b
    );

  -- RGB multiplexing circuit
  process(w_en, bitmap_on, dout_r, dout_g, dout_b) begin

    if w_en = '0' then  -- Off

      red   <= (others=>'0');
      green <= (others=>'0');
      blue  <= (others=>'0');

    else

      if bitmap_on = '1' then
        red   <= dout_r;
        green <= dout_g;
        blue  <= dout_b;

      else  -- white background

        red   <= (others=>'1');
        green <= (others=>'1');
        blue  <= (others=>'1');

      end if;

    end if;

  end process;

end arch;
