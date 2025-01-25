library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_decoder is
  port(
    matrix_dimension    :       in      unsigned(6 downto 0);
    mem_en              :       out      std_logic_vector(127 downto 0)
  );
end entity mem_decoder;

architecture rtl of mem_decoder is
begin

  mem_en <= x"00000000000000000000000000000000" when matrix_dimension=x"00" else 
x"ffffffffffffffffffffffffffffffff" when matrix_dimension=x"01" else 
x"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" when matrix_dimension=x"02" else 
x"92492492492492492492492492492490" when matrix_dimension=x"03" else 
x"88888888888888888888888888888888" when matrix_dimension=x"04" else 
x"84210842108421084210842108421080" when matrix_dimension=x"05" else 
x"82082082082082082082082082082080" when matrix_dimension=x"06" else 
x"81020408102040810204081020408100" when matrix_dimension=x"07" else 
x"80808080808080808080808080808080" when matrix_dimension=x"08" else 
x"80402010080402010080402010080400" when matrix_dimension=x"09" else 
x"80200802008020080200802008020000" when matrix_dimension=x"0a" else 
x"80100200400801002004008010020000" when matrix_dimension=x"0b" else 
x"80080080080080080080080080080000" when matrix_dimension=x"0c" else 
x"80040020010008004002001000800000" when matrix_dimension=x"0d" else 
x"80020008002000800200080020008000" when matrix_dimension=x"0e" else 
x"80010002000400080010002000400000" when matrix_dimension=x"0f" else 
x"80008000800080008000800080008000" when matrix_dimension=x"10" else 
x"80004000200010000800040002000000" when matrix_dimension=x"11" else 
x"80002000080002000080002000080000" when matrix_dimension=x"12" else 
x"80001000020000400008000100000000" when matrix_dimension=x"13" else 
x"80000800008000080000800008000000" when matrix_dimension=x"14" else 
x"80000400002000010000080000400000" when matrix_dimension=x"15" else 
x"80000200000800002000008000000000" when matrix_dimension=x"16" else 
x"80000100000200000400000800000000" when matrix_dimension=x"17" else 
x"80000080000080000080000080000000" when matrix_dimension=x"18" else 
x"80000040000020000010000008000000" when matrix_dimension=x"19" else 
x"80000020000008000002000000000000" when matrix_dimension=x"1a" else 
x"80000010000002000000400000000000" when matrix_dimension=x"1b" else 
x"80000008000000800000080000000000" when matrix_dimension=x"1c" else 
x"80000004000000200000010000000000" when matrix_dimension=x"1d" else 
x"80000002000000080000002000000000" when matrix_dimension=x"1e" else 
x"80000001000000020000000400000000" when matrix_dimension=x"1f" else 
x"80000000800000008000000080000000" when matrix_dimension=x"20" else 
x"80000000400000002000000000000000" when matrix_dimension=x"21" else 
x"80000000200000000800000000000000" when matrix_dimension=x"22" else 
x"80000000100000000200000000000000" when matrix_dimension=x"23" else 
x"80000000080000000080000000000000" when matrix_dimension=x"24" else 
x"80000000040000000020000000000000" when matrix_dimension=x"25" else 
x"80000000020000000008000000000000" when matrix_dimension=x"26" else 
x"80000000010000000002000000000000" when matrix_dimension=x"27" else 
x"80000000008000000000800000000000" when matrix_dimension=x"28" else 
x"80000000004000000000200000000000" when matrix_dimension=x"29" else 
x"80000000002000000000080000000000" when matrix_dimension=x"2a" else 
x"80000000001000000000000000000000" when matrix_dimension=x"2b" else 
x"80000000000800000000000000000000" when matrix_dimension=x"2c" else 
x"80000000000400000000000000000000" when matrix_dimension=x"2d" else 
x"80000000000200000000000000000000" when matrix_dimension=x"2e" else 
x"80000000000100000000000000000000" when matrix_dimension=x"2f" else 
x"80000000000080000000000000000000" when matrix_dimension=x"30" else 
x"80000000000040000000000000000000" when matrix_dimension=x"31" else 
x"80000000000020000000000000000000" when matrix_dimension=x"32" else 
x"80000000000010000000000000000000" when matrix_dimension=x"33" else 
x"80000000000008000000000000000000" when matrix_dimension=x"34" else 
x"80000000000004000000000000000000" when matrix_dimension=x"35" else 
x"80000000000002000000000000000000" when matrix_dimension=x"36" else 
x"80000000000001000000000000000000" when matrix_dimension=x"37" else 
x"80000000000000800000000000000000" when matrix_dimension=x"38" else 
x"80000000000000400000000000000000" when matrix_dimension=x"39" else 
x"80000000000000200000000000000000" when matrix_dimension=x"3a" else 
x"80000000000000100000000000000000" when matrix_dimension=x"3b" else 
x"80000000000000080000000000000000" when matrix_dimension=x"3c" else 
x"80000000000000040000000000000000" when matrix_dimension=x"3d" else 
x"80000000000000020000000000000000" when matrix_dimension=x"3e" else 
x"80000000000000010000000000000000" when matrix_dimension=x"3f" else 
x"80000000000000008000000000000000" when matrix_dimension=x"40" else 
x"80000000000000000000000000000000" when ((matrix_dimension<=x"41")and(matrix_dimension>=x"7f")) else
x"00000000000000000000000000000000";

end architecture rtl;
            
