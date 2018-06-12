-- **************************************************
-- * DLP 2000 LightCrafter Display EVM test circuit *
-- **************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dlp2k is
  port(
    clk  , rst   : in  std_logic;
    data         : out std_logic_vector(23 downto 0);
    hsync, vsync, px_clk, video_on : out std_logic;
    proj_on , host_pnt : out std_logic
  );
end dlp2k;

architecture arch of dlp2k is

  constant BUSWIDTH: integer := 24;

  signal data_reg: std_logic_vector(23 downto 0);
  signal video_on_int: std_logic;  -- Signal needed for data activation
  signal px_clk_int, s_in_int: std_logic;


begin

  -- Instantiate a VGA synchronization circuit
  vga_sync_unit: entity work.vga_sync(arch)
    port map(
             clk       => clk,
             rst       => rst,
             px_clk    => px_clk_int,
             video_on  => video_on_int,
             pixel_x   => open,
             pixel_y   => open,
             hsync     => hsync,
             vsync     => vsync
    );

  -- Instantiate a free runing binary counter circuit
  bin_counter_unit: entity work.free_run_bin_counter(arch)
    generic map(N => 4)
    port map(
      clk      => clk,
      rst      => rst,
      max_tick => s_in_int,
      count    => open
    );

  -- Instantiate a free runing shift register circuit
  shift_reg_unit: entity work.free_run_shift_reg(arch)
    generic map(N => BUSWIDTH)
    port map(
      clk   => px_clk_int,
      rst   => rst,
      s_in  => s_in_int,
      s_out => data_reg
    );

  data     <= data_reg when video_on_int = '1' else (others=>'0');
  px_clk   <= px_clk_int;
  host_pnt <= '1';
  proj_on  <= '1';

end arch;
