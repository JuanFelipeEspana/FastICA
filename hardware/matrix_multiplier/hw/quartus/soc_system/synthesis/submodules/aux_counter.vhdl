library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aux_counter is 
  generic(
    macs_size           :       integer                 :=  7;
    memory_size         :       integer                 := 10
  );
  port(
    clk                 :       in                                      std_logic;
    rst                 :       in                                      std_logic;
    ena                 :       in                                      std_logic;
    syn_clr             :       in                                      std_logic;
    matrix_com_dim      :       in       std_logic_vector(memory_size-1 downto 0);
    rows                :       in                                      std_logic;
    matrix_b_cols       :       in         std_logic_vector(macs_size-1 downto 0);
    min_tick_col        :       out                                     std_logic;
    max_tick            :       out                                     std_logic;
    max_tick_minus      :       out                                     std_logic;
    nposMac             :       out      std_logic_vector(memory_size-1 downto 0);
    shift               :       out        std_logic_vector(macs_size-1 downto 0)
  );
end entity aux_counter;

architecture rtl of aux_counter is
  constant ZEROS_slv            : std_logic_vector(memory_size-1 downto 0) := (others=>'0');
  constant ZEROS                :       unsigned(memory_size-1 downto 0) := (others => '0');
  signal count_s                :                          unsigned(memory_size-1 downto 0);	
  signal counter_a              :                  std_logic_vector(memory_size-1 downto 0);
  signal max                    :                  std_logic_vector(memory_size-1 downto 0);
  signal counter_b              :                  std_logic_vector(memory_size-1 downto 0);
  signal reg                    :                  std_logic_vector(memory_size-1 downto 0);
  signal count_next             :                          unsigned(memory_size-1 downto 0);
  signal max_val                :                          unsigned(memory_size-1 downto 0);
  signal max_tick_s             :                                                 std_logic;
  signal ena_reg                :                                                 std_logic;
  signal shift_extended         :                  std_logic_vector(memory_size-1 downto 0);
  signal matrix_b_cols_extended :                  std_logic_vector(memory_size-1 downto 0);
begin
  matrix_b_cols_extended <= ZEROS_slv((memory_size-macs_size)-1 downto 0) & matrix_b_cols;
  
  max         <= matrix_com_dim when rows = '1' else
                 matrix_b_cols_extended;
  
  max_val     <= unsigned(max) - 1;

  count_next  <= (others => '0') when syn_clr='1'       else
                 (others => '0') when count_s = max_val else
                 count_s + 1 	 when ena ='1'          else
                 count_s;
  
  process(clk,rst)
    variable temp : unsigned(memory_size-1 downto 0);
  begin	
    if(rst='1') then
      temp := (others => '0');
      counter_a <= (others => '0');
    elsif (rising_edge(clk)) then
      if(syn_clr = '1') then
        counter_a <= (others => '0');
      elsif (ena_reg = '1') then
        counter_a <= reg;
      end if;
      if (ena='1') then
        temp := count_next;
      end if;
    end if;
    counter_b <= std_logic_vector(temp);
    count_s   <= temp;
  end process;
  
  ena_reg <= (ena AND max_tick_s);

  max_tick_minus <= '1' when count_s = (max_val-1) else
                    '0';
  
  max_tick_s    <= '1' when count_s = max_val else
                   '0';
  
  min_tick_col  <= '1' when count_s = ZEROS else
                   '0';
  
  shift_extended  <= counter_a when rows = '1' else
                     counter_b;

  shift <= shift_extended(macs_size-1 downto 0);
  
  max_tick <= max_tick_s;
  reg      <= std_logic_vector(unsigned(counter_a) + unsigned(matrix_b_cols)) when syn_clr = '0' else
					STD_logic_vector(ZEROS);
  nposMac  <= counter_b;
  
end architecture;
