-- *****************
-- * RAM testbench *
-- *****************

library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_tb is
   generic(
      ADDR_WIDTH: integer:=2;
      DATA_WIDTH: integer:=8
   );
end ram_tb;

architecture tb_arch of ram_tb is

   constant T: time := 20 ns;  -- Clock Period
   signal clk: std_logic;
   signal we:  std_logic;
   signal w_addr: std_logic_vector(ADDR_WIDTH-1 downto 0);
   signal r_addr: std_logic_vector(ADDR_WIDTH-1 downto 0);
   signal d: std_logic_vector(DATA_WIDTH-1 downto 0);
   signal q: std_logic_vector(DATA_WIDTH-1 downto 0);

begin

   -- =============
   -- Instantiation
   -- =============
   ram_unit: entity work.ram(arch)
   
      generic map(ADDR_WIDTH => ADDR_WIDTH,
      DATA_WIDTH => DATA_WIDTH)
      
      port map(clk => clk,
               we  => we,
               w_addr => w_addr,
               r_addr => r_addr,
               d => d,
               q => q);

   -- =====
   -- Clock
   -- =====
   process begin
      clk <= '0';
      wait for T/2;
      clk <= '1';
      wait for T/2;
   end process;

   -- ==============
   -- Other Stimulus
   -- ==============
   process begin

      we <= '1';  -- Write enabled

      -- Write in the last address
      w_addr <= (others => '1');
      d <= (others => '1');
      wait until falling_edge(clk);

      -- Write in the first address
      w_addr <= (others => '0');
      d <= (others => '0');
      wait until falling_edge(clk);

      -- Read the last address
      r_addr <= (others => '1');
      we <= '0'; -- first address should have the same value
      d <= "00001111"; -- should not be stored
      wait until falling_edge(clk);

      -- Write in the second address and read the first address
      w_addr <= "01";
      d <= "11110000";
      r_addr <= (others => '0');

      -- overwrite and read the whole memory
      for i in 0 to 2**ADDR_WIDTH-1 loop

         we <= '1'; -- Write enabled
         w_addr <= std_logic_vector(to_unsigned(i, ADDR_WIDTH));
         d <= std_logic_vector(to_unsigned(i+8, DATA_WIDTH));
         
         r_addr <= std_logic_vector(to_unsigned(i, ADDR_WIDTH));
         wait until falling_edge(clk);

      end loop;

      -- Read the whole memory
      for i in 0 to 2**ADDR_WIDTH-1 loop  -- Read the whole memory

         we <= '0'; -- Write disabled
         -- This shoul not be stored
         w_addr <= std_logic_vector(to_unsigned(i, ADDR_WIDTH));
         d <= std_logic_vector(to_unsigned(i+4, DATA_WIDTH));
         
         r_addr <= std_logic_vector(to_unsigned(i, ADDR_WIDTH));
         wait until falling_edge(clk);

      end loop;

      -- ====================
      -- Terminate simulation
      -- ====================
      assert false
         report "Simulation Completed"
      severity failure;

   end process;
   
end tb_arch;