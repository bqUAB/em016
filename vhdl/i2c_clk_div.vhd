LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY i2c_clk_div IS
  GENERIC(
      sys_clk         : INTEGER := 50_000_000;  --system clock frequency in Hz
      output_clk      : INTEGER :=    100_000); --desired output frequency in Hz
  PORT (
      clK_in    : IN  STD_LOGIC;               --system clock
      reset_n   : IN  STD_LOGIC;               --asynchronous reset
      ena       : IN  STD_LOGIC;               --enable 
      clk_out_d : OUT STD_LOGIC);           	   --frequency output
END i2c_clk_div;

ARCHITECTURE behavioral OF i2c_clk_div IS
CONSTANT  period     :  INTEGER := (sys_clk/2)/(output_clk); --becouse of toggle, real fout is f_in/2
SIGNAL    temp       :  STD_LOGIC_VECTOR (7 downto 0);
SIGNAL    tc_temp    :  STD_LOGIC;

	BEGIN
		PROCESS(clK_in,reset_n,ena)
			BEGIN
				IF(reset_n = '0') THEN 								 --negative reset
					tc_temp<='0';
					temp   <=X"00";
					ELSIF(clK_in'EVENT AND clK_in = '1') THEN  --rising system clock edge
					IF(ena = '1') THEN     
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
	clk_out_d<=tc_temp;
	END behavioral;
			
