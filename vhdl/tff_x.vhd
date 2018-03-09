library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity tff_x is
  Port(
        clk     : in std_logic;
        reset_n : in std_logic;
        t       : in std_logic;
        q       : out std_logic
      );
end tff_x;

architecture behave of tff_x is
  signal q_reg: std_logic;
  signal q_next: std_logic;
  
begin
	process (clk,reset_n,t)
		begin
       if (reset_n = '0') then
          q_reg <= '0';
			
       elsif (clk'event and clk = '1') then
          q_reg <= q_next;
			 
      end if;
 end process;
       
       q_next <= q_reg when t = '0' else
                 not(q_reg);
       q <= q_reg;
end behave;