LIBRARY ieee  ; 
LIBRARY std  ; 
USE ieee.std_logic_1164.all  ; 
USE ieee.std_logic_textio.all  ; 
USE ieee.STD_LOGIC_UNSIGNED.all  ; 
USE ieee.std_logic_unsigned.all  ; 
USE std.textio.all  ; 
ENTITY tb  IS 
  GENERIC (
    sys_clk  : INTEGER   := 50000000 ;  
    output_clk  : INTEGER   := 100000 ); 
END ; 
 
ARCHITECTURE tb_arch OF tb IS
  SIGNAL ena   :  STD_LOGIC  ; 
  SIGNAL reset_n   :  STD_LOGIC  ; 
  SIGNAL clK_in   :  STD_LOGIC  ; 
  SIGNAL clk_out   :  STD_LOGIC  ; 
  COMPONENT i2c_clk  
    GENERIC ( 
      sys_clk  : INTEGER ; 
      output_clk  : INTEGER  );  
    PORT ( 
      ena  : in STD_LOGIC ; 
      reset_n  : in STD_LOGIC ; 
      clK_in  : in STD_LOGIC ; 
      clk_out  : out STD_LOGIC ); 
  END COMPONENT ; 
BEGIN
  DUT  : i2c_clk  
    GENERIC MAP ( 
      sys_clk  => sys_clk  ,
      output_clk  => output_clk   )
    PORT MAP ( 
      ena   => ena  ,
      reset_n   => reset_n  ,
      clK_in   => clK_in  ,
      clk_out   => clk_out   ) ; 



-- "Clock Pattern" : dutyCycle = 50
-- Start Time = 0 ns, End Time = 1 us, Period = 20 ns
  Process
	Begin
	 clk_in  <= '0'  ;
	wait for 10 ns ;
-- 10 ns, single loop till start period.
	for Z in 1 to 10000
	loop
	    clk_in  <= '1'  ;
	   wait for 10 ns ;
	    clk_in  <= '0'  ;
	   wait for 10 ns ;
-- 990 ns, repeat pattern in loop.
	end  loop;
	 clk_in  <= '1'  ;
	wait for 10 ns ;
-- dumped values till 1 us
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 reset_n  <= '0'  ;
	wait for 10 us ;
-- dumped values till 1 us
	 reset_n  <= '1'  ;
	 wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
	Begin
	 ena  <= '0'  ;
	wait for 1 us ;
-- dumped values till 1 us
	ena  <= '1'  ;
	wait;
 End Process;
END;
