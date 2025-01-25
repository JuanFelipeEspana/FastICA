library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_matrix.all;

entity single_memory_block is
  port(
    clk                 :       in      std_logic;
    rst                 :       in      std_logic;
    ena                 :       in      std_logic;
    wr_en               :       in      std_logic;
    address             :       in      std_logic_vector(6 downto 0);
    data                :       in      std_logic_vector(24 downto 0);
    q                   :       out     std_logic_vector(24 downto 0);
    data_usable         :       out     std_logic
  );
end entity single_memory_block;

architecture rtl of single_memory_block is
  signal readable_reg           :       std_logic;
begin
  mem: entity work.single_memory
    port map(
      address         =>      address(6 downto 0),
      clock           =>      clk,
      data            =>      data,
      wren            =>      wr_en,
      q               =>      q
    );

  read_wait: process(rst, clk, ena)
  begin
    if(rst = '1') then
      readable_reg <= '0';
    elsif(rising_edge(clk)) then
      if(ena = '1') then
        readable_reg <= not readable_reg;
      else
        readable_reg <= '0';
      end if;
    end if;
  end process;
  
  data_usable <= readable_reg;
end architecture rtl;
