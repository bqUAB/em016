-- *********************************************
-- * Pixel generation with a bit-mapped scheme *
-- *********************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uses debounced switches as RBG inputs
entity px_gen is
  port(
    clk  , rst        : in  std_logic;
    rgb               : in  std_logic_vector(23 downto 0);
    red  , green, blue: out std_logic_vector( 7 downto 0);
    hsync, vsync      : out std_logic
  );
end px_gen;

architecture arch of px_gen is

  ----------------
  -- Dimensions --
  ----------------

  constant X_DIM     : integer :=  64;  -- Desired x dimension
  constant X_DIM_BITS: integer :=   6;
  constant Y_DIM     : integer := 480;  -- Desired y dimension
  constant Y_DIM_BITS: integer :=   9;
  constant BPP       : integer :=   8;  -- Bits per pixel

  signal px_clk, data_en, we, bitmap_on: std_logic;
  signal px_x , px_y : std_logic_vector(9 downto 0);  
  signal din_r, dout_r, din_g, dout_g, din_b, dout_b:
    std_logic_vector(BPP-1 downto 0);
  signal w_addr, r_addr: std_logic_vector(X_DIM_BITS + Y_DIM_BITS - 1 downto 0);

begin

  -- Instantiate a VGA sinchronization circuit
  vga_sync_unit: entity work.vga_sync(arch)
    port map(
             clk      => clk,
             rst      => rst,
             px_clk   => px_clk,
             data_en  => data_en,
             pixel_x  => px_x,
             pixel_y  => px_y,
             hsync    => hsync,
             vsync    => vsync
    );

  -- Instantiate a VGA dot tracking circuit
  dot_xy_unit: entity work.dot_xy(arch)
    generic map(
        X_DIM      => X_DIM,
        Y_DIM      => Y_DIM,
        X_DIM_BITS => X_DIM_BITS,
        Y_DIM_BITS => Y_DIM_BITS
    )

    port map(
             clk       => clk,
             rst       => rst,
             px_x      => px_x,
             px_y      => px_y,
             we        => we,
             bitmap_on => bitmap_on,
             w_addr    => w_addr
    );

  -- memory inputs
  din_r  <= rgb(23 downto 16);
  din_g  <= rgb(15 downto  8);
  din_b  <= rgb( 7 downto  0);
  r_addr <= std_logic_vector(
    px_y(Y_DIM_BITS-1 downto 0) & px_x(X_DIM_BITS-1 downto 0)
  );

  -- Instantiate 3 RAM
  ram_r_unit: entity work.ram(arch)
    generic map(ADDR_WIDTH => X_DIM_BITS + Y_DIM_BITS,
                DATA_WIDTH => BPP)

    port map(
             clk    => clk,
             we     => we,
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
             we     => we,
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
             we     => we,
             w_addr => w_addr,
             r_addr => r_addr,
             d      => din_b,
             q      => dout_b
    );

  -- RGB multiplexing circuit
  process(data_en, bitmap_on, dout_r, dout_g, dout_b) begin

    if data_en = '0' then  -- Off

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
