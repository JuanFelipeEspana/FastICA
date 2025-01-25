library ieee;

use ieee.std_logic_1164.all;
use    ieee.numeric_std.all;
use   work.type_results.all;

entity result_decoder is
  generic(
    macs_total          :       integer         :=     128;
    macs_bits           :       integer         :=       7;
    sum_bits            :       integer         :=      32
  );
  port(
    address             :    in       std_logic_vector((macs_bits-1) downto 0);
    results             :    in            macs_results(macs_total-1 downto 0);
    shift_result        :    in                   std_logic_vector(7 downto 0);
    result              :    out                 std_logic_vector(31 downto 0)
  );
end entity result_decoder;

architecture rtl of result_decoder is
  constant exponent_offset    :                        unsigned(7 downto 0)  :=  x"7E";
  --INDEXED RESULT
  signal indexed_result       :       std_logic_vector(sum_bits-1 downto 0);
  --CONVERSION DATA
  signal unsigned_result      :       std_logic_vector(sum_bits-1 downto 0);
  signal first_one_position   :         std_logic_vector(sum_bits downto 0);
  signal exponent_relative    :                std_logic_vector(5 downto 0);
  signal exponent_relative_p1 :                std_logic_vector(5 downto 0);
  signal exponent_absolute    :                std_logic_vector(7 downto 0);
  signal exponent_absolute_rel:                std_logic_vector(7 downto 0);
  signal mantissa_value       :       std_logic_vector(sum_bits-1 downto 0);
  signal bits_discarded       :                std_logic_vector(5 downto 0);
  --IEEE754 FIELDS
  signal sign                 :                                   std_logic;
  signal exponent             :                std_logic_vector(7 downto 0);
  signal mantissa             :               std_logic_vector(22 downto 0);
begin

  indexed_result <= results(to_integer(unsigned(address)));
  unsigned_result <= std_logic_vector(unsigned(not indexed_result) + 1) when indexed_result(sum_bits-1)='1' else
                     indexed_result;

  --FIND FIRST ONE IN UNSIGNED VALUE
  first_one_position(sum_bits) <= '0';
  first_one_checker: for i in sum_bits-1 downto 0 generate
  begin
    first_one_position(i) <= '1' when ((unsigned_result(i)) and (not first_one_position(i+1)))='1' else
                              first_one_position(i+1);
  end generate first_one_checker;

  --CALCULATE EXPONENT FOR SHIFTING AND REAL ONE
  exponent_relative <= "10" & x"A" when first_one_position(sum_bits-1)= '1' else
                       "10" & x"9" when first_one_position(sum_bits-2)= '1' else
                       "10" & x"8" when first_one_position(sum_bits-3)= '1' else
                       "10" & x"7" when first_one_position(sum_bits-4)= '1' else
                       "10" & x"6" when first_one_position(sum_bits-5)= '1' else
                       "10" & x"5" when first_one_position(sum_bits-6)= '1' else
                       "10" & x"4" when first_one_position(sum_bits-7)= '1' else
                       "10" & x"3" when first_one_position(sum_bits-8)= '1' else
                       "10" & x"2" when first_one_position(sum_bits-9)= '1' else
                       "10" & x"1" when first_one_position(sum_bits-10)= '1' else
                       "10" & x"0" when first_one_position(sum_bits-11)= '1' else
                       "01" & x"F" when first_one_position(sum_bits-12)= '1' else
                       "01" & x"E" when first_one_position(sum_bits-13)= '1' else
                       "01" & x"D" when first_one_position(sum_bits-14)= '1' else
                       "01" & x"C" when first_one_position(sum_bits-15)= '1' else
                       "01" & x"B" when first_one_position(sum_bits-16)= '1' else
                       "01" & x"A" when first_one_position(sum_bits-17)= '1' else
                       "01" & x"9" when first_one_position(sum_bits-18)= '1' else
                       "01" & x"8" when first_one_position(sum_bits-19)= '1' else
                       "01" & x"7" when first_one_position(sum_bits-20)= '1' else
                       "01" & x"6" when first_one_position(sum_bits-21)= '1' else
                       "01" & x"5" when first_one_position(sum_bits-22)= '1' else
                       "01" & x"4" when first_one_position(sum_bits-23)= '1' else
                       "01" & x"3" when first_one_position(sum_bits-24)= '1' else
                       "01" & x"2" when first_one_position(sum_bits-25)= '1' else
                       "01" & x"1" when first_one_position(sum_bits-26)= '1' else
                       "01" & x"0" when first_one_position(sum_bits-27)= '1' else
                       "00" & x"F" when first_one_position(sum_bits-28)= '1' else
                       "00" & x"E" when first_one_position(sum_bits-29)= '1' else
                       "00" & x"D" when first_one_position(sum_bits-30)= '1' else
                       "00" & x"C" when first_one_position(sum_bits-31)= '1' else
                       "00" & x"B" when first_one_position(sum_bits-32)= '1' else
                       "00" & x"A" when first_one_position(sum_bits-33)= '1' else
                       "00" & x"9" when first_one_position(sum_bits-34)= '1' else
                       "00" & x"8" when first_one_position(sum_bits-35)= '1' else
                       "00" & x"7" when first_one_position(sum_bits-36)= '1' else
                       "00" & x"6" when first_one_position(sum_bits-37)= '1' else
                       "00" & x"5" when first_one_position(sum_bits-38)= '1' else
                       "00" & x"4" when first_one_position(sum_bits-39)= '1' else
                       "00" & x"3" when first_one_position(sum_bits-40)= '1' else
                       "00" & x"2" when first_one_position(sum_bits-41)= '1' else
                       "00" & x"1" when first_one_position(sum_bits-42)= '1' else
                       "00" & x"0";
  
  exponent_relative_p1 <= std_logic_vector(unsigned(exponent_relative) + 1);
  --ADD IEEE754 OFFSET AND SHIFT RESULT
  exponent_absolute_rel <= std_logic_vector(exponent_offset + unsigned(exponent_relative_p1));
  exponent_absolute <= std_logic_vector(unsigned(exponent_absolute_rel) +  unsigned(shift_result));

  --SHIFT MANTISSA, WITH ADDITIONAL BIT IN ONE
  bits_discarded <= std_logic_vector(44-unsigned(exponent_relative_p1));
  bit_shifting: entity work.barrelShifterLeft
    generic map(
      nShifts           =>                            6,
      nBits             =>                     sum_bits
    )
    port map(
      input             =>              unsigned_result,
      shift             =>               bits_discarded,
      output            =>               mantissa_value
    );
  
  --FILL IEEE754 FIELDS
  sign     <=                        indexed_result(sum_bits-1);
  exponent <=                                 exponent_absolute;
  mantissa <=   mantissa_value(sum_bits-1 downto (sum_bits-23));

  --FLOAT RESULT
  result <= sign & exponent & mantissa;

end architecture rtl;
