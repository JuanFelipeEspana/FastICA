library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity twentyfour_bit_product is
  port(
    a           :       in      std_logic_vector(23 downto 0);
    b           :       in      std_logic_vector(24 downto 0);
    product     :       out     std_logic_vector(24 downto 0)
  );
end entity twentyfour_bit_product;

architecture rtl of twentyfour_bit_product is
  constant zeros                :       std_logic_vector(7 downto 0)    :=      x"00";
  constant ones                 :       std_logic_vector(7 downto 0)    :=      x"FF";
  signal neg_b                  :       std_logic_vector(24 downto 0);
  signal real_b                 :       std_logic_vector(24 downto 0);
  signal result                 :       std_logic_vector(23 downto 0);
  signal neg_result             :       std_logic_vector(23 Downto 0);
  signal complete_a             :       std_logic_vector(15 downto 0);
  signal complete_b             :       std_logic_vector(15 downto 0);
  signal partial_product1       :       std_logic_vector(31 downto 0);
  signal partial_product2       :       std_logic_vector(31 downto 0);
  signal partial_product3       :       std_logic_vector(31 downto 0);
  signal partial_product4       :       std_logic_vector(15 downto 0);
  signal middle_product1        :       std_logic_vector(32 downto 0);
  signal middle_product2        :       std_logic_vector(32 downto 0);
begin
  neg_b         <= std_logic_vector(unsigned(not b) + 1);
  real_b        <= b    when    b(24) = '0' else
                   neg_b;
  complete_a    <= zeros & a(23 downto 16);
  complete_b    <= zeros & real_b(23 downto 16);

  mult1: entity work.sixteen_bit_product
    port map(
      a         =>      a(15 downto 0),
      b         =>      real_b(15 downto 0),
      product   =>      partial_product1
    );

  mult2: entity work.sixteen_bit_product
    port map(
      a         =>      complete_a,
      b         =>      real_b(15 downto 0),
      product   =>      partial_product2
    );

  mult3: entity work.sixteen_bit_product
    port map(
      a         =>      a(15 downto 0),
      b         =>      complete_b,
      product   =>      partial_product3
    );

  mult4: entity work.eight_bit_product
    port map(
      a         =>      a(23 downto 16),
      b         =>      real_b(23 downto 16),
      product   =>      partial_product4
    );
  middle_product1 <= std_logic_vector(unsigned('0' & partial_product2) + unsigned(partial_product3));
  middle_product2 <= std_logic_vector(unsigned(partial_product4 & partial_product1(31 downto 16)) + unsigned(middle_product1));
  result <= middle_product2(31 downto 8);
  neg_result <= std_logic_vector(unsigned(not result)+1);
  product <= '0' & result when b(24) = '0' else
             '1' & neg_result;

end architecture rtl;
