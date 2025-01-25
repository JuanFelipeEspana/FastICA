library ieee;

use ieee.std_logic_1164.all;
use    ieee.numeric_std.all;

entity row_decoder is
  generic(
    macs_total          :       integer      :=    128;
    macs_size           :       integer      :=      7
  );
  port(
    matrix_dimension    :       in      std_logic_vector(macs_size-1 downto 0);
    wr_en               :       out    std_logic_vector(macs_total-1 downto 0)
  );
end entity row_decoder;

architecture rtl of row_decoder is
  constant ONES        :        std_logic_vector(macs_total-1 downto 0)   := (others => '1');
  signal wr_en_not     :        std_logic_vector(macs_total-1 downto 0);
begin

  --SHIFT ONES TO GET ZEROS EQUAL TO MACS AND THEN NEGATE
  enable_memories: entity work.barrelShifter
    generic map(
      nShifts   =>             macs_size,
      nBits     =>            macs_total
    )
    port map(
      input     =>                  ONES,
      shift     =>      matrix_dimension,
      output    =>             wr_en_not
    );
  wr_en <= not wr_en_not;
  
end architecture rtl;
  
