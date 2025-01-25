library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MACs is
  generic(
    mult_bits        :       integer          :=   16;
    sum_bits         :       integer          :=   20
  );
  port(
    clk         :       in      std_logic;
    rst         :       in      std_logic;
    strobe      :       in      std_logic;
    dataa       :       in      std_logic_vector(mult_bits downto 0);
    datab       :       in      std_logic_vector(mult_bits downto 0);
    res         :       out     std_logic_vector(sum_bits-1 downto 0)
  );
end entity MACs;

architecture rtl of MACs is
  constant zeros                :       std_logic_vector(sum_bits-1 downto 0)   := (others => '0');
  signal dataa_reg              :       std_logic_vector(mult_bits downto 0);
  signal datab_reg              :       std_logic_vector(mult_bits downto 0);
  signal multiplication         :       std_logic_vector(mult_bits downto 0);
  signal extended_mult          :       std_logic_vector(sum_bits-1 downto 0);
  signal sum                    :       std_logic_vector(sum_bits-1 downto 0);
  signal accumulator            :       std_logic_vector(sum_bits-1 downto 0);
  signal sign_n                 :       std_logic;
  signal calculus_finished      :       std_logic;
begin
  regs: process(rst, clk)
  begin
    if (rst='1') then
      dataa_reg   <= (others => '0');
      datab_reg   <= (others => '0');
      accumulator <= (others => '0');
    elsif (rising_edge(clk)) then
      dataa_reg   <= dataa;
      datab_reg   <= datab;
      if(calculus_finished='1') then
        accumulator <=   sum;
      end if;
    end if;
  end process;

  mult: entity work.multiplier
    port map(
      clk       =>                 clk,
      rst       =>                 rst,
      strobe    =>              strobe,
      dataa     =>           dataa_reg,
      datab     =>           datab_reg,
      finished  =>   calculus_finished,
      res       =>      multiplication
    );

  extended_mult <= zeros((sum_bits-mult_bits)-1 downto 0) & multiplication(mult_bits-1 downto 0);
  sign_n        <= multiplication(mult_bits);
  
  add: entity work.sub_adder
    port map(
      add_sub   =>              sign_n,
      dataa     =>         accumulator,
      datab     =>       extended_mult,
      result    =>                 sum
    );

  res           <=         accumulator;
  
end architecture rtl;
