library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package types_matrix is
  type read_memories is array (natural range <>) of std_logic_vector(24 downto 0);
  type read_dsp      is array (natural range <>) of std_logic_vector(48 downto 0);
end package types_matrix;

package body types_matrix is
end package body types_matrix;

