library ieee;
use ieee.std_logic_1164.all;

entity decoder is

  port (
    a  : in  std_logic_vector ( 4 downto 0);  -- 5-bit input
    x  : out std_logic_vector (23 downto 0);  -- 24-bit output
    en : in  std_logic);

end decoder;

architecture arch of decoder is
begin

  process (a, en) begin

    x <= "000000000000000000000000";  -- default output value
    if (en = '1') then  -- active high enable pin
      case a is
        when "00001" => x( 0) <= '1';
        when "00010" => x( 1) <= '1';
        when "00011" => x( 2) <= '1';
        when "00100" => x( 3) <= '1';
        when "00101" => x( 4) <= '1';
        when "00110" => x( 5) <= '1';
        when "00111" => x( 6) <= '1';
        when "01000" => x( 7) <= '1';
        when "01001" => x( 8) <= '1';
        when "01010" => x( 9) <= '1';
        when "01011" => x(10) <= '1';
        when "01100" => x(11) <= '1';
        when "01101" => x(12) <= '1';
        when "01110" => x(13) <= '1';
        when "01111" => x(14) <= '1';
        when "10000" => x(15) <= '1';
        when "10001" => x(16) <= '1';
        when "10010" => x(17) <= '1';
        when "10011" => x(18) <= '1';
        when "10100" => x(19) <= '1';
        when "10101" => x(20) <= '1';
        when "10110" => x(21) <= '1';
        when "10111" => x(22) <= '1';
        when "11000" => x(23) <= '1';
        when others => x <= "000000000000000000000000";
      end case;
    end if;

  end process;

end arch;