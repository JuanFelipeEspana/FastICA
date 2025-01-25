library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity four_bit_product is
  port(
    a           :       in      std_logic_vector(3 downto 0);
    b           :       in      std_logic_vector(3 downto 0);
    product     :       out     std_logic_vector(7 downto 0)
  );
end entity four_bit_product;

architecture rtl of four_bit_product is
  signal     partial_product1   :       std_logic_vector(3 downto 0);
  signal     partial_product2   :       std_logic_vector(3 downto 0);
  signal     partial_product3   :       std_logic_vector(3 downto 0);
  signal     partial_product4   :       std_logic_vector(3 downto 0);
  signal     middle_product1    :       std_logic_vector(4 downto 0);
  signal     middle_product2    :       std_logic_vector(5 downto 0);
  signal     middle_product3    :       std_logic_vector(1 downto 0);
  signal     join_middle        :       std_logic_vector(3 downto 0);
begin
  first_product: entity work.two_bit_product
    port map(
      a         =>      a(1 downto 0),
      b         =>      b(1 downto 0),
      product   =>      partial_product1
    );
  
  second_product: entity work.two_bit_product
    port map(
      a         =>      a(3 downto 2),
      b         =>      b(1 downto 0),
      product   =>      partial_product2
    );
  
  third_product: entity work.two_bit_product
    port map(
      a         =>      a(1 downto 0),
      b         =>      b(3 downto 2),
      product   =>      partial_product3
    );

  fourth_product: entity work.two_bit_product
    port map(
      a         =>      a(3 downto 2),
      b         =>      b(3 downto 2),
      product   =>      partial_product4
    );

  join_middle <= partial_product4(1 downto 0) & partial_product1(3 downto 2);
  middle_product1 <= std_logic_vector(unsigned('0' & partial_product2) + unsigned(partial_product3));
  middle_product2 <= std_logic_vector(unsigned('0' & middle_product1) + unsigned(join_middle));
  middle_product3 <= std_logic_vector(unsigned(partial_product4(3 downto 2)) + unsigned(middle_product2(5 downto 4)));

  product <= middle_product3(1 downto 0) & middle_product2(3 downto 0) & partial_product1(1 downto 0);
end architecture rtl;
