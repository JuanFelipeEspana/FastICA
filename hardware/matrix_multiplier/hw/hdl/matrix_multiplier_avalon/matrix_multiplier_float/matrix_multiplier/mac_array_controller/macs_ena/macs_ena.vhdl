library ieee;

use ieee.std_logic_1164.all;
use    ieee.numeric_std.all;

entity macs_ena is
  generic(
    macs_total          :       integer                 := 128;
    macs_size           :       integer                 :=   7
  );
  port(
    results_total       :       in         std_logic_vector(macs_size downto 0);
    enable_macs         :       out     std_logic_vector(macs_total-1 downto 0)
  );
end entity macs_ena;

architecture rtl of macs_ena is
  constant ONES            :        std_logic_vector(macs_total-1 downto 0)   := (others => '1');
  signal not_enable_macs   :        std_logic_vector(macs_total-1 downto 0);
begin

  --SHIFT ZEROS AND NEGATE TO OBTAIN ONES TO ACTIVATE MACS
  enable_memories: entity work.barrelShifter
    generic map(
      nShifts   =>           macs_size+1,
      nBits     =>            macs_total
    )
    port map(
      input     =>                  ONES,
      shift     =>         results_total,
      output    =>       not_enable_macs
    );
  enable_macs <= not not_enable_macs;
  
end architecture rtl;
  
