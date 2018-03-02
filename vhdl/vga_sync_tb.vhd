-- *********************************
-- * VGA synchronization testbench *
-- *********************************

library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_sync_tb is
end vga_sync_tb;

architecture arch_tb of vga_sync_tb is

  constant T: time := 20 ns;  -- Clock Period

  -- Inputs
  signal clk, rst: std_logic;
  signal sw: std_logic_vector(2 downto 0);

  -- Outputs
  signal px_clk, data_en, hsync, vsync: std_logic;
  signal px_x, px_y: std_logic_vector(9 downto 0);

  -- Internal signals
  signal rgb, rgb_reg: std_logic_vector(2 downto 0);

begin

  -- =============
  -- Instantiation
  -- =============
  vga_sync_unit: entity work.vga_sync(arch)
    port map(
             clk       => clk,
             rst       => rst,
             px_clk    => px_clk,
             video_on  => data_en,
             pixel_x   => px_x,
             pixel_y   => px_y,
             hsync     => hsync,
             vsync     => vsync
    );

  -- RGB Buffer
  process(clk, rst) begin

    if rst = '0' then
      rgb_reg <= (others => '0');
    
    elsif rising_edge(clk) then
      rgb_reg <= sw;
    end if;

  end process;

  rgb <= rgb_reg when data_en = '1' else "000";

  -- =====
  -- Clock
  -- =====
  process begin
    clk <= '0';
    wait for T/2;
    clk <= '1';
    wait for T/2;
  end process;

  -- Reset
  rst <= '0', '1' after T/2;

  -- ==============
  -- Other Stimulus
  -- ==============
  process begin

    sw <= "001";
    for i in 1 to 1000000 loop
      wait until falling_edge(clk);
    end loop;

    -- ====================
    -- Terminate simulation
    -- ====================
    assert false
      report "Simulation Completed"
    severity failure;

  end process;

end arch_tb;
