library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity matrix_multiplier_float is
  generic(
    macs_total          :       integer         :=      128;
    macs_size           :       integer         :=        7;
    memory_size         :       integer         :=        9;
    mult_bits           :       integer         :=       16;
    sum_bits            :       integer         :=       43
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
    operand             :       in             std_logic_vector(31 downto 0);
    max_exponent        :       in              std_logic_vector(7 downto 0);
    res_address         :       in    std_logic_vector(macs_size-1 downto 0);
    shift_result        :       in              std_logic_vector(7 downto 0);
    res                 :       out            std_logic_vector(31 downto 0);
    data_ready          :       out                                std_logic
  );
end entity matrix_multiplier_float;

architecture rtl of matrix_multiplier_float is
  signal operand_converted      :       std_logic_vector(mult_bits downto 0);
  signal operand_converted_reg  :       std_logic_vector(mult_bits downto 0);
  signal new_value_delayed      :                                  std_logic;
  signal matrix_loaded_delayed  :                                  std_logic;
begin
  
  --CAST FLOAT32 TO SIGN MAGNITUDE INTEGER
  floating_point_conversion: entity work.float32_to_integer
    port map(
      float32_max_exponent =>          max_exponent,
      float32_value        =>               operand,
      integer_value        =>     operand_converted
    );
  
  --STORE VALUES IN REGISTERS
  operand_reg: process(wr_clk, rst, matrix_loaded)
  begin
    if(rst='1') then
      new_value_delayed     <=           '0';
      operand_converted_reg <= (others=>'0');
      matrix_loaded_delayed <=           '0';
    elsif(rising_edge(wr_clk)) then
      operand_converted_reg <= operand_converted;
      matrix_loaded_delayed <= matrix_loaded;
      new_value_delayed <= new_value;
    end if;
  end process;
  
  --MATRIX MULTIPLIER
  matrix_mult: entity work.matrix_multiplier
    generic map(
      macs_total        =>            macs_total,
      macs_size         =>             macs_size,
      memory_size       =>           memory_size,
      mult_bits         =>             mult_bits,
      sum_bits          =>              sum_bits
    )
    port map(
      wr_clk            =>                wr_clk,
      rd_clk            =>                rd_clk,
      rst               =>                   rst,
      new_value         =>     new_value_delayed,
      matrix_a_rows     =>         matrix_a_rows,
      matrix_b_cols     =>         matrix_b_cols,
      matrix_dim_common =>     matrix_dim_common,
      results_total     =>         results_total,
      matrix_loaded     => matrix_loaded_delayed,
      matrix_uploaded   =>       matrix_uploaded,
      operand           => operand_converted_reg,
      res_address       =>           res_address,
      shift_result      =>          shift_result,
      res               =>                   res,
      data_ready        =>            data_ready
    );

end architecture rtl;
