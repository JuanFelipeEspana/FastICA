library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity two_bit_product is
  port(
    a           :       in      std_logic_vector(1 downto 0);
    b           :       in      std_logic_vector(1 downto 0);
    product     :       out     std_logic_vector(3 downto 0)
  );
end entity two_bit_product;

architecture rtl of two_bit_product is
  signal    partial_product1    :       std_logic_vector(1 downto 0);
  signal    partial_product2    :       std_logic_vector(2 downto 0);
begin
  partial_product1 <= (a(1) and b(0)) & (a(0) and b(0));
  partial_product2 <= (a(1) and b(1)) & (a(0) and b(1)) & '0';

  product <= std_logic_vector(unsigned('0' & partial_product2) + unsigned("00" & partial_product1));
end architecture rtl;
