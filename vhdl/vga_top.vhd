-- ************************************
-- * VGA synchronization test circuit *
-- ************************************

library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_top is
  port(
    clk  , rst   : in  std_logic;
    sw           : in  std_logic_vector(2 downto 0);
    rgb          : out std_logic_vector(2 downto 0);
    hsync, vsync, px_clk, video_on : out std_logic
  );
end vga_top;

architecture arq of vga_top is

  signal rgb_reg : std_logic_vector(2 downto 0);
  signal data_en  : std_logic;

begin

  -- Instantiate a VGA synchronization circuit
  vga_sync_unit: entity work.vga_sync(arch)
    port map(
             clk      => clk,
             rst      => rst,
             px_clk   => px_clk,
             video_on  => data_en,
             pixel_x  => open,
             pixel_y  => open,
             hsync    => hsync,
             vsync    => vsync
    );

  -- RGB buffer
  process(clk, rst) begin

    if rst = '0' then
      rgb_reg <= (others => '0');
    
    elsif(rising_edge(clk)) then
      rgb_reg <= sw;
    end if;

  end process;
  
  rgb     <= rgb_reg when data_en = '1' else "000";
  video_on <= data_en;

end arq;
