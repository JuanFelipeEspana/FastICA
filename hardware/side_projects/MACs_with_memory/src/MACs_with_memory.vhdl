library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MACs_with_memory is
  generic(
    mult_bits   :       integer         := 16;
    sum_bits    :       integer         := 20
  );
  port(
    --MACs
    wr_clock    :       in      std_logic;
    rd_clock    :       in      std_logic;
    rst         :       in      std_logic;
    --strobe      :       in      std_logic;
    operand     :       in      std_logic_vector(mult_bits downto 0);
    --MEMORY
    --data        :       in      std_logic_vector(16 downto 0);
    --rdaddress   :       in      std_logic_vector(9 downto 0);
    rdaddress   :       in      std_logic_vector(9 downto 0);
    wraddress   :       in      std_logic_vector(9 downto 0);
    mem_wren    :       in      std_logic;
    mem_rden    :       in      std_logic;
    mem_a_wren  :       in      std_logic;
    mem_b_wren  :       in      std_logic;
    res         :       out     std_logic_vector(sum_bits-1 downto 0)
    --rdclock     :       in      std_logic;
    --rdclocken   :       in      std_logic;
    --wraddress   :       in      std_logic_vector(9 downto 0);
    --wrclock     :       in      std_logic;
    --wrclocken   :       in      std_logic;
    --wren        :       in      std_logic;
    --q           :       out     std_logic_vector(16 downto 0)
  );
end entity MACs_with_memory;

architecture rtl of MACs_with_memory is
  signal         operand_a      :       std_logic_vector(16 downto 0);
  signal         operand_b      :       std_logic_vector(16 downto 0);
  signal            strobe      :       std_logic;
begin

  mac: entity work.MACs
    generic map(
      mult_bits   =>         16,
      sum_bits    =>         20
    )  
    port map(
      clk         =>    rd_clock,
      rst         =>         rst,
      strobe      =>      strobe,
      dataa       =>   operand_a,
      datab       =>   operand_b,    
      res         =>         res
    );

  operands_a: entity work.single_memory
    port map(
      data        =>     operand,
      rdaddress   =>   rdaddress,
      rdclock     =>    rd_clock,
      rdclocken   =>    mem_rden,
      wraddress   =>   wraddress,
      wrclock     =>    wr_clock,
      wrclocken   =>    mem_wren,
      wren        =>  mem_a_wren,
      q           =>   operand_a,
      rd_ready    =>        open
      );
  
  operands_b: entity work.single_memory
    port map(
      data        =>      operand,
      rdaddress   =>    rdaddress,
      rdclock     =>     rd_clock,
      rdclocken   =>     mem_rden,
      wraddress   =>    wraddress,
      wrclock     =>     wr_clock,
      wrclocken   =>     mem_wren,
      wren        =>   mem_b_wren,
      q           =>    operand_b,
      rd_ready    =>       strobe
    );
	 
end architecture rtl;
