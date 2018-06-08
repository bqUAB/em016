-- *******************************
-- * Free-running shift register *
-- *******************************

library ieee;
use ieee.std_logic_1164.all;

entity free_run_shift_reg is

  generic(N: integer := 8);

  port(
    clk, rst: in std_logic;
    s_in: in std_logic;
    s_out: out std_logic_vector(N-1 downto 0)
  );

end free_run_shift_reg;

architecture arch of free_run_shift_reg is

  signal r_reg: std_logic_vector(N-1 downto 0);
  signal r_next: std_logic_vector(N-1 downto 0);

begin

  -- register
  process(clk,rst) begin
    if (rst='0') then
      r_reg <= (others=>'0');
    elsif (rising_edge(clk)) then
      r_reg <= r_next;
    end if;
  end process;
  -- next-state logic (shift right 1 bit)
  r_next <= s_in & r_reg(N-1 downto 1);
  -- output
  s_out <= r_reg;

  end arch;