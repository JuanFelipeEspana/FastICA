library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_matrix.all;

entity memory_blocks is
  port(
    clk                 :       in      std_logic;
    rst                 :       in      std_logic;
    ena                 :       in      std_logic;
    wr_en               :       in      std_logic;
    address             :       in      std_logic_vector(13 downto 0);
    data                :       in      std_logic_vector(24 downto 0);
    q                   :       out     read_memories(0 to 127);
    data_usable         :       out     std_logic
  );
end entity memory_blocks;

architecture rtl of memory_blocks is
  signal decoder_memory         :       std_logic_vector(127 downto 0);
  signal readable_reg           :       std_logic;
begin
  write_data: for i in 0 to 127 generate
    decoder_memory(i) <= wr_en when (address(13 downto 7)=std_logic_vector(to_unsigned(i, 7))) else
                         '0';
  end generate;

  memory_array: for i in 0 to 127 generate
    mem: entity work.single_memory
      port map(
        address         =>      address(6 downto 0),
        clock           =>      clk,
        data            =>      data,
        wren            =>      decoder_memory(i),
        q               =>      q(i)
      );
  end generate;

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
