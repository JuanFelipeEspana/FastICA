library ieee;

use ieee.std_logic_1164.all;
use    ieee.numeric_std.all;

entity float32_to_integer is 
  port (
    float32_max_exponent :       in           std_logic_vector(7 downto 0);
    float32_value        :       in          std_logic_vector(31 downto 0);
    integer_value        :       out         std_logic_vector(16 downto 0)
  );
end entity float32_to_integer;

architecture rtl of float32_to_integer is
  --CONSTANT
  constant ZEROS               :            std_logic_vector(15 downto 0) := (others => '0');
  --IEEE754 FIELDS
  signal sign                  :                                 std_logic;
  signal exponent              :              std_logic_vector(7 downto 0);
  signal mantissa              :             std_logic_vector(22 downto 0);
  --CONVERSION DATA
  signal exponent_range        :              std_logic_vector(7 downto 0);
  signal exponent_range_low    :              std_logic_vector(7 downto 0);
  signal exponent_shift        :              std_logic_vector(7 downto 0);
  signal exponent_real_shift   :              std_logic_vector(7 downto 0);
  signal mantissa_complete     :             std_logic_vector(15 downto 0);  
  signal mantissa_shifted      :             std_logic_vector(15 downto 0);
  --APPROXIMATION
  signal bit_approximated 		 :							std_logic_vector(0 downto 0);
begin

  --EXTRACT IEEE754 FIELDS
  sign                <=                                               float32_value(31);
  exponent            <=                                     float32_value(30 downto 23);
  mantissa            <=                                      float32_value(22 downto 0);
  
  --DETERMINE SHIFT VALUE WITH EXPONENT RANGE
  exponent_range      <=            std_logic_vector(142 + signed(float32_max_exponent));
  exponent_range_low  <=            std_logic_vector(unsigned(exponent_range) - 16);
  exponent_real_shift <= std_logic_vector(unsigned(exponent_range) - unsigned(exponent));
  exponent_shift      <=  exponent_real_shift when (((unsigned(exponent)>=unsigned(exponent_range_low))) and ((unsigned(exponent)<=unsigned(exponent_range)))) else
                         "11111111" when (unsigned(exponent)<unsigned(exponent_range_low)) else
                         "00000000";

  --COMPLETE MANTISSA
  mantissa_complete   <=                                     '1' & mantissa(22 downto 8);
  
  --SHIFT MANTISSA TO REAL INTEGER
  mantissa_shifter: entity work.barrelShifter
    generic map(
      nShifts   =>                      4,
      nBits     =>                     16
      )
    port map(
      input     =>            mantissa_complete,
      shift     =>   exponent_shift(3 downto 0),
      output    =>             mantissa_shifted
    );
	
  --CHECK MSB DISCARDED TO APPROXIMATE
  with exponent_shift(3 downto 0) select
	bit_approximated(0) <= mantissa(7)  when   x"0",
			                   mantissa(8)  when   x"1",
			                   mantissa(9)  when   x"2",
                         mantissa(10) when   x"3",
                         mantissa(11) when   x"4",
                         mantissa(12) when   x"5",
                         mantissa(13) when   x"6",
                         mantissa(14) when   x"7",
                         mantissa(15) when   x"8",
                         mantissa(16) when   x"9",
                         mantissa(17) when   x"A",
                         mantissa(18) when   x"B",
                         mantissa(19) when   x"C",
                         mantissa(20) when   x"D",
                         mantissa(21) when   x"E",
                         mantissa(22) when   x"F",
			                   '0'          when others;

  --INTEGER VALUE FOLLOWING SIGN MAGNITUDE FORMAT
  integer_value <= sign & std_logic_vector(unsigned(mantissa_shifted) + unsigned(bit_approximated));

end architecture rtl;
