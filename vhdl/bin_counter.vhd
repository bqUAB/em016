-- *******************************
-- * Free-running binary counter *
-- *******************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity free_run_bin_counter is

  generic(N: integer := 8);

  port(
    clk, rst: in  std_logic;
    max_tick: out std_logic;
    count: out std_logic_vector(N-1 downto 0)
  );

end free_run_bin_counter;

architecture arch of free_run_bin_counter is
  signal count_reg:  unsigned(N-1 downto 0);
  signal count_next: unsigned(N-1 downto 0);

begin
  -- register
  process(clk, rst) begin

    if (rst='0') then
      count_reg <= (others=>'0');
    elsif (rising_edge(clk)) then
      count_reg <= count_next;
    end if;

  end process;

  -- next-state logic
  count_next <= count_reg + 1;

  -- output logic
  count <= std_logic_vector(count_reg);
  max_tick <= '1' when count_reg=(2**N-1) else '0';

end arch;