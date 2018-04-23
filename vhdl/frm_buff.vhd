-- ***************************************************************************
-- * Frame Buffer
-- * The read and write address size is determined by the output draw area
-- * that in this case is 128x64.
-- * 128 -> 7 bits, 64 -> 6 bits
-- * address size = 7 + 6 = 13
-- ***************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity frm_buff is

  generic(
    -------------------------------------
    -- Dimensions of the output draw area
    -------------------------------------
    X_DIM     : integer := 128;  -- Desired x dimension
    X_DIM_BITS: integer :=   7;
    Y_DIM     : integer :=  64;  -- Desired y dimension
    Y_DIM_BITS: integer :=   6;
    BPP       : integer :=   8  -- Bits per pixel
  );

  port(
    clk       , rst     : in  std_logic;
    bitmap_on , data_en : in  std_logic;
    red, green, blue    : in  std_logic_vector( 7 downto 0);
    r_addr    , w_addr  : in  std_logic_vector(13 downto 0);
    rgb                 : out std_logic_vector(23 downto 0)
  );

end frm_buff;

architecture arch of frm_buff is

  signal bitmap_on: std_logic;
  -- The size of the px vector is dependent on the resolution
  signal px_x , px_y : std_logic_vector(9 downto 0);
  signal r_in , g_in , b_in : std_logic_vector(BPP-1 downto 0);
  signal r_out, g_out, b_out: std_logic_vector(BPP-1 downto 0);
  signal w_addr, r_addr:
    std_logic_vector(X_DIM_BITS + Y_DIM_BITS - 1 downto 0);

begin

  -- memory inputs
  r_in <= red;
  g_in <= green;
  b_in <= blue;
  r_addr <= std_logic_vector(
    px_y(Y_DIM_BITS-1 downto 0) & px_x(X_DIM_BITS-1 downto 0)
  );

  -- Instantiate 3 RAMs
  ram_r_unit: entity work.ram(arch)
    generic map(ADDR_WIDTH => X_DIM_BITS + Y_DIM_BITS,
                DATA_WIDTH => BPP)

    port map(
      clk    => clk,
      we     => data_en,
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
             we     => data_en,
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
             we     => data_en,
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
