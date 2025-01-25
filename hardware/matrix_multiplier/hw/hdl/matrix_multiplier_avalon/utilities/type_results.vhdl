library ieee;

use ieee.std_logic_1164.all;

package type_results is
  constant sum_bits     :       integer         :=      43;
  type macs_results is array (natural range <>) of std_logic_vector((sum_bits-1) downto 0);
end package type_results;
