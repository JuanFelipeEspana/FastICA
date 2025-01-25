library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculating_counter is
  generic(
    macs_size   :       integer         :=      7;
    memory_size :       integer         :=      9
  );
  port(
    clk                 :       in                                  std_logic;
    rst                 :       in                                  std_logic;
    ena                 :       in                                  std_logic;
    sync_clr            :       in                                  std_logic;
    loaded_row          :       in                                  std_logic;
    matrix_dim_common   :       in   std_logic_vector(memory_size-1 downto 0);
    max_tick            :       out                                 std_logic;
    address             :       out  std_logic_vector(memory_size-1 downto 0)
  );
end entity calculating_counter;

architecture rtl of calculating_counter is
  signal real_enable    :                            std_logic;
  signal operated       :                            std_logic;
  signal final_result   :                            std_logic;
  signal ena_seg        :                            std_logic;
begin

  segmentation_counter_ena: process(clk, rst)
  begin
    if(rst = '1') then
      ena_seg <= '0';
    elsif(rising_edge(clk)) then
      if(sync_clr='1') then
        ena_seg <= '0';
      elsif((operated='1') or (final_result='1')) then
        ena_seg <= not ena_seg;
      end if;
    end if;
  end process;

  real_enable <= ena and loaded_row;
  
  calculating_counter: entity work.univ_bin_counter
    generic map(
      N                 =>             memory_size
    )
    port map(
      clk               =>                     clk,
      rst               =>                     rst,
      ena               =>             real_enable,
      sync_clr          =>                sync_clr,
      load              =>                     '0',
      up                =>                     '1',
      data              =>         (others => '0'),
      limit             =>       matrix_dim_common,
      max_tick          =>                operated,
      min_tick          =>                    open,
      counter           =>                 address
    );
      
  segmentation_counter: entity work.univ_bin_counter
    generic map(
      N                 =>                       2
    )
    port map(
      clk               =>                     clk,
      rst               =>                     rst,
      ena               =>                 ena_seg,
      sync_clr          =>                sync_clr,
      load              =>                     '0',
      up                =>                     '1',
      data              =>         (others => '0'),
      limit             =>                    "01",
      max_tick          =>            final_result,
      min_tick          =>                    open,
      counter           =>                    open
    );
      
  max_tick <= operated;
          
end architecture rtl;
