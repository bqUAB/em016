-- *****************************************
-- * Free-running binary counter testbench *
-- *****************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin_counter_tb is
end bin_counter_tb;

architecture arch_tb of bin_counter_tb is

  constant T: time := 20 ns;  -- Clock Period

  -- Inputs
  signal clk, rst: std_logic;

  -- Outputs
  signal max_tick: std_logic;
  signal count: std_logic_vector(7 downto 0);

begin

  -- =============
  -- Instantiation
  -- =============
  bin_counter_unit: entity work.free_run_bin_counter(arch)
    port map(
      clk      => clk,
      rst      => rst,
      max_tick => max_tick,
      count    => count
    );

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

    for i in 1 to 512 loop
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
