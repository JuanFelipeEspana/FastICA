library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity matrix_multiplication_be_vedic is
  port(
    clk         :       in      std_logic;
    rst         :       in      std_logic;
    sync_clr    :       in      std_logic;
    ena         :       in      std_logic;
    row         :       in      std_logic_vector(24 downto 0);
    col         :       in      std_logic_vector(24 downto 0);
    acc         :       out     std_logic_vector(24 downto 0)
  );
end entity matrix_multiplication_be_vedic;

architecture rtl of matrix_multiplication_be_vedic is
  signal acc_reg        :       std_logic_vector(24 downto 0);
  signal product        :       std_logic_vector(24 downto 0);
begin
  accumulator: process(rst, clk, ena)
  begin
    if(rst='1') then
      acc_reg <= (others => '0');
    elsif(rising_edge(clk)) then
      if(sync_clr = '1') then
        acc_reg <= (others => '0');
      elsif(ena = '1') then
        acc_reg <= std_logic_vector(unsigned(acc_reg) + unsigned(product));
      end if;
    end if;
  end process;

  multiplier: entity work.twentyfour_bit_product
    port map(
      a         =>      row(23 downto 0),
      b         =>      col,
      product   =>      product
    );

  acc    <=    acc_reg;
end architecture rtl;
