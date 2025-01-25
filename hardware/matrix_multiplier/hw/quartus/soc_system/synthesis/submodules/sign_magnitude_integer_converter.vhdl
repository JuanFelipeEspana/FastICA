library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_magnitude_integer_converter is
  generic(
    number_size         :       integer         :=      32
  );
  port(
    number_integer      :       in      std_logic_vector(number_size-1 downto 0);
    number_converted    :       out                std_logic_vector(16 downto 0)
  );
end entity sign_magnitude_integer_converter;

architecture rtl of sign_magnitude_integer_converter is
  signal number_a2      :       std_logic_vector(number_size-1 downto 0);
begin

  number_a2 <= std_logic_vector(unsigned((not number_integer)) + 1);

  number_converted(15 downto 0) <= number_a2(15 downto 0) when number_integer(number_size-1)='1' else
                                   number_integer(15 downto 0);
  
  number_converted(16) <= number_integer(number_size-1);

end architecture rtl;    
