library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_memory is
  port(
    data        :       in      std_logic_vector(16 downto 0);
    rdaddress   :       in      std_logic_vector(9 downto 0);
    rdclock     :       in      std_logic;
    rdclocken   :       in      std_logic;
    wraddress   :       in      std_logic_vector(9 downto 0);
    wrclock     :       in      std_logic;
    wrclocken   :       in      std_logic;
    wren        :       in      std_logic;
    q           :       out     std_logic_vector(16 downto 0);
    rd_ready    :       out     std_logic
  );
end entity single_memory;

architecture rtl of single_memory is
  signal new_data       :       std_logic;
begin

  strobe: process(rdclock, rdclocken)
  begin
    if(rdclocken='0') then
      new_data <= '1';
    elsif(rising_edge(rdclock)) then
      new_data <= not new_data;
    end if;
  end process;

  rd_ready <= new_data;

  memory_ip: entity work.memory
    port map(
      data      =>           data,
      rdaddress =>      rdaddress,
      rdclock   =>        rdclock,
      rdclocken =>      rdclocken,
      wraddress =>      wraddress,
      wrclock   =>        wrclock,
      wrclocken =>      wrclocken,
      wren      =>           wren,
      q         =>              q
    );

end architecture rtl;
