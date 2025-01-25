library ieee;

use ieee.std_logic_1164.all;

entity barrelShifterLeft is
  generic(
    nShifts     :       integer    :=           3;
    nBits       :       integer    :=           8
  );
  port(
    input       :       in        std_logic_vector(nBits-1 downto 0);
    shift       :       in      std_logic_vector(nShifts-1 downto 0);
    output      :       out       std_logic_vector(nBits-1 downto 0)
  );
end entity barrelShifterLeft;

architecture rtl of barrelShifterLeft is
  type  matrix is array (natural range <>) of std_logic_vector(nBits-1 downto 0);
  signal shifted        :       matrix(nShifts downto 0);
begin

  --MATRIX WHERE ALL SHIFTED VERSIONS OF SIGNAL ARE STORED
  shifted(0) <= input;
  signExtender: for i in 0 to nShifts-1 generate
    shifter: entity work.singleBarrelShifterLeft
      generic map(
        nBits   =>            nBits,
        nShifts =>              i+1
      )
      port map(
        input   =>       shifted(i),
        shift   =>         shift(i),
        output  =>     shifted(i+1)
      );
  end generate;
  output <= shifted(nShifts);

end architecture rtl;      
    
