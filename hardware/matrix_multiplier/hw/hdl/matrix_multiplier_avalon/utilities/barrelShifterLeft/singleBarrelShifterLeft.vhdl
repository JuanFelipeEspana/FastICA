library ieee;

use ieee.std_logic_1164.all;

entity singleBarrelShifterLeft is
  generic(
    nBits       :       integer         :=      8;
    nShifts     :       integer         :=      1
  );
  port(
    input       :       in      std_logic_vector(nBits-1 downto 0);
    shift       :       in      std_logic;
    output      :       out     std_logic_vector(nBits-1 downto 0)
  );
end entity singleBarrelShifterLeft;

architecture rtl of singleBarrelShifterLeft is
  constant zeros                :       std_logic_vector(nBits-1 downto 0)  := (others => '0');
  signal shiftedVector          :       std_logic_vector(nBits-1 downto 0);
begin

  --FILL WITH ZEROS TILL nShifts INDICATE AND THEN CONCATENATE INPUT
  shiftedVector(nBits-1 downto 2**(nShifts-1)) <= input(nBits-1-2**(nShifts-1) downto 0);
  shiftedVector(2**(nShifts-1)-1 downto 0) <= zeros(2**(nShifts-1)-1 downto 0);
  --CHOOSE BETWEEN SHIFTED OR NOT SIGNAL
  shifter: for i in 0 to nBits-1 generate
    output(i) <= shiftedVector(i) when shift='1' else
                 input(i);
  end generate;
    
end architecture rtl;
  
