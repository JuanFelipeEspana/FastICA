library ieee;

use ieee.std_logic_1164.all;
use    ieee.numeric_std.all;

entity memory_decoder is
  generic(
    macs_total          :       integer         :=   128;
    macs_size           :       integer         :=     7;
    memory_size         :       integer         :=     9 
  );
  port(
    clk                 :       in                                    std_logic;
    rst                 :       in                                    std_logic;
    sync_clr_shifter    :       in                                    std_logic;
    change_decoding     :       in                                    std_logic;
    ena_shifter         :       in                                    std_logic;
    rows                :       in                                    std_logic;
    matrix_a_rows       :       in       std_logic_vector(macs_size-1 downto 0);
    matrix_b_cols       :       in       std_logic_vector(macs_size-1 downto 0);
    matrix_dim_common   :       in     std_logic_vector(memory_size-1 downto 0);
    min_tick_col        :       out                                   std_logic;
    max_tick_col        :       out                                   std_logic;
    last_element        :       out                                   std_logic;
    wr_en               :       out     std_logic_vector(macs_total-1 downto 0);
    wr_address          :       out    std_logic_vector(memory_size-1 downto 0)
  );
end entity memory_decoder;

architecture rtl of memory_decoder is
  --SHIFTER COUNTER SIGNALS
  signal column             :      std_logic_vector(memory_size-1 downto 0);
  signal row                :      std_logic_vector(memory_size-1 downto 0);
  signal shift              :        std_logic_vector(macs_size-1 downto 0);
  --ROW DECODER
  signal row_wr_en          :       std_logic_vector(macs_total-1 downto 0);
  --COLUMN DECODER
  signal col_wr_en          :       std_logic_vector(macs_total-1 downto 0);
  --MEMORY DECODER
  signal col_wr_en_reg      :       std_logic_vector(macs_total-1 downto 0);
  signal row_wr_en_reg      :       std_logic_vector(macs_total-1 downto 0);
  signal final_wr_en        :       std_logic_vector(macs_total-1 downto 0);
  signal shifted_wr_en      :       std_logic_vector(macs_total-1 downto 0);
begin
  
  --COUNTER TO DETERMINE SHIFT VALUE OF MEMORY DECODING, AND CURRENT POS
  matrix_index: entity work.shifter_counter
    generic map(
      macs_size         =>               macs_size,
      memory_size       =>             memory_size    
    )
    port map(
      clk               =>                     clk,
      rst               =>                     rst,
      ena               =>             ena_shifter,
      sync_clr          =>        sync_clr_shifter,
      rows              =>                    rows,
      matrix_a_rows     =>           matrix_a_rows,
      matrix_b_cols     =>           matrix_b_cols,
      matrix_com_dim    =>       matrix_dim_common,
      shift             =>                   shift,
      column            =>                  column,
      row               =>                     row,
      min_tick_col      =>            min_tick_col,
      max_tick_col      =>            max_tick_col,
      max_tick_matrix   =>            last_element
    );

  --MEMORY WRITE ADDRESS
  wr_address <= column when rows='1' else
                row;

  ---DECODING PATTERN FOR FIRST MATRIX
  matrix_a_decoder: entity work.row_decoder
    generic map(
      macs_total        =>       macs_total,
      macs_size         =>        macs_size
    )
    port map(
      matrix_dimension  =>    matrix_b_cols,
      wr_en             =>        row_wr_en
    );

  --DECODING PATTERN FOR SECOND MATRIX
  matrix_b_decoder: entity work.column_decoder
    generic map(
      macs_total        =>       macs_total,
      macs_size         =>        macs_size
    )
    port map(
      matrix_dim        =>    matrix_b_cols,
      wr_en             =>        col_wr_en
    );

  --EACH PATTERN IS STORED IN REGISTERS TO INCREASE FREQ
  reg_ena: process(clk, rst)
  begin
    if(rst = '1') then
      col_wr_en_reg <= (others=>'0');
      row_wr_en_reg <= (others=>'0');
    elsif(rising_edge(clk)) then
      if(change_decoding='1') then
        col_wr_en_reg <= col_wr_en;
        row_wr_en_reg <= row_wr_en;
      end if;
    end if;
  end process;
  final_wr_en <= row_wr_en_reg when rows='1' else
                 col_wr_en_reg;
  
  --SHIFT DECODING TO WRITE IN CORRECT MAC MEMORY
  memory_shifting: entity work.barrelShifter
    generic map(
      nShifts           =>               macs_size,
      nBits             =>              macs_total
    )
    port map(
      input             =>             final_wr_en,
      shift             =>                   shift,
      output            =>           shifted_wr_en
    );
  wr_en <= shifted_wr_en;
  
end architecture rtl;
