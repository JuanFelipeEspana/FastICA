library ieee;

use ieee.std_logic_1164.all;
use    ieee.numeric_std.all;

entity row_counter is 
  generic (
    macs_size           :       integer                 :=           7;
    memory_size         :       integer                 :=          10
  );
  port(
    clk             :       in                                   std_logic;
    rst             :       in                                   std_logic;
    ena             :       in                                   std_logic;
    sync_clr        :       in                                   std_logic;
    matrix_a_rows   :       in      std_logic_vector(macs_size-1 downto 0);
    matrix_com_dim  :       in    std_logic_vector(memory_size-1 downto 0);
    rows            :       in                                   std_logic;
    row             :       out   std_logic_vector(memory_size-1 downto 0);
    max_tick_row    :       out                                  std_logic
  );
end entity row_counter;

architecture rtl of row_counter is
  constant ZEROS                : std_logic_vector(memory_size-1 downto 0) := (others=>'0');
  --COUNTER SIGNALS
  signal count_actual           :                          unsigned(memory_size-1 downto 0);	
  signal count_next             :                          unsigned(memory_size-1 downto 0);
  --MATRIX DIMENSIONS
  signal number_rows            :                  std_logic_vector(memory_size-1 downto 0);
  signal matrix_a_rows_extended :                  std_logic_vector(memory_size-1 downto 0);
begin

  --EXTEND MATRIX A ROW DIMENSION TO MATCH COUNTER SIZE
  matrix_a_rows_extended <= ZEROS((memory_size-macs_size)-1 downto 0) & matrix_a_rows;
  
  --DETERMINE NUMBER OF ROWS BASED ON WHICH MATRIX IS BEING LOADED
  number_rows  <= matrix_a_rows_extended when rows = '1' else
                  matrix_com_dim;
  
  --DEFINE COUNTER NEXT VALUE
  count_next <= (others => '0')	 when sync_clr='1'                               else
                (others => '0')	 when count_actual = (unsigned(number_rows)-1)   else
                count_actual + 1 when ena ='1'                                   else
                count_actual;
  
  --UPDATE COUNTER SIGNAL
  process(clk,rst)
    variable temp : unsigned(memory_size-1 downto 0);
  begin	
    if(rst='1') then
      temp := (others => '0');
    elsif (rising_edge(clk)) then
      if (ena='1') then
        temp := count_next;
      end if;
    end if;
    row <= std_logic_vector(temp);
    count_actual <= temp;
  end process;

  --MAX TICK WHEN ROW WAS LOADED
  max_tick_row <= '1' when count_actual = (unsigned(number_rows)-1)  else
                  '0';

end architecture;
