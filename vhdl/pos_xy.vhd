-- ***********************************
-- * Pixel position tracking circuit *
-- ***********************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pos_xy is

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

end pos_xy;

architecture arch of pos_xy is

  -- register to keep track of pixel position location
  signal pos_x_reg, pos_x_next: unsigned(X_RES_BITS-1 downto 0);
  signal pos_y_reg, pos_y_next: unsigned(Y_RES_BITS-1 downto 0);

begin

  -- Framebuffer interface
  w_addr <= std_logic_vector(
                             pos_y_reg(Y_DIM_BITS-1 downto 0) &
                             pos_x_reg(X_DIM_BITS-1 downto 0)
                            );
  we <= '1';

  -- Registers
  process(clk, rst) begin

    if rst = '0' then
      pos_x_reg <= (others => '0');
      pos_y_reg <= (others => '0');

    elsif(rising_edge(clk)) then
      pos_x_reg <= pos_x_next;
      pos_y_reg <= pos_y_next;

    end if;

  end process;

  -- Pixel within bit map area
  bitmap_on <=
    '1' when (unsigned(px_x) <= X_DIM-1 and unsigned(px_y) <= Y_DIM-1) else
    '0';

  -- Pixel position
  pos_x_next <= unsigned(px_x);
  pos_y_next <= unsigned(px_y);

end arch;
