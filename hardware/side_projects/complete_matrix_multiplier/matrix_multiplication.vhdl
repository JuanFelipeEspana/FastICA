library ieee;
library dsp;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_matrix.all;

entity matrix_multiplication is
  generic(
    custom_multipliers          :          integer     :=       30
  );
  port(
    clk         :       in      std_logic;
    rst         :       in      std_logic;
    go          :       in      std_logic;
    wr_en       :       in      std_logic;
    address     :       in      std_logic_vector(15 downto 0);
    data        :       in      std_logic_vector(24 downto 0);
    size_m      :       in      std_logic_vector(6 downto 0);
    ready       :       out     std_logic;
    result      :       out     std_logic_vector(24 downto 0)
  );
end entity matrix_multiplication;

architecture rtl of matrix_multiplication is
  type   modes   is  (idle, calculating, uploading_res);
  signal pr_state        :      modes;
  signal nx_state        :      modes;
  signal get_values_a    :      read_memories(0 to 127);
  signal get_values_b    :      read_memories(0 to 127);
  signal get_res         :      read_memories(0 to 127);
  signal complete_res    :      read_dsp(0 to 127);
  signal real_address    :      std_logic_vector(13 downto 0);
  signal data_ready_a    :      std_logic;
  signal data_ready_b    :      std_logic;
  signal data_ready_res  :      std_logic;
  signal in_result       :      std_logic_vector(24 downto 0);
  signal wr_en_op        :      std_logic_vector(1 downto 0);
  signal wr_en_res       :      std_logic;
  signal min_tick_counter:      std_logic;
  signal count_address   :      std_logic_vector(6 downto 0);
  signal ena_calculating :      std_logic;
  signal ena_upload_res  :      std_logic;
  signal ena_counter     :      std_logic;
  signal clear_dsp       :      std_logic;
begin
  --------------------FSM---------------------
  nx_state_logic: process(rst, clk)
  begin
    if(rst='1') then
      pr_state <= idle;
    elsif(rising_edge(clk)) then
      pr_state <= nx_state;
    end if;
  end process;
  
  control_fsm: process(go, min_tick_counter, pr_state)
  begin
    case pr_state is
      when idle =>
        if(go = '1') then
          nx_state <=   calculating;
          ena_calculating <=    '1';
          ena_upload_res  <=    '0';
          clear_dsp       <=    '0';
        else
          nx_state <=          idle;
          ena_calculating <=    '0';
          ena_upload_res  <=    '0';
          clear_dsp       <=    '1';
        end if;
      when calculating =>
        if(min_tick_counter='1') then
          nx_state <= uploading_res;
          ena_calculating <=    '0';
          ena_upload_res  <=    '1';
          clear_dsp       <=    '0';
        else
          nx_state <=   calculating;
          ena_calculating <=    '1';
          ena_upload_res  <=    '0';
          clear_dsp       <=    '0';
        end if;
      when uploading_res =>
        if(min_tick_counter='1') then
          nx_state        <=   idle;
          ena_calculating <=    '0';
          ena_upload_res  <=    '0';
          clear_dsp       <=    '1';
        else
          nx_state <= uploading_res;
          ena_calculating <=    '0';
          ena_upload_res  <=    '1';
          clear_dsp       <=    '0';
        end if;
    end case;
  end process;
  
  -------------------MEMORY-------------------
  real_address <= address(13 downto 0) when ((ena_calculating)and(ena_upload_res))='0' else
                  "0000000" & count_address;
  
  wr_en_op(0)<= (not(address(15))) and (not(address(14))) and (wr_en);
  wr_en_op(1)<= (not(address(15))) and (address(14)) and (wr_en);
  
  memory_a_values: entity work.memory_blocks
    port map(
      clk       =>               clk,
      rst       =>               rst,
      ena       =>   ena_calculating,   
      wr_en     =>       wr_en_op(0),
      address   =>      real_address,
      data      =>              data,
      q         =>      get_values_a,
      data_usable =>    data_ready_a
    );
  
  memory_b_values: entity work.memory_blocks
    port map(
      clk       =>               clk,
      rst       =>               rst,
      ena       =>   ena_calculating,            
      wr_en     =>       wr_en_op(1),
      address   =>      real_address,
      data      =>              data,
      q         =>      get_values_b,
      data_usable =>    data_ready_b
    );

  in_result     <= get_res(to_integer(unsigned(real_address(6 downto 0))));
  wr_en_res     <=                              ena_upload_res;
  memory_result_values: entity work.single_memory_block
    port map(
      clk       =>               clk,
      rst       =>               rst,
      ena       =>    ena_upload_res,
      wr_en     =>         wr_en_res,
      address   => real_address(6 downto 0),
      data      =>         in_result,
      q         =>            result,
      data_usable =>  data_ready_res
    );
      
  ----------------SIZE COUNTER----------------
  ena_counter   <=   data_ready_a    when ena_calculating = '1' else
                     data_ready_res  when ena_upload_res  = '1' else
                     '0';
  counter_coeff: entity work.univ_bin_counter
    generic map(
      N         =>      7
    )
    port map(
      clk       =>                  clk,
      rst       =>                  rst,
      ena       =>          ena_counter,
      sync_clr  =>                  '0',
      load      =>                  '0',
      up        =>                  '1',
      data      =>      (others => '0'),
      limit     =>               size_m,
      max_tick  =>                 open,
      min_tick  =>     min_tick_counter,
      counter   =>        count_address
    );

  ----------------MULTIPLIERS----------------
  multipliers: for i in 0 to (custom_multipliers-1) generate
    single_multiplier: entity work.matrix_multiplication_be_vedic
      port map(
        clk     =>                  clk,
        rst     =>                  rst,
        sync_clr=>            clear_dsp,
        ena     =>       data_ready_res,
        row     =>      get_values_a(i),
        col     =>      get_values_b(i),
        acc     =>           get_res(i)
      );
  end generate;

  -------------------DSPs-------------------
  dsp_array: for i in (custom_multipliers) to (custom_multipliers+87)-1 generate
    single_dsp: entity dsp.dsp
      port map(
        result          => complete_res(i),
        dataa_0         => get_values_a(i),
        datab_0         => get_values_b(i),
        clock0          =>             clk,
        ena0            =>  data_ready_res,
        sclr0           =>       clear_dsp
      );
    get_res(i)          <= complete_res(i)(48 downto 24);
  end generate;
end architecture rtl;
