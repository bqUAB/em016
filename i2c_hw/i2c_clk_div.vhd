LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY i2c_clk_div IS
  GENERIC(
      sys_clk         : INTEGER := 50_000_000;  --system clock frequency in Hz
      output_clk      : INTEGER :=    100_000); --desired output frequency in Hz
  PORT (
      div_clK_in    : IN  STD_LOGIC;               --system clock
      div_reset_n   : IN  STD_LOGIC;               --asynchronous reset
      div_ena       : IN  STD_LOGIC;               --enable 
      div_clk_out_d : OUT STD_LOGIC);           	   --frequency output
END i2c_clk_div;

ARCHITECTURE behavioral OF i2c_clk_div IS
CONSTANT  period     :  INTEGER := (sys_clk/2)/(output_clk); --becouse of toggle, real fout is f_in/2
SIGNAL    temp       :  STD_LOGIC_VECTOR (7 downto 0);
SIGNAL    tc_temp    :  STD_LOGIC;


	BEGIN
		PROCESS(div_clK_in, div_reset_n,div_ena)
			BEGIN
				IF(div_reset_n = '0') THEN 
					tc_temp<='0';
					temp   <=X"00";
					ELSIF(div_clK_in'EVENT AND div_clK_in = '1') THEN     --rising system clock edge
					IF(div_ena = '1') THEN     
						temp<=(temp+x"1");
						IF (temp=period) THEN 
						tc_temp<='1';
						temp   <=X"00";
						ELSE
						tc_temp<='0';
						END IF;
					END IF;
				END IF;				
			END PROCESS;		
	div_clk_out_d<=tc_temp;
	END behavioral;
			
