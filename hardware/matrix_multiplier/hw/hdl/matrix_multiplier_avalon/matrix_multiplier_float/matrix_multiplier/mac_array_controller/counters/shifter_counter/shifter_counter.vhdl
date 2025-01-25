library ieee;

use ieee.std_logic_1164.all;
use    ieee.numeric_std.all;

entity shifter_counter is
  generic(
    macs_size           :       integer          :=           7;
    memory_size         :       integer          :=          10
  );
  port(
    clk                 :       in                                   std_logic;
    rst                 :       in                                   std_logic;
    ena                 :       in                                   std_logic;
    sync_clr            :       in                                   std_logic;
    rows                :       in                                   std_logic;
    matrix_com_dim      :       in    std_logic_vector(memory_size-1 downto 0);
    matrix_b_cols       :       in      std_logic_vector(macs_size-1 downto 0);
    matrix_a_rows       :       in      std_logic_vector(macs_size-1 downto 0);
    shift               :       out     std_logic_vector(macs_size-1 downto 0);
    column              :       out   std_logic_vector(memory_size-1 downto 0);
    row                 :       out   std_logic_vector(memory_size-1 downto 0);
    min_tick_col        :       out                                  std_logic;
    max_tick_col        :       out                                  std_logic;
    max_tick_matrix     :       out                                  std_logic
  );
end entity shifter_counter;

architecture rtl of shifter_counter is
  --COLUMN COUNTER
  signal max_tick_col_unfiltered  :                       std_logic;
  signal max_tick_col_pulse       :                       std_logic;
  signal min_tick_col_unfiltered  :                       std_logic;
  --ROW COUNTER
  signal max_tick_row             :                       std_logic;
begin
  
  --COLUMN COUNTER
  main_counter: entity work.column_counter
    generic map(
      macs_size         =>        macs_size,
      memory_size       =>      memory_size
    )
    port map(
      clk               =>                       clk,
      rst               =>                       rst,
      ena               =>                       ena,
      sync_clr          =>                  sync_clr,
      matrix_com_dim    =>            matrix_com_dim,
      matrix_b_cols     =>             matrix_b_cols,
      rows              =>                      rows,
      column            =>                    column,
      min_tick_col      =>   min_tick_col_unfiltered,
      max_tick_col      =>   max_tick_col_unfiltered,
      shift             =>                     shift
    );
  --MAX TICK WHEN ROW IS LOADED
  max_tick_col_pulse <= max_tick_col_unfiltered and ena;
  max_tick_col       <=              max_tick_col_pulse;
  --MIN TICK WHEN ROW WAS JUST LOADED
  min_tick_col       <= min_tick_col_unfiltered and ena;

  --ROW COUNTER
  secundary_counter: entity work.row_counter
    generic map(
      macs_size         =>            macs_size,
      memory_size       =>          memory_size
    )
    port map(
      clk               =>                  clk,
      rst               =>                  rst,
      ena               =>   max_tick_col_pulse,
      sync_clr          =>             sync_clr,
      matrix_a_rows     =>        matrix_a_rows,
      matrix_com_dim    =>       matrix_com_dim,
      rows              =>                 rows,
      row               =>                  row,
      max_tick_row      =>         max_tick_row
    );
  --MAX TICK WHEN MATRIX IS LOADED
  max_tick_matrix <= max_tick_row and max_tick_col_pulse;
  
end architecture;

