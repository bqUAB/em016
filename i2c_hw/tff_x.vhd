library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity tff_x is
  Port(
        t_clk     : in std_logic;
        t_reset_n : in std_logic;
        t_t       : in std_logic;
        t_q       : out std_logic
      );
end tff_x;

architecture behave of tff_x is
  signal q_reg: std_logic;
  signal q_next: std_logic;
  
begin
	process (t_clk,t_reset_n,t_t)
		begin
       if (t_reset_n = '0') then
          q_reg <= '0';
			
       elsif (t_clk'event and t_clk = '1') then
          q_reg <= q_next;
			 
      end if;
 end process;

       
       q_next <= q_reg when t_t = '0' else
                 not(q_reg);

       t_q <= q_reg;
end behave;