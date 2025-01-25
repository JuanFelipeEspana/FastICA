library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sixteen_bit_product is
  port(
    a           :       in      std_logic_vector(15 downto 0);
    b           :       in      std_logic_vector(15 downto 0);
    product     :       out     std_logic_vector(31 downto 0)
  );
end entity sixteen_bit_product;

architecture rtl of sixteen_bit_product is
  signal partial_product1       :       std_logic_vector(15 downto 0);
  signal partial_product2       :       std_logic_vector(15 downto 0);
  signal partial_product3       :       std_logic_vector(15 downto 0);
  signal partial_product4       :       std_logic_vector(15 downto 0);
  signal middle_product1        :       std_logic_vector(16 downto 0);
  signal middle_product2        :       std_logic_vector(17 downto 0);
  signal middle_product3        :       std_logic_vector(7 downto 0);
begin

  mult1: entity work.eight_bit_product
    port map(
      a         =>      a(7 downto 0),
      b         =>      b(7 downto 0),
      product   =>      partial_product1
    );
  mult2: entity work.eight_bit_product
    port map(
      a         =>      a(15 downto 8),
      b         =>      b(7 downto 0),
      product   =>      partial_product2
    );
  mult3: entity work.eight_bit_product
    port map(
      a         =>      a(7 downto 0),
      b         =>      b(15 downto 8),
      product   =>      partial_product3
    );
  mult4: entity work.eight_bit_product
    port map(
      a         =>      a(15 downto 8),
      b         =>      b(15 downto 8),
      product   =>      partial_product4
    );

  middle_product1 <= std_logic_vector(unsigned('0' & partial_product2) + unsigned(partial_product3));
  middle_product2 <= std_logic_vector(unsigned('0' & middle_product1) + unsigned(partial_product4(7 downto 0) & partial_product1(15 downto 8)));
  middle_product3 <= std_logic_vector(unsigned(partial_product4(15 downto 8)) + unsigned(middle_product2(17 downto 16)));

  product <= middle_product3 & middle_product2(15 downto 0) & partial_product1(7 downto 0);

end architecture rtl;
