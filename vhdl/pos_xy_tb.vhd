-- *****************************************************
-- * Testbench for the pixel position tracking circuit *
-- *****************************************************

library ieee; 
use ieee.std_logic_1164.all;

entity pos_xy_tb is
end pos_xy_tb;

architecture arch_tb of pos_xy_tb is

  constant T: time := 20 ns;  -- Clock period

  -- Inputs
  signal clk , rst  : std_logic;
  signal px_x, px_y : std_logic_vector(9 downto 0);

  -- Outputs
  signal w_addr: std_logic_vector(13 downto 0);
  signal we, bitmap_on: std_logic;

begin

  -- Instantiate a VGA synchronization circuit
  vga_sync_unit: entity work.vga_sync(arch)
    port map(
             clk      => clk,
             rst      => rst,
             px_clk   => open,
             video_on => open,
             pixel_x  => px_x,
             pixel_y  => px_y,
             hsync    => open,
             vsync    => open
    );

  -- Instantiate a VGA dot tracking circuit
  pos_xy_unit: entity work.pos_xy(arch)
    port map(
             clk       => clk,
             rst       => rst,
             px_x      => px_x,
             px_y      => px_y,
             we        => we,
             bitmap_on => bitmap_on,
             w_addr     => w_addr
    );

  -- Clock
  process begin
    clk <= '0';
    wait for T/2;
    clk <= '1';
    wait for T/2;
  end process;

  -- Reset
  rst <= '0', '1' after T/2;

  -- Other stimulus
  process begin

    for i in 1 to 1000000 loop
      wait until falling_edge(clk);
    end loop;

    -- Terminate simulation
    assert false
      report "Simulation Completed"
    severity failure;

  end process;

end arch_tb;