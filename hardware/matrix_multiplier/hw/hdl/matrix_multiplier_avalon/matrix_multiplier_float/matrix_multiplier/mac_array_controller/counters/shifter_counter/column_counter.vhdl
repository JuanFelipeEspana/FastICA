library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity column_counter is 
  generic(
    macs_size           :       integer                 :=  7;
    memory_size         :       integer                 := 10
  );
  port(
    clk                 :       in                                      std_logic;
    rst                 :       in                                      std_logic;
    ena                 :       in                                      std_logic;
    sync_clr            :       in                                      std_logic;
    matrix_com_dim      :       in       std_logic_vector(memory_size-1 downto 0);
    rows                :       in                                      std_logic;
    matrix_b_cols       :       in         std_logic_vector(macs_size-1 downto 0);
    column              :       out      std_logic_vector(memory_size-1 downto 0);
    min_tick_col        :       out                                     std_logic;
    max_tick_col        :       out                                     std_logic;
    shift               :       out        std_logic_vector(macs_size-1 downto 0)
  );
end entity column_counter;

architecture rtl of column_counter is
  constant ZEROS                : std_logic_vector(memory_size-1 downto 0) := (others=>'0');
  --COUNTER SIGNALS
  signal count_s                :                          unsigned(memory_size-1 downto 0);
  signal count_next             :                          unsigned(memory_size-1 downto 0);	
  signal shift_for_rows         :                  std_logic_vector(memory_size-1 downto 0);
  --MATRIX DIMENSION SIGNALS
  signal matrix_b_cols_extended :                  std_logic_vector(memory_size-1 downto 0);
  signal number_columns         :                  std_logic_vector(memory_size-1 downto 0);
  --ADDITIONAL SIGNALS
  signal max_tick_col_s         :                                                 std_logic;
  signal shift_extended         :                  std_logic_vector(memory_size-1 downto 0);
  signal ena_shift_rows         :                                                 std_logic;
begin
  --EXTEND B COLS BITS TO MATCH COUNTER SIZE
  matrix_b_cols_extended <= ZEROS((memory_size-macs_size)-1 downto 0) & matrix_b_cols;
  
  --DETERMINE NUMBER OF COLS BASED ON WHICH MATRIX IS BEING LOADED
  number_columns <= matrix_com_dim when rows = '1' else
                    matrix_b_cols_extended;
  
  --DEFINE COUNTER NEXT VALUE
  count_next  <= (others => '0')                   when sync_clr='1'                             else
                 (others => '0')                   when count_s = (unsigned(number_columns) - 1) else
                 count_s + 1 	                     when (ena ='1')                               else
                 count_s;
  
  --COUNT BY ONE AND ENABLE SHIFT FOR ROWS
  ena_shift_rows <= (ena AND max_tick_col_s);
  process(clk,rst)
    variable temp : unsigned(memory_size-1 downto 0);
  begin	
    if(rst='1') then
      temp      := (others => '0');
      shift_for_rows <= (others => '0');
    elsif (rising_edge(clk)) then
      if(sync_clr = '1') then
        shift_for_rows <= (others => '0');
      elsif (ena_shift_rows = '1') then
        shift_for_rows <= std_logic_vector(unsigned(shift_for_rows) + unsigned(matrix_b_cols));
      end if;
      if (ena='1') then
        temp := count_next;
      end if;
    end if;
    count_s  <= temp;
  end process;
  --ADDITIONAL SIGNALS
  max_tick_col_s <= '1' when count_s = (unsigned(number_columns) - 1) else
                    '0';
  shift_extended <= shift_for_rows when rows = '1' else
                    std_logic_vector(count_s);
  
  --OUT SIGNALS
  column         <= std_logic_vector(count_s);
  max_tick_col   <= max_tick_col_s;
  min_tick_col   <= '1' when count_s = unsigned(ZEROS) else
                    '0';
    
  shift           <= shift_extended(macs_size-1 downto 0);
  
end architecture;
