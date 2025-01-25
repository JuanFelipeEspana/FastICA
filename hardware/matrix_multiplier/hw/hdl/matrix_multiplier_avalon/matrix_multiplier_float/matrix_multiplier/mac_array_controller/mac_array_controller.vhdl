library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mac_array_controller is
  generic(
    macs_total          :       integer         :=      128;
    macs_size           :       integer         :=        7;
    memory_size         :       integer         :=        9
  );
  port(
    wr_clk              :       in                                 std_logic;
    rd_clk              :       in                                 std_logic;
    rst                 :       in                                 std_logic;
    new_value           :       in                                 std_logic;
    load_a              :       in                                 std_logic;
    matrix_a_rows       :       in    std_logic_vector(macs_size-1 downto 0);
    matrix_b_cols       :       in    std_logic_vector(macs_size-1 downto 0);
    matrix_dim_common   :       in  std_logic_vector(memory_size-1 downto 0);
    results_total       :       in      std_logic_vector(macs_size downto 0);
    matrix_loaded       :       in                                 std_logic;
    matrix_uploaded     :       in                                 std_logic;
    wr_en               :       out  std_logic_vector(macs_total-1 downto 0);
    wr_address          :       out std_logic_vector(memory_size-1 downto 0);
    mem_a_wren          :       out                                std_logic;
    mem_b_wren          :       out                                std_logic;
    rd_en               :       out                                std_logic;
    rd_address          :       out std_logic_vector(memory_size-1 downto 0);
    strobe              :       out                                std_logic;
    macs_ena            :       out  std_logic_vector(macs_total-1 downto 0);
    sync_clr_macs       :       out                                std_logic;
    sync_clr_uploading  :       out                                std_logic;
    data_ready          :       out                                std_logic
  );
end entity mac_array_controller;

architecture rtl of mac_array_controller is
  --FSM SIGNALS
  signal sync_clr_shifter      :               std_logic;
  signal sync_clr_operating    :               std_logic;
  signal ena_shifter           :               std_logic;
  signal ena_operating         :               std_logic;
  signal change_decoding       :               std_logic;
  signal rows                  :               std_logic;
  --MEMORY DECODER SIGNALS
  signal min_tick_col          :               std_logic;
  signal max_tick_col          :               std_logic;
  signal last_element          :               std_logic;
  --OPERATION COUNTER
  signal matrix_operated       :               std_logic;
  --READ ENABLE FOR MEMORIES
  signal rd_en_con             :               std_logic;
  signal rd_en_delayed         :               std_logic;
  signal rd_en_full            :               std_logic;
begin

  --FINITE STATE MACHINE 
  finite_state_machine: entity work.mac_array_controller_fsm
  port map(
    wr_clk               =>                wr_clk,
    rd_clk               =>                rd_clk,
    rst                  =>                   rst,
    new_value            =>             new_value,
    reload_a             =>                load_a,
    max_tick_loading     =>         matrix_loaded,
    max_tick_calculate   =>       matrix_operated,
    max_tick_uploading   =>       matrix_uploaded,
    sync_clr_shifter     =>      sync_clr_shifter,
    sync_clr_operating   =>    sync_clr_operating,
    sync_clr_uploading   =>    sync_clr_uploading,
    sync_clr_macs        =>         sync_clr_macs,
    ena_shifter          =>           ena_shifter,
    ena_operating        =>         ena_operating,
    mem_a_wren           =>            mem_a_wren,
    mem_b_wren           =>            mem_b_wren,
    change_decoding      =>       change_decoding,
    rows                 =>                  rows,
    data_ready           =>            data_ready
  );

  --MEMORY DECODER FOR WRITING IN MACS MEMORY
  memory_decoder: entity work.memory_decoder
    generic map(
      macs_total        =>              macs_total,
      macs_size         =>               macs_size,
      memory_size       =>             memory_size
    )
    port map(
      clk               =>                  wr_clk,
      rst               =>                     rst,
      sync_clr_shifter  =>        sync_clr_shifter,
      change_decoding   =>         change_decoding,
      ena_shifter       =>             ena_shifter,
      rows              =>                    rows,
      matrix_a_rows     =>           matrix_a_rows,
      matrix_b_cols     =>           matrix_b_cols,
      matrix_dim_common =>       matrix_dim_common,
      min_tick_col      =>            min_tick_col,
      max_tick_col      =>            max_tick_col,
      last_element      =>            last_element,
      wr_en             =>                   wr_en,
      wr_address         =>             wr_address
    );

  --STROBE FOR OPERATION WHEN ROW OF MATRIX B LOADED
  strobe <= max_tick_col and ena_operating;

  --COUNTER FOR STROBES AND DETERMINE END OF OPERATION
  operation_counter: entity work.operation_counter
    generic map(
      macs_size         =>               macs_size,
      memory_size       =>             memory_size
    )
    port map(
      clk               =>                  rd_clk,
      rst               =>                     rst,
      ena               =>           ena_operating,
      sync_clr          =>      sync_clr_operating,
      row_loaded        =>            min_tick_col,
      matrix_dim_common =>       matrix_dim_common,
      address           =>              rd_address,
      operated          =>         matrix_operated
    );
  
  --NUMBER OF MACS ENABLED NEEDED FOR OPERATION
  enable_macs: entity work.macs_ena
    generic map(
      macs_total        =>              macs_total,
      macs_size         =>               macs_size
    )
    port map(
      results_total     =>           results_total,
      enable_macs       =>                macs_ena
    );
   
  --READ ENABLE FOR M10K BLOCKS TAKE 2 CYCLES, SO DELAY NEEDED
  rd_en_con  <= (((max_tick_col and (not rows))and(not last_element)) or (last_element and rows));
  delayed_bit: process(rd_clk, rst)
  begin
    if(rst='1') then
      rd_en_delayed <= '0';
    elsif(rising_edge(rd_clk)) then
      rd_en_delayed <= rd_en_con;
    end if;
  end process;
  rd_en_full <= rd_en_con or rd_en_delayed;
  rd_en      <= rd_en_full;

end architecture rtl;
