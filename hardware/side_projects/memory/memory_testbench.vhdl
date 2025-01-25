library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_testbench is
end entity;

architecture testbench of memory_testbench is
  signal address_tb     :       std_logic_vector(6 downto 0)    := "0000000";
  signal clk_tb         :       std_logic                       := '1';
  signal data_tb        :       std_logic_vector(24 downto 0)   := '0' & x"000000";
  signal wren_tb        :       std_logic                       := '0';
  signal q_tb           :       std_logic_vector(24 downto 0);
begin
  clk_tb <= not clk_tb after 10 ns;
  vector_generator: process
  begin
    wait for 110 ns;
    data_tb <= '1' & x"41D6B4";
    wren_tb <= '1';
    wait for 100 ns;
    address_tb <= "0000001";
    data_tb <= '0' & x"91C571";
    wait for 100 ns;
    address_tb <= "0000010";
    data_tb <= '0' & x"379899";
    wait for 100 ns;
    wren_tb <= '0';
    wait for 100 ns;
    address_tb <= "0000000";
    wait for 100 ns;
    address_tb <= "0000001";
    wait for 100 ns;
    address_tb <= "0000010";
  end process;

  DUT: entity work.memory_test
    port map(
      address   =>      address_tb,
      clock     =>      clk_tb,
      data      =>      data_tb,
      wren      =>      wren_tb,
      q         =>      q_tb
    );
end architecture testbench;
