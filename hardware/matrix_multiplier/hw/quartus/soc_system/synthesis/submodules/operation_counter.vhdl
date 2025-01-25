library ieee;

use ieee.std_logic_1164.all;
use    ieee.numeric_std.all;

entity operation_counter is
  generic(
    macs_size   :       integer         :=      7;
    memory_size :       integer         :=      9
  );
  port(
    clk                 :       in                                  std_logic;
    rst                 :       in                                  std_logic;
    ena                 :       in                                  std_logic;
    sync_clr            :       in                                  std_logic;
    row_loaded          :       in                                  std_logic;
    matrix_dim_common   :       in   std_logic_vector(memory_size-1 downto 0);
    address             :       out  std_logic_vector(memory_size-1 downto 0);
    operated            :       out                                 std_logic
  );
end entity operation_counter;

architecture rtl of operation_counter is
  --STROBE COUNTER
  signal result_obtained    :                            std_logic;
  signal segmentation_wait  :                            std_logic;
  --SEGMENTATION COUNTER
  signal segmentation_start :                            std_logic;
  signal segmentation_done  :                            std_logic;
begin

  --COUNT EACH OPERATION DONE UNTIL MATRIX_DIM_COMMON IS REACHED
  result_obtained <= ena and row_loaded;
  result_counter: entity work.univ_bin_counter
    generic map(
      N                 =>             memory_size
    )
    port map(
      clk               =>                     clk,
      rst               =>                     rst,
      ena               =>         result_obtained,
      sync_clr          =>                sync_clr,
      load              =>                     '0',
      up                =>                     '1',
      data              =>         (others => '0'),
      limit             =>       matrix_dim_common,
      max_tick          =>       segmentation_wait,
      min_tick          =>                    open,
      counter           =>                 address
    );

  --ENABLE SEGMENTATION COUNTER WHEN ALL OPERATIONS DONE
  segmentation_counter_ena: process(clk, rst)
  begin
    if(rst = '1') then
      segmentation_start <= '0';
    elsif(rising_edge(clk)) then
      if(sync_clr='1') then
        segmentation_start <= '0';
      elsif((segmentation_wait='1') or (segmentation_done='1')) then
        segmentation_start <= not segmentation_start;
      end if;
    end if;
  end process;

  --COUNT SEGMENTATION STAGES
  segmentation_counter: entity work.univ_bin_counter
    generic map(
      N                 =>                       2
    )
    port map(
      clk               =>                     clk,
      rst               =>                     rst,
      ena               =>      segmentation_start,
      sync_clr          =>                sync_clr,
      load              =>                     '0',
      up                =>                     '1',
      data              =>         (others => '0'),
      limit             =>                    "01",
      max_tick          =>       segmentation_done,
      min_tick          =>                    open,
      counter           =>                    open
    );
  operated <= segmentation_done;
          
end architecture rtl;
