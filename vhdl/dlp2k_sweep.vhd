-- **************************************************
-- * DLP 2000 LightCrafter Display EVM test circuit *
-- **************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dlp2k is

  port(
    clk, rst : in  std_logic;
    led      : out std_logic_vector( 4 downto 0);

    -- Parallel I/F Video Data
    data : out std_logic_vector(23 downto 0);

    -- Parallel I/F Video Control
    hsync, vsync, pclk, dataen  : out std_logic;

    -- System Control Lines
    gpio5, gpio_init_done       : out std_logic;
    proj_on_ext , host_presentz : out std_logic
  );

end dlp2k;

architecture arch of dlp2k is

  signal data_reg: std_logic_vector(23 downto 0);
  signal video_on: std_logic;  -- Signal needed for data activation

  signal clk_div: std_logic;  -- Counter driver signal
  signal clk_divider: unsigned(25 downto 0);
  signal count_int: std_logic_vector(4 downto 0);


begin

  -- Instantiate a VGA synchronization circuit
  vga_sync_unit: entity work.vga_sync(arch)
    port map(
             clk       => clk,
             rst       => rst,
             px_clk    => pclk,
             video_on  => video_on,
             pixel_x   => open,
             pixel_y   => open,
             hsync     => hsync,
             vsync     => vsync
    );

  -- Instantiate a free runing binary counter circuit
  bin_counter_unit: entity work.free_run_bin_counter(arch)
    generic map(N => 5)
    port map(
      clk      => clk_div,
      rst      => rst,
      max_tick => open,
      count    => count_int
    );

  -- Instantiate a decoder circuit
  decoder_unit: entity work.decoder(arch)
    port map(
      a  => count_int,
      x  => data_reg,
      en => '1'
    );

  process(clk, rst) begin
    if(rst='0') then
      clk_divider <= (others=>'0');
    elsif(rising_edge(clk)) then
      clk_divider <= clk_divider + 1;
    end if;
  end process;

  clk_div <= clk_divider(25);

  data     <= data_reg when video_on = '1' else (others=>'0');
  led  <= count_int;
  dataen <= video_on;
  gpio5          <= '0';
  gpio_init_done <= '1';
  host_presentz  <= '1';
  proj_on_ext    <= '1';

end arch;
