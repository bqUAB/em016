-- *****************************************
-- * Free-running shift register testbench *
-- *****************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_reg_tb is
end shift_reg_tb;

architecture arch_tb of shift_reg_tb is

  constant T: time := 20 ns;  -- Clock Period

  -- Inputs
  signal clk, rst, s_in: std_logic;

  -- Outputs
  signal s_out: std_logic_vector(7 downto 0);

begin

  -- =============
  -- Instantiation
  -- =============
  shift_reg_unit: entity work.free_run_shift_reg(arch)
    port map(
      clk   => clk,
      rst   => rst,
      s_in  => s_in,
      s_out => s_out
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

    s_in <= '1';
    wait until falling_edge(clk);

    s_in <= '0';
    wait until falling_edge(clk);

    s_in <= '1';
    wait until falling_edge(clk);
    wait until falling_edge(clk);

    s_in <= '0';
    for i in 1 to 16 loop
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
