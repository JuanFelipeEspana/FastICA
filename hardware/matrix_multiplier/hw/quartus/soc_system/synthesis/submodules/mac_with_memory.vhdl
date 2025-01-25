library ieee;

use ieee.std_logic_1164.all;
use    ieee.numeric_std.all;

entity mac_with_memory is
  generic(
    memory_size  :       integer         :=  9;
    mult_bits    :       integer         := 16;
    sum_bits     :       integer         := 32
  );
  port(
    wr_clock       :       in                                     std_logic;
    rd_clock       :       in                                     std_logic;
    rst            :       in                                     std_logic;
    sync_clr_mac   :       in                                     std_logic;
    ena            :       in                                     std_logic;
    strobe         :       in                                     std_logic;
    operand        :       in          std_logic_vector(mult_bits downto 0);
    rdaddress      :       in      std_logic_vector(memory_size-1 downto 0);
    wraddress      :       in      std_logic_vector(memory_size-1 downto 0);
    mem_wren       :       in                                     std_logic;
    mem_rden       :       in                                     std_logic;
    mem_a_wren     :       in                                     std_logic;
    mem_b_wren     :       in                                     std_logic;
    res            :       out        std_logic_vector(sum_bits-1 downto 0)
  );
end entity mac_with_memory;

architecture rtl of mac_with_memory is
  --OPERANDS
  signal operand_a      :       std_logic_vector(mult_bits downto 0);
  signal operand_b      :       std_logic_vector(mult_bits downto 0);

  --ENABLES
  signal ena_strobe     :                                  std_logic;
  signal ena_mem_wren   :                                  std_logic;
  signal ena_mem_rden   :                                  std_logic;
begin
  
  --ACTIVATE SIGNALS FOR MAC 
  ena_strobe <= strobe and ena;
  ena_mem_wren <= mem_wren and ena;
  ena_mem_rden <= mem_rden and ena;

  --MAC INSTANTIATION
  mac: entity work.mac
    generic map(
      mult_bits   =>   mult_bits,
      sum_bits    =>    sum_bits
    )  
    port map(
      clk         =>    rd_clock,
      rst         =>         rst,
      sync_clr    =>sync_clr_mac,
      strobe      =>  ena_strobe,
      dataa       =>   operand_a,
      datab       =>   operand_b,    
      res         =>         res
    );
    
  --MEMORY FOR A OPERANDS
  operands_a: entity work.single_memory
    generic map(
      memory_size  =>    memory_size,
      mult_bits    =>    mult_bits+1
    )
    port map(
      data        =>     operand,
      rdaddress   =>   rdaddress,
      rdclock     =>    rd_clock,
      rdclocken   =>ena_mem_rden,
      wraddress   =>   wraddress,
      wrclock     =>    wr_clock,
      wrclocken   =>ena_mem_wren,
      wren        =>  mem_a_wren,
      q           =>   operand_a
    );
  
  --MEMORY FOR B OPERANDS
  operands_b: process(wr_clock, rst, operand)
  begin
    if(rst = '1') then
      operand_b <= (others => '0');
    elsif(rising_edge(wr_clock)) then
      if((mem_b_wren)and(ena_mem_wren))='1' then
        operand_b <= operand;
      end if;
    end if;
  end process;
  
end architecture rtl;
