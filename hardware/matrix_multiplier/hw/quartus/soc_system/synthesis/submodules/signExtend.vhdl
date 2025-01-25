library ieee;
use ieee.std_logic_1164.all;

entity signExtend is
  generic(
    nShifts     :       integer    :=           3;
    nBits       :       integer    :=           8
  );
  port(
    input       :       in        std_logic_vector(nBits-1 downto 0);
    sign        :       in                                 std_logic;
    shift       :       in      std_logic_vector(nShifts-1 downto 0);
    output      :       out       std_logic_vector(nBits-1 downto 0)
  );
end entity signExtend;

architecture rtl of signExtend is
  type  matrix is array (natural range <>) of std_logic_vector(nBits-1 downto 0);
  signal shifted        :       matrix(nShifts downto 0);
begin
  shifted(0) <= input;
  signExtender: for i in 0 to nShifts-1 generate
    shifter: entity work.singleSignExtend
      generic map(
        nBits   =>            nBits,
        nShifts =>              i+1
      )
      port map(
        input   =>       shifted(i),
        sign    =>             sign,
        shift   =>         shift(i),
        output  =>     shifted(i+1)
      );
  end generate;
  output <= shifted(nShifts);
end architecture rtl;      
    
