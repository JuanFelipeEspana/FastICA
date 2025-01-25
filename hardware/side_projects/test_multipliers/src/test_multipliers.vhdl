library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_multipliers is
  port(
    clk         :       in      std_logic;
    rst         :       in      std_logic;
    start       :       in      std_logic;
    inputs      :       in      std_logic_vector(48 downto 0);
    res         :       out     std_logic_vector(23 downto 0)
  );
end entity test_multipliers;

architecture rtl of test_multipliers is
  --CONSTANTS
  constant zeros                  :    std_logic_vector(23 downto 0) := (others => '0');
  --TYPES
  type matrix is array (natural range <>) of std_logic_vector(23 downto 0);
  --SIGNALS
    --REGISTERS
    signal acc_reg                :    std_logic_vector(47 downto 0);
    signal completed_reg          :    std_logic;
    signal sign_chain             :    std_logic_vector(2 downto 0);
    --ADDITIONAL
      --CONTROL
      signal second_product       :    std_logic;
      signal adc_section          :    std_logic_vector(11 downto 0);
      --SUM
      signal adc_eeg              :    std_logic_vector(23 downto 0);
      signal matrix_coeff         :    std_logic_vector(23 downto 0);
      signal sign                 :    std_logic;
      signal partial_product      :    matrix(0 to 23);
      signal sum                  :    std_logic_vector(35 downto 0);--matrix(0 to 10);
      signal extended_sum         :    std_logic_vector(47 downto 0);
      signal acc_val              :    std_logic_vector(47 downto 0);
begin

  adc_eeg      <= inputs(48 downto 25);
  sign         <=           inputs(24);
  matrix_coeff <= inputs(23 downto  0);

  posedge_clk: process (rst, clk)
  begin
    if (rst='1') then
      acc_reg      <= (others => '0');
      completed_reg<= '0';
      second_product<= '0';
      sign_chain   <= "000";
    elsif (rising_edge(clk)) then
      acc_reg      <= acc_val;
      if (start='1') then
        second_product <= not second_product;
      end if;
      if (second_product='1') then
        sign_chain <= sign & sign_chain(2 downto 1);
      end if;
      if ((second_product='1')and(start='1')) then
        completed_reg <= '1';
      end if;
      if (completed_reg='1') then
        acc_reg       <= acc_val;
      end if;
    end if;
  end process;

  res         <= acc_reg(47 downto 24);
  adc_section <= adc_eeg(11 downto 0) when second_product='0' else
                 adc_eeg(23 downto 12);
  
  partials: for i in 0 to 11 generate
    partial_product(i) <= matrix_coeff when adc_section(i)='1' else
                          zeros;
  end generate;
 
  adder: entity work.parallel_adder
    port map(
      aclr        =>                  rst,
      clken       =>                start,
      clock       =>                  clk,
      data0x      =>   partial_product(0),
      data10x     =>  partial_product(10),
      data11x     =>  partial_product(11),
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

  extended_sum <= sum & zeros(11 downto 0);
  acc_val  <= zeros(11 downto 0) & sum when second_product='1' else
              std_logic_vector(unsigned(acc_reg) + unsigned(extended_sum));
end architecture rtl;
