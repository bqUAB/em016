LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY i2c_clk IS
  GENERIC(
      sys_clk         : INTEGER := 50_000_000;  --system clock frequency in Hz
      output_clk      : INTEGER :=    100_000); --desired output frequency in Hz
  PORT (
      clK_in    : IN  STD_LOGIC;               --system clock
      reset_n   : IN  STD_LOGIC;               --asynchronous reset
      ena       : IN  STD_LOGIC;               --enable 
      clk_out   : OUT STD_LOGIC);           	  --frequency output
		
END i2c_clk;

ARCHITECTURE structure OF i2c_clk IS

COMPONENT i2c_clk_div 
	PORT(
      div_clK_in    : IN  STD_LOGIC;               --system clock
      div_reset_n   : IN  STD_LOGIC;               --asynchronous reset
      div_ena       : IN  STD_LOGIC;               --enable 
      div_clk_out_d : OUT STD_LOGIC);           	   --frequency output
END COMPONENT;

COMPONENT tff_x 	
	  Port(
        t_clk     : in std_logic;
        t_reset_n : in std_logic;
        t_t       : in std_logic;
        t_q       : out std_logic);
END COMPONENT;

signal ttemp : std_logic;
	BEGIN

x1: i2c_clk_div port map (clK_in,reset_n,ena,ttemp);
x2: tff_x       port map (clK_in,reset_n,ttemp,clk_out);
	
	END structure;
			
