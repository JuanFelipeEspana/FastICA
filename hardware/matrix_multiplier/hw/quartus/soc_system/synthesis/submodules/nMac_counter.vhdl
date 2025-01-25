library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nMac_counter is 
  generic (
    macs_size           :       integer                 :=           7;
    memory_size         :       integer                 :=          10
  );
  port(
    clk             :       in                                   std_logic;
    rst             :       in                                   std_logic;
    ena             :       in                                   std_logic;
    syn_clr         :       in                                   std_logic;
    matrix_a_rows   :       in      std_logic_vector(macs_size-1 downto 0);
    matrix_com_dim  :       in    std_logic_vector(memory_size-1 downto 0);
    rows            :       in                                   std_logic;
    max_tick        :       out                                  std_logic;
    counter         :       out   std_logic_vector(memory_size-1 downto 0)
  );
end entity nMac_counter;

architecture rtl of nMac_counter is
  constant ZEROS_slv            : std_logic_vector(memory_size-1 downto 0) := (others=>'0');
  constant ONES                 :       unsigned(memory_size-1 downto 0) := (others => '1');
  constant ZEROS                :       unsigned(memory_size-1 downto 0) := (others => '0');
  constant ONE_1                :                                          std_logic := '1';
  signal count_s                :                          unsigned(memory_size-1 downto 0);	
  signal count_next             :                          unsigned(memory_size-1 downto 0);
  signal max_val                :                  std_logic_vector(memory_size-1 downto 0);
  signal max                    :                  std_logic_vector(memory_size-1 downto 0);
  signal matrix_a_rows_extended :                  std_logic_vector(memory_size-1 downto 0);
begin
  
  matrix_a_rows_extended <= ZEROS_slv((memory_size-macs_size)-1 downto 0) & matrix_a_rows;
  
  max     <= matrix_a_rows_extended when rows = '1' else
             matrix_com_dim;
  max_val          <=    std_logic_vector(unsigned(max)-1);
  
  --NEXT STATE LOGIC
  count_next <= (others => '0')	when syn_clr='1'                   else
                (others => '0')	when count_s = unsigned(max_val)   else
                count_s +1      when ena ='1'                      else
                count_s;
  
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
    counter <= std_logic_vector(temp);
    count_s <= temp;
  end process;

  max_tick <= '1' when count_s = unsigned(max_val)  else
              '0';

end architecture;
