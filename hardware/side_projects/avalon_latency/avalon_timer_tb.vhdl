library ieee;
use ieee.std_logic_1164.all;

entity avalon_timer_tb is
end entity avalon_timer_tb;

architecture testbench of avalon_timer_tb is
  signal clk_tb         :       std_logic      := '1';
  signal rst_tb         :       std_logic      := '1';
  signal count_addr     :       std_logic_vector(2 downto 0)  := "000";
  signal count_cs       :       std_logic      := '0';
  signal count_wr       :       std_logic      := '0';
  signal count_wrd      :       std_logic_vector(31 downto 0) := x"00000000";
  signal count_rdd      :       std_logic_vector(31 downto 0);
begin

  clk_tb <= not clk_tb after 10 ns;
  
  test_vectors: process
  begin
    wait for 200 ns;
    rst_tb <= '0';
    wait for 200 ns;
    count_wrd <= x"00000001";
    wait for 200 ns;
    count_cs <= '1';
    count_wr <= '1';
    wait for 60 ns;
    count_wr <= '0';
    wait for 500 ns;
    count_wrd <= x"00000000";
    wait for 200 ns;
    count_cs <= '1';
    count_wr <= '1';
    wait for 50 ns;
    count_wr <= '0';
    wait for 200 ns;
    count_addr <= "011";
    wait for 100 ns;
    count_addr <= "010";
    wait for 200 ns;
    count_cs <= '1';
    count_wr <= '1';
    wait for 50 ns;
  end process;

  DUT: entity work.avalon_timer
    port map(
      clk       =>       clk_tb,
      reset     =>       rst_tb,
      count_address =>     count_addr,
      count_chipselect => count_cs,
      count_write=>       count_wr,
      count_writedata  =>      count_wrd,
      count_readdata   =>      count_rdd
    );
end architecture testbench;

                  
  
