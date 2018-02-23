-- ****************************
-- * VGA dot tracking circuit *
-- ****************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dot_xy is

  generic(
    X_DIM     : integer := 128;  -- Desired x dimension
    X_DIM_BITS: integer :=   7;  -- Bits required for the x dimension
    X_RES     : integer := 640;  -- Horizontal resolution
    X_RES_BITS: integer :=  10;

    Y_DIM     : integer := 128;  -- Desired y dimension
    Y_DIM_BITS: integer :=   7;  -- Bits required for the y dimension
    Y_RES     : integer := 480;  -- Vertical resolution
    Y_RES_BITS: integer :=  10
  );

  port(
    clk, rst: in  std_logic;
    px_x    : in  std_logic_vector(X_RES_BITS-1 downto 0);
    px_y    : in  std_logic_vector(Y_RES_BITS-1 downto 0);
    w_addr  : out std_logic_vector(Y_DIM_BITS + X_DIM_BITS - 1 downto 0);
    we, bitmap_on: out std_logic
  );

end dot_xy;

architecture arch of dot_xy is

  signal pix_x: unsigned(X_RES_BITS-1 downto 0);
  signal pix_y: unsigned(Y_RES_BITS-1 downto 0);

  ------------------
  -- Dot location --
  ------------------

  -- register to keep track of dot location
  signal dot_x_reg, dot_x_next: unsigned(X_RES_BITS-1 downto 0);
  signal dot_y_reg, dot_y_next: unsigned(Y_RES_BITS-1 downto 0);

begin

  -- miscellaneous signals
  pix_x <= unsigned(px_x);
  pix_y <= unsigned(px_y);

  -- Video RAM interface
  w_addr <= std_logic_vector(
    dot_y_reg(Y_DIM_BITS-1 downto 0) & dot_x_reg(X_DIM_BITS-1 downto 0)
  );
  we <= '1';

  -- Registers
  process(clk, rst) begin

    if rst = '0' then
      dot_x_reg <= (others => '0');
      dot_y_reg <= (others => '0');

    elsif(rising_edge(clk)) then
      dot_x_reg <= dot_x_next;
      dot_y_reg <= dot_y_next;

    end if;

  end process;
  
  -- Pixel within bit map area
  bitmap_on <=
    '1' when (pix_x <= X_DIM-1 and pix_y <= Y_DIM-1) else
    '0';

  -- Dot position
  dot_x_next <= pix_x;
  dot_y_next <= pix_y;

end arch;
