library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MACs_testbench is
end entity MACs_testbench;


architecture testbench of MACs_testbench is
  signal clk_tb         :       std_logic       :=      '1';
  signal rst_tb         :       std_logic       :=      '1';
  signal start_tb       :       std_logic       :=      '0';
  signal dataa_tb       :       std_logic_vector(16 downto 0)   := '0' & x"0000";
  signal datab_tb       :       std_logic_vector(16 downto 0)   := '0' & x"0000";
  signal res_tb         :       std_logic_vector(19 downto 0);
begin

  clk_tb <= not clk_tb after 10 ns;
  rst_tb <= '0' after 50 ns;

  start_tb <= '1' after 80 ns,
              '0' after 100 ns;
  dataa_tb <= '0' & x"7E00" after 80 ns;
  datab_tb <= '1' & x"8BCD" after 80 ns;
  
  
  DUT: entity work.MACs
    generic map(
      mult_bits         =>      16,
      sum_bits          =>      20
      )
    port map(
      clk       =>      clk_tb,
      rst       =>      rst_tb,
      strobe    =>    start_tb,
      dataa     =>    dataa_tb,
      datab     =>    datab_tb,
      res       =>      res_tb
      );
  
end architecture testbench;
