library ieee;

use ieee.std_logic_1164.all;
use    ieee.numeric_std.all;
use   work.type_results.all;

entity mac_array is
  generic(
    macs_total          :       integer         :=    128;
    macs_bits           :       integer         :=      7;
    memory_size         :       integer         :=      9;
    mult_bits           :       integer         :=     16;
    sum_bits            :       integer         :=     32
  );
  port(
    wr_clock            :       in                                  std_logic;
    rd_clock            :       in                                  std_logic;
    rst                 :       in                                  std_logic;
    sync_clr_macs       :       in                                  std_logic;
    macs_ena            :       in    std_logic_vector(macs_total-1 downto 0);
    operand             :       in       std_logic_vector(mult_bits downto 0);
    strobe              :       in                                  std_logic;
    rdaddress           :       in   std_logic_vector(memory_size-1 downto 0);
    wraddress           :       in   std_logic_vector(memory_size-1 downto 0);
    mem_wren            :       in    std_logic_vector(macs_total-1 downto 0);
    mem_rden            :       in                                  std_logic;
    mem_a_wren          :       in                                  std_logic;
    mem_b_wren          :       in                                  std_logic;
    res                 :       out       macs_results(macs_total-1 downto 0)
  );
end entity mac_array;

architecture rtl of mac_array is
  signal macs_res       :       macs_results(macs_total-1 downto 0);
begin

  --ARRAY OF MACS FOR MULTIPLYING MATRICES
  array_macs: for i in 0 to macs_total-1 generate
    each_mac: entity work.mac_with_memory
      generic map(
        memory_size     =>                 memory_size,
        mult_bits       =>                   mult_bits,
        sum_bits        =>                    sum_bits
      )
      port map(
        wr_clock        =>                    wr_clock,
        rd_clock        =>                    rd_clock,
        rst             =>                         rst,
        sync_clr_mac    =>               sync_clr_macs,
        ena             =>  macs_ena((macs_total)-i-1),
        strobe          =>                      strobe,
        operand         =>                     operand,
        rdaddress       =>                   rdaddress,
        wraddress       =>                   wraddress,
        mem_wren        =>  mem_wren((macs_total)-i-1),
        mem_rden        =>                    mem_rden,
        mem_a_wren      =>                  mem_a_wren,
        mem_b_wren      =>                  mem_b_wren,
        res             =>                      res(i)
      );
  end generate;

end architecture rtl;

