library ieee;

use ieee.std_logic_1164.all;
use    ieee.numeric_std.all;

entity single_memory is
  generic(
    memory_size :      integer         :=          9;
    mult_bits   :      integer         :=         17
  );
  port(
    data         :       in        std_logic_vector(mult_bits-1 downto 0);
    rdaddress    :       in      std_logic_vector(memory_size-1 downto 0);
    rdclock      :       in                                     std_logic;
    rdclocken    :       in                                     std_logic;
    wraddress    :       in      std_logic_vector(memory_size-1 downto 0);
    wrclock      :       in                                     std_logic;
    wrclocken    :       in                                     std_logic;
    wren         :       in                                     std_logic;
    q            :       out       std_logic_vector(mult_bits-1 downto 0)
  );
end entity single_memory;

architecture rtl of single_memory is
begin

  --MEMORY IP INSTANTIATION
  memory_ip: entity work.memory
    port map(
      data      =>           data,
      rdaddress =>      rdaddress,
      rdclock   =>        rdclock,
      rdclocken =>      rdclocken,
      wraddress =>      wraddress,
      wrclock   =>        wrclock,
      wrclocken =>      wrclocken,
      wren      =>           wren,
      q         =>              q
    );

end architecture rtl;
