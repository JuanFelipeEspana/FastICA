library ieee;

use ieee.std_logic_1164.all;
use    ieee.numeric_std.all;
use   work.type_results.all;

entity matrix_multiplier is
  generic(
    macs_total          :       integer         :=      128;
    macs_size           :       integer         :=        7;
    memory_size         :       integer         :=        9;
    mult_bits           :       integer         :=       16;
    sum_bits            :       integer         :=       32
  );
  port(
    wr_clk              :       in                                 std_logic;
    rd_clk              :       in                                 std_logic;
    rst                 :       in                                 std_logic;
    new_value           :       in                                 std_logic;
    matrix_a_rows       :       in    std_logic_vector(macs_size-1 downto 0);
    matrix_b_cols       :       in    std_logic_vector(macs_size-1 downto 0);
    matrix_dim_common   :       in  std_logic_vector(memory_size-1 downto 0);
    results_total       :       in      std_logic_vector(macs_size downto 0);
    matrix_loaded       :       in                                 std_logic;
    matrix_uploaded     :       in                                 std_logic;
    operand             :       in    std_logic_vector(mult_bits   downto 0);
    res_address         :       in    std_logic_vector(macs_size-1 downto 0);
    shift_result        :       in              std_logic_vector(7 downto 0);
    res                 :       out            std_logic_vector(31 downto 0);
    data_ready          :       out                                std_logic
  );
end entity matrix_multiplier;

architecture rtl of matrix_multiplier is
  --CONTROLLER SIGNALS
  signal macs_ena       :        std_logic_vector(macs_total-1 downto 0);
  signal wr_en          :        std_logic_vector(macs_total-1 downto 0);
  signal rd_en          :                                      std_logic;
  signal wr_address     :       std_logic_vector(memory_size-1 downto 0);
  signal rd_address     :       std_logic_vector(memory_size-1 downto 0);
  signal mem_a_wren     :                                      std_logic;
  signal mem_b_wren     :                                      std_logic;
  signal strobe         :                                      std_logic;
  signal sync_clr_macs  :                                      std_logic;
  --MACS SIGNALS
  signal mac_array_res  :            macs_results(macs_total-1 downto 0);
  --signal matrix_loaded_delayed :                               std_logic;
begin
  
  --CONTROLLER FOR MACS
  controller: entity work.mac_array_controller
    generic map(
      macs_total        =>              macs_total,
      macs_size         =>               macs_size,
      memory_size       =>             memory_size
    )
    port map(
      wr_clk            =>                  wr_clk,
      rd_clk            =>                  rd_clk,
      rst               =>                     rst,
      new_value         =>               new_value,
      matrix_a_rows     =>           matrix_a_rows,
      matrix_b_cols     =>           matrix_b_cols,
      matrix_dim_common =>       matrix_dim_common,
      results_total     =>           results_total,
      matrix_loaded     =>           matrix_loaded,
      matrix_uploaded   =>         matrix_uploaded,
      wr_en             =>                   wr_en,
      wr_address        =>              wr_address,
      mem_a_wren        =>              mem_a_wren,
      mem_b_wren        =>              mem_b_wren,
      rd_en             =>                   rd_en,
      rd_address        =>              rd_address,
      strobe            =>                  strobe,
      macs_ena          =>                macs_ena,
      sync_clr_macs     =>           sync_clr_macs,
      data_ready        =>              data_ready
    );
  
  --COLLECTION OF MACS
  macs: entity work.mac_array
    generic map(
      macs_total        =>              macs_total,
      macs_bits         =>               macs_size,
      memory_size       =>             memory_size,
      mult_bits         =>               mult_bits,
      sum_bits          =>                sum_bits
    )
    port map(
      wr_clock          =>                  wr_clk,
      rd_clock          =>                  rd_clk,
      rst               =>                     rst,
      sync_clr_macs     =>           sync_clr_macs,
      macs_ena          =>                macs_ena,
      operand           =>                 operand,
      strobe            =>                  strobe, 
      rdaddress         =>              rd_address,
      wraddress         =>              wr_address,
      mem_wren          =>                   wr_en,
      mem_rden          =>                   rd_en,
      mem_a_wren        =>              mem_a_wren,
      mem_b_wren        =>              mem_b_wren,
      res               =>           mac_array_res
    );
  
  --RESULT DECODER FOLLOWING IEEE754
  results_decoder: entity work.result_decoder
    generic map(
      macs_total        =>              macs_total,
      macs_bits         =>               macs_size,
      sum_bits          =>                sum_bits
    )
    port map(
      address           =>             res_address,
      results           =>           mac_array_res,
      shift_result      =>            shift_result,
      result            =>                     res
    );
      
end architecture rtl;
