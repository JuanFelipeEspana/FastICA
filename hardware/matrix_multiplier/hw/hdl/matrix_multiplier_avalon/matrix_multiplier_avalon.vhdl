library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity matrix_multiplier_avalon is
  generic(
    data_size           :       integer         :=     32;
    macs_size           :       integer         :=      7;
    memory_size         :       integer         :=     10
  );
  port(
    wr_clk              :       in                                              std_logic;
    rd_clk              :       in                                              std_logic;
    rst                 :       in                                              std_logic;
    address             :       in     std_logic_vector((macs_size+memory_size) downto 0);
    chipselect          :       in                                              std_logic;
    write_en            :       in                                              std_logic;
    writedata           :       in                 std_logic_vector(data_size-1 downto 0);
    readdata            :       out                std_logic_vector(data_size-1 downto 0)
  );
end entity matrix_multiplier_avalon;

architecture rtl of matrix_multiplier_avalon is
  constant ZEROS             :      std_logic_vector(data_size-1 downto 0)  := (others => '0');
  --AVALON
  signal wr_en               :                                                  std_logic;
  --CONFIGURATION REGISTERS
  signal wr_en_regs_config   :                              std_logic_vector(10 downto 0);
  signal matrix_a_rows       :                     std_logic_vector(macs_size-1 downto 0);
  signal matrix_b_cols       :                     std_logic_vector(macs_size-1 downto 0);
  signal matrix_dim_common   :                   std_logic_vector(memory_size-1 downto 0);
  signal results_total       :                       std_logic_vector(macs_size downto 0);
  signal max_exponent        :                               std_logic_vector(7 downto 0);
  signal shift_result        :                               std_logic_vector(7 downto 0);
  signal total_size          :         std_logic_vector((macs_size+memory_size) downto 0);
  signal clean_macs          :                                                  std_logic;
  signal load_a              :                                                  std_logic;
  --ADDITIONAL REGISTERS
  signal operand_reg         :                     std_logic_vector(data_size-1 downto 0);
  signal matrix_loaded_reg   :                                                  std_logic;
  signal data_ready          :                                                  std_logic;
  --DATA COUNTER
  signal data_counter_mask   :                               std_logic_vector(1 downto 0);
  signal data_counter        :         std_logic_vector((macs_size+memory_size) downto 0);
  signal data_ena            :                                                  std_logic;
  signal max_tick_loading    :                                                  std_logic;
  --RESULT COUNTER
  signal res_address         :                   std_logic_vector((macs_size)-1 downto 0);
  signal uploaded_delayed    :                                                  std_logic;
  --ADDITIONAL SIGNALS
  signal sync_clr_uploading  :                                                  std_logic;
  signal total_size_ext      :         std_logic_vector((macs_size+memory_size) downto 0);
  signal results_total_ext   :         std_logic_vector((macs_size+memory_size) downto 0);
  signal matrix_loaded       :                                                  std_logic;
  signal res                 :                     std_logic_vector(data_size-1 downto 0);
  --MEASURING TIMES
  signal measure_sync_clr    :                                                  std_logic;
  signal measure_ena         :                                                  std_logic;
  signal current_cycle       :                              std_logic_vector(15 downto 0);
  signal loading             :                              std_logic_vector(15 downto 0);
  signal reading             :                              std_logic_vector(15 downto 0);
