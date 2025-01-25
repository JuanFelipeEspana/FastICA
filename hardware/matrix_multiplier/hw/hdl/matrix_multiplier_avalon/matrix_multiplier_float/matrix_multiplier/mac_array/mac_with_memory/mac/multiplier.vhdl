library ieee;

use ieee.std_logic_1164.all;
use    ieee.numeric_std.all;

entity multiplier is
  generic(
    bits        :       integer      := 16
  );
  port(
    clk         :       in                                std_logic;
    rst         :       in                                std_logic;
    strobe      :       in                                std_logic;
    dataa       :       in          std_logic_vector(bits downto 0);
    datab       :       in          std_logic_vector(bits downto 0);
    finished    :       out                               std_logic;
    res         :       out     std_logic_vector((bits*2) downto 0)
  );
end entity multiplier;

architecture rtl of multiplier is
  constant zeros                  :    std_logic_vector(bits-1 downto 0) := (others => '0');
  type matrix is array (natural range <>) of std_logic_vector(bits-1 downto 0);

  --OPERANDS
  signal dataa_value          :          std_logic_vector(bits-1 downto 0);
  signal datab_value          :          std_logic_vector(bits-1 downto 0);
  signal dataa_sign           :                                  std_logic;
  signal datab_sign           :                                  std_logic;
  
  --SUM
  signal partial_product      :                        matrix(0 to bits-1);
  signal sum                  :      std_logic_vector((bits*2)-1 downto 0);
  signal finished_reg         :                                  std_logic;
begin

  --EXTRACT MAGNITUDE AND SIGN FOR BOTH OPERANDS
  dataa_value  <= dataa(bits-1 downto 0);
  dataa_sign   <= dataa(bits);
  datab_value  <= datab(bits-1 downto 0);
  datab_sign   <= datab(bits);

  --DETERMINE HOW MANY TIMES DATAA IS GOING TO BE ADDED
  partials: for i in 0 to (bits-1) generate
    partial_product(i) <= dataa_value when datab_value(i)='1' else
                          zeros;
  end generate;
  
  --SUM ALL PARTIAL PRODUCTS WITH ITS SHIFTING
  adder: entity work.parallel_adder
    port map(
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
  
  --OUTPUT SIGN AND VALUE
  res(bits*2)              <= dataa_sign xnor datab_sign;
  res((bits*2)-1 downto 0) <= sum;
  
  --FINISHED FLAG
  finished_flag: process(clk, rst)
  begin
    if(rst='1') then
      finished_reg <= '0';
    elsif(rising_edge(clk)) then
      finished_reg <= strobe;
    end if;
  end process;
  finished  <= finished_reg;
  
end architecture rtl;
