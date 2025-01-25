library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity matrix_multiplier_avalon_tb is 
end entity matrix_multiplier_avalon_tb;

architecture testbench of matrix_multiplier_avalon_tb is
signal clk_tb       :       std_logic := '1';
signal rst_tb       :       std_logic := '1';
signal address_tb       :       std_logic_vector(17 downto 0) := "00" & x"0000";
signal chipselect_tb       :       std_logic := '1';
signal write_en_tb       :       std_logic := '0';
signal writedata_tb       :       std_logic_vector(31 downto 0) := x"00000000";
signal readdata_tb       :       std_logic_vector(31 downto 0) := x"00000000";
begin

clk_tb <= not clk_tb after 5 ns;

rst_tb <= '0' after 100 ns;

address_tb <= "00" & x"0000" after 100 ns,
              "00" & x"0001" after 150 ns,
              "00" & x"0002" after 200 ns,
              "00" & x"0003" after 250 ns,
              "00" & x"0004" after 300 ns,
              "00" & x"0005" after 350 ns,
              "00" & x"0006" after 400 ns,
              "01" & x"0000" after 450 ns,
              "01" & x"0001" after 500 ns,
              "01" & x"0002" after 550 ns,
              "01" & x"0003" after 600 ns,
              "01" & x"0004" after 650 ns,
              "01" & x"0005" after 700 ns,
              "01" & x"0006" after 750 ns,
              "01" & x"0007" after 800 ns,
              "01" & x"0008" after 850 ns,
              "00" & x"0005" after 900 ns,
              "00" & x"0006" after 950 ns,
              "01" & x"0000" after 1000 ns,
              "01" & x"0001" after 1050 ns,
              "01" & x"0002" after 1100 ns,
              "01" & x"0003" after 1150 ns,
              "01" & x"0004" after 1200 ns,
              "01" & x"0005" after 1250 ns,
              "01" & x"0006" after 1300 ns,
              "01" & x"0007" after 1350 ns,
              "01" & x"0008" after 1400 ns,
              "11" & x"0000" after 1440 ns,
              "11" & x"0001" after 1450 ns,
              "11" & x"0002" after 1460 ns,
              "11" & x"0003" after 1470 ns,
              "11" & x"0004" after 1480 ns,
              "11" & x"0005" after 1490 ns,
              "11" & x"0006" after 1500 ns,
              "11" & x"0007" after 1510 ns,
              "11" & x"0008" after 1520 ns;


write_en_tb <= '1' after 100 ns,
               '0' after 110 ns,
               '1' after 150 ns,
               '0' after 160 ns,
               '1' after 200 ns,
               '0' after 210 ns,
               '1' after 250 ns,
               '0' after 260 ns,
               '1' after 300 ns,
               '0' after 310 ns,
               '1' after 350 ns,
               '0' after 360 ns,
               '1' after 400 ns,
               '0' after 410 ns,
               '1' after 450 ns,
               '0' after 460 ns,
               '1' after 500 ns,
               '0' after 510 ns,
               '1' after 550 ns,
               '0' after 560 ns,
               '1' after 600 ns,
               '0' after 610 ns,
               '1' after 650 ns,
               '0' after 660 ns,
               '1' after 700 ns,
               '0' after 710 ns,
               '1' after 750 ns,
               '0' after 760 ns,
               '1' after 800 ns,
               '0' after 810 ns,
               '1' after 850 ns,
               '0' after 860 ns,
               '1' after 900 ns,
               '0' after 910 ns,
               '1' after 950 ns,
               '0' after 960 ns,
               '1' after 1000 ns,
               '0' after 1010 ns,
               '1' after 1050 ns,
               '0' after 1060 ns,
               '1' after 1100 ns,
               '0' after 1110 ns,
               '1' after 1150 ns,
               '0' after 1160 ns,
               '1' after 1200 ns,
               '0' after 1210 ns,
               '1' after 1250 ns,
               '0' after 1260 ns,
               '1' after 1300 ns,
               '0' after 1310 ns,
               '1' after 1350 ns,
               '0' after 1360 ns,
               '1' after 1400 ns,
               '0' after 1410 ns;

writedata_tb <= x"00000003" after 100 ns,
                x"00000003" after 150 ns,
                x"00000003" after 200 ns,
                x"00000009" after 250 ns,
                x"fffffff8" after 300 ns,
                x"00000000" after 350 ns,
                x"00000009" after 400 ns,
                x"46c37c00" after 450 ns,
                x"c600bc00" after 500 ns,
                x"c77d0b00" after 550 ns,
                x"470ba600" after 600 ns,
                x"46435c00" after 650 ns,
                x"c68b9800" after 700 ns,
                x"471c1500" after 750 ns,
                x"c7670300" after 800 ns,
                x"c7598600" after 850 ns,
                x"fffffff8" after 900 ns,
                x"00000009" after 950 ns,
                x"42e94400" after 1000 ns,
                x"4303c100" after 1050 ns,
                x"428f5a00" after 1100 ns,
                x"421e6c00" after 1150 ns,
                x"c2145400" after 1200 ns,
                x"42834200" after 1250 ns,
                x"c2e8ec00" after 1300 ns,
                x"42ba2000" after 1350 ns,
                x"c32b3200" after 1400 ns;


  dut : entity work.matrix_multiplier_avalon
    port map(
      wr_clk      =>      clk_tb,
      rd_clk      =>      clk_tb,
      rst         =>      rst_tb,
      address     =>  address_tb,
      chipselect  =>chipselect_tb,
      write_en    => write_en_tb,
      writedata   =>writedata_tb,
      readdata    => readdata_tb
    );

end architecture testbench;
