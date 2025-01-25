library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mac_array_controller_fsm is
  port(
    wr_clk              :       in      std_logic;
    rd_clk              :       in      std_logic;
    rst                 :       in      std_logic;
    new_value           :       in      std_logic;
    max_tick_loading    :       in      std_logic;
    max_tick_calculate  :       in      std_logic;
    max_tick_uploading  :       in      std_logic;
    sync_clr_shifter    :       out     std_logic;
    sync_clr_operating  :       out     std_logic;
    sync_clr_uploading  :       out     std_logic;
    sync_clr_macs       :       out     std_logic;
    ena_shifter         :       out     std_logic;
    ena_operating       :       out     std_logic;
    mem_a_wren          :       out     std_logic;
    mem_b_wren          :       out     std_logic;
    change_decoding     :       out     std_logic;
    rows                :       out     std_logic;
    data_ready          :       out     std_logic
  );
end entity mac_array_controller_fsm;

architecture rtl of mac_array_controller_fsm is
  type state is             (idle, load_a, config_b, operate, wait_seg, upload); --(idle, load_a, start_reading, b_decoder, operate, wait_seg, upload);
  signal pr_state               :                              state;
  signal nx_state               :                              state;
  signal max_tick_counters      :       std_logic_vector(2 downto 0);
  signal sync_clr_counters      :       std_logic_vector(2 downto 0);
  signal ena_counters           :       std_logic_vector(1 downto 0);
  signal mem_wren               :       std_logic_vector(1 downto 0);
begin
  
  max_tick_counters <= max_tick_loading & max_tick_calculate & max_tick_uploading;
  
  --UPDATE STATE
  regs_for_states: process(wr_clk, rd_clk, rst)
  begin
    if(rst='1') then
      pr_state <= idle;
    elsif(rising_edge(rd_clk)) then
      pr_state <= nx_state;
    end if;
  end process;

  --FSM DEFINITION
  fsm: process(pr_state, max_tick_counters, new_value)
  begin
    case pr_state is
      when idle =>
        if(new_value='1') then
          sync_clr_counters     <=   "111";
          sync_clr_macs         <=     '1';
          ena_counters          <=    "00";
          mem_wren              <=    "10";
          change_decoding       <=     '1';
          rows                  <=     '1';
          data_ready            <=     '0';
          nx_state              <=  load_a;
        else
          sync_clr_counters     <=   "111";
          sync_clr_macs         <=     '1';
          ena_counters          <=    "00";
          mem_wren              <=    "00";
          change_decoding       <=     '0';
          rows                  <=     '0';
          data_ready            <=     '0';
          nx_state              <=    idle;
        end if;
      when load_a =>
        if(max_tick_counters(2)='1') then
          sync_clr_counters     <=    "011";
          sync_clr_macs         <=      '1';
          ena_counters          <=     "00";
          mem_wren              <=     "10";
          change_decoding       <=      '0';
          rows                  <=      '1';
          data_ready            <=      '0';
          nx_state              <= config_b;
        else
          sync_clr_counters     <=    "011";
          sync_clr_macs         <=      '1';
          ena_counters          <=     "10";
          mem_wren              <=     "10";
          change_decoding       <=      '0';
          rows                  <=      '1';
          data_ready            <=      '0';
          nx_state              <=   load_a;
        end if;
      when config_b =>
        if(new_value = '1') then
          sync_clr_counters       <=    "001";
          sync_clr_macs           <=      '0';
          ena_counters            <=     "00";
          mem_wren                <=     "00";
          change_decoding         <=      '0';
          rows                    <=      '0';
          data_ready              <=      '0';
          nx_state                <=  operate;
        else
          sync_clr_counters       <=    "001";
          sync_clr_macs           <=      '0';
          ena_counters            <=     "00";
          mem_wren                <=     "00";
          change_decoding         <=      '1';
          rows                    <=      '0';
          data_ready              <=      '0';
          nx_state                <= config_b;
        end if;
      when operate =>
        if(max_tick_counters(2)='1') then
          sync_clr_counters     <=    "001";
          sync_clr_macs         <=      '0';
          ena_counters          <=     "11";
          mem_wren              <=     "01";
          change_decoding       <=      '0';
          rows                  <=      '0';
          data_ready            <=      '0';
          nx_state              <= wait_seg;
        else
          sync_clr_counters     <=    "001";
          sync_clr_macs         <=      '0';
          ena_counters          <=     "11";
          mem_wren              <=     "01";
          change_decoding       <=      '0';
          rows                  <=      '0';
          data_ready            <=      '0';
          nx_state              <=  operate;
        end if;
      when wait_seg =>
        sync_clr_counters     <=   "001";
        sync_clr_macs         <=     '0';
        ena_counters          <=    "11";
        mem_wren              <=    "01";
        change_decoding       <=     '0';
        rows                  <=     '0';
        data_ready            <=     '0';
        nx_state              <=  upload;
      when upload =>
        if(max_tick_counters(0)='1') then
          sync_clr_counters     <=   "111";
          sync_clr_macs         <=     '0';
          ena_counters          <=    "00";
          mem_wren              <=    "00";
          change_decoding       <=     '0';
          rows                  <=     '1';
          data_ready            <=     '0';
          nx_state              <=    idle;
        else
          sync_clr_counters     <=   "110";
          sync_clr_macs         <=     '0';
          ena_counters          <=    "00";
          mem_wren              <=    "00";
          change_decoding       <=     '0';
          rows                  <=     '1';
          data_ready            <=     '1';
          nx_state              <=  upload;
        end if;
    end case;
  end process;
  --SYNCRONOUS CLEARS FOR EVERY COUNTER
  sync_clr_shifter   <= sync_clr_counters(2);
  sync_clr_operating <= sync_clr_counters(1);
  sync_clr_uploading <= sync_clr_counters(0);

  --ENABLE FOR COUNTERS
  ena_shifter        <= (ena_counters(1) and new_value) or max_tick_loading;
  ena_operating      <=                                     ena_counters(0);

  --ENABLE FOR MEMORIES
  mem_a_wren         <=          mem_wren(1);
  mem_b_wren         <=          mem_wren(0);
    
end architecture rtl;
