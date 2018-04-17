-- **************************************************
-- * DLP 2000 LightCrafter Display EVM test circuit *
-- **************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dlp2k is
  port(
    clk  , rst   : in  std_logic;
    sw           : in  std_logic_vector( 2 downto 0);
    data         : out std_logic_vector(23 downto 0);
    hsync, vsync, px_clk, video_on : out std_logic;
    proj_on , host_pnt : out std_logic
  );
end dlp2k;

architecture arq of dlp2k is

  signal data_reg: std_logic_vector(23 downto 0);
  signal video_on_int : std_logic;  -- Signal needed for RGB register

begin

  -- Instantiate a VGA synchronization circuit
  vga_sync_unit: entity work.vga_sync(arch)
    port map(
             clk       => clk,
             rst       => rst,
             px_clk    => px_clk,
             video_on  => video_on_int,
             pixel_x   => open,
             pixel_y   => open,
             hsync     => hsync,
             vsync     => vsync
    );

  -- RGB buffer
  process(clk, rst, sw) begin

    if rst = '0' then
      data_reg <= (others => '0');

    elsif(rising_edge(clk)) then

       case sw is

        when "001"  => data_reg <= "111111110000000000000000";
        when "010"  => data_reg <= "000000001111111100000000";
        when "100"  => data_reg <= "000000000000000011111111";
        when others => data_reg <= "111111111111111111111111";

       end case;

    end if;

  end process;

  data      <= data_reg when video_on_int = '1' else "000000000000000000000000";
  video_on <= video_on_int;
  host_pnt <= '1';
  proj_on  <= '1';

end arq;
