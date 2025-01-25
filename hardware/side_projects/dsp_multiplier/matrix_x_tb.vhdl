library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity matrix_x_tb is
end entity matrix_x_tb;

architecture testbench of matrix_x_tb is
  signal clk_tb         :       std_logic       := '1';
  signal rst_tb         :       std_logic       := '1';
  signal ena_tb         :       std_logic       := '0';
  signal row_tb         :       std_logic_vector(24 downto 0) := '0' & x"000000";
  signal col_tb         :       std_logic_vector(24 downto 0) := '0' & x"000000";
  signal acc_tb         :       std_logic_vector(48 downto 0);
begin
  clk_tb <= not clk_tb after 10 ns;
  rst_tb <= '0' after 100 ns;
  ena_tb <= '1' after 240 ns,
            '0' after 260 ns,
            '1' after 280 ns,
            '0' after 300 ns,
            '1' after 320 ns,
            '0' after 340 ns;

  vector_generator: process
  begin
    wait for 220 ns;
    row_tb <= '0' & x"2A125A";
    col_tb <= '1' & x"41D6B4";
    wait for 40 ns;
    row_tb <= '0' & x"0265B6";
    col_tb <= '0' & x"91C571";
    wait for 40 ns;
    row_tb <= '0' & x"07DDE3";
    col_tb <= '0' & x"379899";
  end process;

  
  DUT: entity work.dsp
	port map(
		result  =>	acc_tb,
		dataa_0 =>  row_tb,
		datab_0 =>  col_tb,
		clock0  =>  clk_tb,
		ena0	  =>  ena_tb,
		aclr0   =>  rst_tb
	);
end architecture testbench;
  
  
