library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
  generic(
    bits        :       integer          := 16
  );
  port(
    clk         :       in      std_logic;
    rst         :       in      std_logic;
    strobe      :       in      std_logic;
    dataa       :       in      std_logic_vector(bits downto 0);
    datab       :       in      std_logic_vector(bits downto 0);
    finished    :       out     std_logic;
    res         :       out     std_logic_vector(bits downto 0)
  );
end entity multiplier;

architecture rtl of multiplier is
  --CONSTANTS
  constant zeros                  :    std_logic_vector(bits-1 downto 0) := (others => '0');
  --TYPES
  type matrix is array (natural range <>) of std_logic_vector(bits-1 downto 0);
  --SIGNALS
    --REGISTERS
    signal acc_reg                :    std_logic_vector((bits*2)-1 downto 0);
    signal completed_reg          :    std_logic;
    signal sign_chain             :    std_logic_vector(2 downto 0);
    signal product_reg            :    std_logic;
    signal finished_reg           :    std_logic;
    --ADDITIONAL
      --CONTROL
      signal second_product       :    std_logic;
      signal adc_section          :    std_logic_vector((bits/2)-1 downto 0);
      signal ena_multiplier       :    std_logic;
      --SUM
      signal dataa_value          :    std_logic_vector(bits-1 downto 0);
      signal datab_value          :    std_logic_vector(bits-1 downto 0);
      signal dataa_sign           :    std_logic;
      signal datab_sign           :    std_logic;
      signal partial_product      :    matrix(0 to bits-1);
      signal sum                  :    std_logic_vector((bits*2)-1 downto 0);--matrix(0 to 10);
      --signal extended_sum         :    std_logic_vector((bits*2)-1 downto 0);
      --signal acc_val              :    std_logic_vector((bits*2)-1 downto 0);
begin

  dataa_value  <= dataa(bits-1 downto 0);
  dataa_sign   <= dataa(bits);
  datab_value  <= datab(bits-1 downto 0);
  datab_sign   <= datab(bits);

  partials: for i in 0 to (bits-1) generate
    partial_product(i) <= dataa_value when datab_value(i)='1' else
                          zeros;
  end generate;

  finished_flag: process(clk, rst)
  begin
    if(rst='1') then
      product_reg  <= '0';
      finished_reg <= '0';
    elsif(rising_edge(clk)) then
      if(strobe='1') then
        product_reg  <= '1';
      else
        product_reg  <= '0';
      end if;
      if(product_reg='1') then
        finished_reg <= '1';
      else
        finished_reg <= '0';
      end if;
    end if;
  end process;

  ena_multiplier <= product_reg or finished_reg;
  adder: entity work.parallel_adder
    port map(
      aclr        =>                  rst,
      clken       =>       ena_multiplier,
      clock       =>                  clk,
      data0x      =>   partial_product(0),
      data10x     =>  partial_product(10),
      data11x     =>  partial_product(11),
      data12x     =>  partial_product(12),
      data13x     =>  partial_product(13),
      data14x     =>  partial_product(14),
      data15x     =>  partial_product(15),
      data1x      =>   partial_product(1),
      data2x      =>   partial_product(2),
      data3x      =>   partial_product(3),
      data4x      =>   partial_product(4),
      data5x      =>   partial_product(5),
      data6x      =>   partial_product(6),
      data7x      =>   partial_product(7),
      data8x      =>   partial_product(8),
      data9x      =>   partial_product(9),
      result      =>                  sum
    );
  
  res(bits-1 downto 0) <=          sum(31 downto 16);
  res(bits)            <= dataa_sign xnor datab_sign;

  finished  <= finished_reg;
--  extended_sum <= sum & zeros(11 downto 0);
--  acc_val  <= zeros(11 downto 0) & sum when second_product='1' else
--              std_logic_vector(unsigned(acc_reg) + unsigned(extended_sum));
end architecture rtl;

