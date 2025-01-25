library ieee;

use ieee.std_logic_1164.all;
use    ieee.numeric_std.all;

entity mac is
  generic(
    mult_bits        :       integer          :=   16;
    sum_bits         :       integer          :=   32
  );
  port(
    clk         :       in                                  std_logic;
    rst         :       in                                  std_logic;
    sync_clr    :       in                                  std_logic;
    strobe      :       in                                  std_logic;
    dataa       :       in       std_logic_vector(mult_bits downto 0);
    datab       :       in       std_logic_vector(mult_bits downto 0);
    res         :       out     std_logic_vector(sum_bits-1 downto 0)
  );
end entity mac;

architecture rtl of mac is
  constant zeros                :       std_logic_vector(sum_bits-1 downto 0)   := (others => '0');

  --PRODUCT
  signal dataa_reg              :                             std_logic_vector(mult_bits downto 0);
  signal calculus_finished      :                                                        std_logic;
  signal multiplication         :                         std_logic_vector((mult_bits*2) downto 0);
  signal extended_mult          :                            std_logic_vector(sum_bits-1 downto 0);

  --ACCUMMULATION
  signal sign_n                 :                                                        std_logic;
  signal sum                    :                            std_logic_vector(sum_bits-1 downto 0);
  signal accumulator            :                            std_logic_vector(sum_bits-1 downto 0);
begin

  --MULTIPLY BOTH VALUES
  mult: entity work.multiplier
    port map(
      clk       =>                 clk,
      rst       =>                 rst,
      strobe    =>              strobe,
      dataa     =>           dataa_reg,
      datab     =>               datab,
      finished  =>   calculus_finished,
      res       =>      multiplication
    );
  --EXTRACT SIGN AND EXTEND TO ADDER LENGTH
  sign_n        <= multiplication((mult_bits*2));
  extended_mult <= "000" & x"00" & multiplication((mult_bits*2)-1 downto 0);
  
  --STORE BOTH A AND ACCUMULATOR VALUES IN REGISTERS
  regs: process(rst, clk)
  begin
    if (rst='1') then
      dataa_reg   <= (others => '0');
      accumulator <= (others => '0');
    elsif (rising_edge(clk)) then
      dataa_reg   <= dataa;
      if(sync_clr='1') then
        accumulator <= (others => '0');
      elsif(calculus_finished='1') then
        accumulator <=   sum;
      end if;
    end if;
  end process;

  --ADD PRODUCT'S RESULT TO ACCUMULATION
  add: entity work.sub_adder
    port map(
      add_sub   =>              sign_n,
      dataa     =>         accumulator,
      datab     =>       extended_mult,
      result    =>                 sum
    );
  res           <=         accumulator;
  
end architecture rtl;