begin

  --WRITE ENABLE WHEN PERIPHERIC AND WRITE HIGH
  wr_en <= write_en and chipselect;

  --SET MAX LIMIT OF DATA COUNTER TOTAL SIZE OF MATRIX
  total_size_ext    <= std_logic_vector(unsigned(total_size)-1);
  --ENABLE DATA COUNTER WHEN MASK AND COUNTER VALUE MATCHES ADDRESS
  data_counter_mask <= "00" when address((macs_size+memory_size) downto (macs_size+memory_size)-1)="01" else
                       "01" when address((macs_size+memory_size) downto (macs_size+memory_size)-1)="10" else
                       "11";
  data_ena <= '1' when (data_counter=(data_counter_mask & address((macs_size+memory_size)-2 downto 0)))and(wr_en='1')and(matrix_loaded_reg = '0') else
              '0';
  values_counter: entity work.univ_bin_counter
    generic map(
      N                 =>  (macs_size+memory_size)+1
    )
    port map(
      clk               =>                  wr_clk,
      rst               =>                     rst,
      ena               =>                data_ena,
      sync_clr          =>                     '0',
      load              =>                     '0',
      up                =>                     '1',
      data              =>         (others => '0'),
      limit             =>          total_size_ext,
      max_tick          =>        max_tick_loading,
      min_tick          =>                    open,
      counter           =>            data_counter
    );

  res_address <= address(macs_size-1 downto 0) when (address((macs_size+memory_size) downto (macs_size+memory_size)-1)="11") else
                 ZEROS(macs_size-1 downto 0);
  
  --WRITE ENABLE FOR CONFIGURATION REGISTERS
  wr_en_regs_config_for: for i in 0 to 10 generate
    wr_en_regs_config(i) <= '1' when ((address(3 downto 0)=std_logic_vector(to_unsigned(i, 4)))and(address((macs_size+memory_size) downto (macs_size+memory_size)-1)="00")) else
                            '0';
  end generate;
  --CONFIGURATION REGISTERS
  regs_config: process(wr_clk, rst, wr_en, wr_en_regs_config, data_ena, max_tick_loading)
    variable loaded   :    std_logic  := '0';
  begin
    if(rst = '1') then
      matrix_a_rows     <= (others => '0');
      matrix_b_cols     <= (others => '0');
      matrix_dim_common <= (others => '0');
      results_total     <= (others => '0');
      shift_result      <= (others => '0');
      max_exponent      <= (others => '0');
      total_size        <= (others => '0');
      clean_macs        <=             '0';
      load_a            <=             '1';
      operand_reg       <= (others => '0');
      matrix_loaded     <=             '0';
      matrix_loaded_reg <=             '0';
      measure_ena       <=             '0';
      measure_sync_clr  <=             '0';
      loading           <= (others => '0');
      reading           <= (others => '0');
      uploaded_delayed  <=             '0';
    elsif(rising_edge(wr_clk)) then
      uploaded_delayed   <= clean_macs;
      loaded := max_tick_loading and data_ena;
      matrix_loaded <= loaded;
      
      if(data_ena='1') then
        operand_reg   <= writedata(data_size-1 downto 0);
      end if;
      if(loaded='1') then
        matrix_loaded_reg <= '1';
      end if;

      if(wr_en_regs_config(0)='1') then
        if(wr_en = '1') then
          matrix_a_rows <= writedata(macs_size-1 downto 0);
        end if;
      end if;
      if(wr_en_regs_config(1)='1') then
        if(wr_en = '1') then
          matrix_b_cols <= writedata(macs_size-1 downto 0);
        end if;
      end if;
      if(wr_en_regs_config(2)='1') then
        if(wr_en = '1') then
          matrix_dim_common <= writedata(memory_size-1 downto 0);
        end if;
      end if;
      if(wr_en_regs_config(3)='1') then
        if(wr_en = '1') then
          results_total <= writedata(macs_size downto 0);
        end if;
      end if;
      if(wr_en_regs_config(4)='1') then
        if(wr_en = '1') then
          shift_result <= writedata(7 downto 0);
        end if;
      end if;
      if(wr_en_regs_config(5)='1') then
        if(wr_en = '1') then
          max_exponent <= writedata(7 downto 0); 
        end if;
      end if;
      if(wr_en_regs_config(6)='1') then
        if(wr_en = '1') then
          total_size <= writedata((macs_size+memory_size) downto 0);
          matrix_loaded_reg <= '0';
        end if;
      end if;

      if(wr_en_regs_config(8)='1') then
        if(wr_en = '1') then
          if(sync_clr_uploading = '0') then
            clean_macs <= '1';
            reading <= current_cycle; 
          else
            clean_macs <= '0';
          end if;
        end if;
      end if;

      if(wr_en_regs_config(9)='1') then
        if(wr_en = '1') then
          load_a <= writedata(0);
        end if;
      end if;

      if(data_ena='1') then
        measure_ena <= '1';
        measure_sync_clr <= '0';
      end if;
      if(uploaded_delayed='1') then
        measure_ena <= '0';
        measure_sync_clr <= '1';
      end if;
      if(max_tick_loading='1') then
        loading <= current_cycle;
      end if;
    end if;
  end process;
  readdata <= res when (address((macs_size+memory_size) downto (macs_size+memory_size)-1)="11") else
              ZEROS((data_size-macs_size)-1 downto 0) & matrix_a_rows when (wr_en_regs_config(0))='1' else
              ZEROS((data_size-macs_size)-1 downto 0) & matrix_b_cols when (wr_en_regs_config(1))='1' else
              ZEROS((data_size-memory_size)-1 downto 0) & matrix_dim_common when (wr_en_regs_config(2))='1' else
              ZEROS((data_size-macs_size)-2 downto 0) & results_total when (wr_en_regs_config(3))='1' else
              ZEROS((data_size-8)-1 downto 0) & shift_result when (wr_en_regs_config(4))='1' else
              ZEROS((data_size-8)-1 downto 0) & max_exponent when (wr_en_regs_config(5))='1' else
              ZEROS((data_size-(macs_size+memory_size))-2 downto 0) & total_size when (wr_en_regs_config(6))='1' else
              ZEROS((data_size-1)-1 downto 0) & data_ready when (wr_en_regs_config(7))='1' else
              ZEROS((data_size-16)-1 downto 0) & loading when (wr_en_regs_config(8))='1' else
              ZEROS((data_size-16)-1 downto 0) & reading when (wr_en_regs_config(9))='1' else
              ZEROS;

  --MATRIX MULTIPLIER FLOAT UNIT
  matrix_multiplier_unit: entity work.matrix_multiplier_float
  generic map(
    macs_total        =>                        2**(macs_size),
    macs_size         =>                             macs_size,
    memory_size       =>                           memory_size,
    mult_bits         =>                         (data_size/2),
    sum_bits          =>                                    43
  )
  port map(
    wr_clk            =>                                wr_clk,
    rd_clk            =>                                rd_clk,
    rst               =>                                   rst,
    new_value         =>                              data_ena,
    load_a            =>                                load_a,
    matrix_a_rows     =>                         matrix_a_rows,
    matrix_b_cols     =>                         matrix_b_cols,
    matrix_dim_common =>                     matrix_dim_common,
    results_total     =>                         results_total,
    matrix_loaded     =>                         matrix_loaded,
    matrix_uploaded   =>                      uploaded_delayed,
    operand           =>                           operand_reg,
    max_exponent      =>                          max_exponent,
    res_address       =>                           res_address,
    shift_result      =>                          shift_result,
    res               =>                                   res,
    sync_clr_uploading=>                    sync_clr_uploading,
    data_ready        =>                            data_ready
  );
  
  --COUNTER FOR MEASURING TIME
  times_counter: entity work.univ_bin_counter
    generic map(
      N                 =>                      16
    )
    port map(
      clk               =>                  wr_clk,
      rst               =>                     rst,
      ena               =>             measure_ena,
      sync_clr          =>        measure_sync_clr,
      load              =>                     '0',
      up                =>                     '1',
      data              =>         (others => '0'),
      limit             =>                 x"FFFF",
      max_tick          =>                    open,
      min_tick          =>                    open,
      counter           =>           current_cycle
    );

end architecture rtl;
