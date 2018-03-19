-- ***********************************************************
-- * Altera synchronous simple dual-port RAM (with new data) *
-- ***********************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is

  generic(
    ADDR_WIDTH: integer:=2;
    DATA_WIDTH: integer:=8
  );

  port(
    clk: in std_logic;
    we : in std_logic;  -- Write enable

    -- Write and read address
    w_addr: in std_logic_vector(ADDR_WIDTH-1 downto 0);
    r_addr: in std_logic_vector(ADDR_WIDTH-1 downto 0);

    -- Registers that reflect how the embedded memory modules are wrapped with
    -- a synchronous interface in Cyclone chips.
    d: in  std_logic_vector(DATA_WIDTH-1 downto 0);
    q: out std_logic_vector(DATA_WIDTH-1 downto 0)
  );

end ram;

--******************************************************************************
-- if w_addr and r_addr address are the same, q gets the current data (new data)
--******************************************************************************
architecture arch of ram is

  -------------------------------------------------
  -- Create a user-defined two-dimensional datatype
  type mem_2d_type is array (0 to 2**ADDR_WIDTH-1)
    of std_logic_vector (DATA_WIDTH-1 downto 0);

  signal ram: mem_2d_type;
  -------------------------------------------------

  signal addr_reg: std_logic_vector(ADDR_WIDTH-1 downto 0);

begin

  process (clk) begin

    if (clk'event and clk = '1') then

      if (we='1') then
        ram(to_integer(unsigned(w_addr))) <= d;
      end if;

      addr_reg <= r_addr;

    end if;

  end process;

  q <= ram(to_integer(unsigned(addr_reg)));

end arch;
