LIBRARY IEEE;
USE ieee.std_logic_1164.all;
---------------------------------------------------
ENTITY avalon_timer IS
  PORT (
    clk			:	IN	STD_LOGIC;
    reset		:	IN  	STD_LOGIC;
    count_address	:	IN  	STD_LOGIC_VECTOR(5 DOWNTO 0);
    count_chipselect 	:       IN 	STD_LOGIC;
    count_write		:	IN 	STD_LOGIC;
    count_writedata     :	IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
    count_readdata	:	OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
    enabled 		: 	out 	std_logic_vector(1 downto 0)
  );
END ENTITY avalon_timer;
------------------------------------------------------------
ARCHITECTURE	avalonMMslave	OF	avalon_timer IS
  constant      partial_zeros 	: 	std_logic_vector(31 downto 4) := (others => '0');
  constant      zeros		:	std_logic_vector(31 downto 1) := (others => '0');
  constant      full_zeros      :       std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL	sync_clr_reg	:	STD_LOGIC;
  signal        ena_reg         :       std_logic;
  signal 	done_tick_reg	:	std_logic;
  signal        set_done_tick	:	std_logic;
  signal        clr_done_tick	:	std_logic;
  signal        wr_en           :       std_logic;
  SIGNAL	wr_finish	:	STD_LOGIC;
  SIGNAL 	wr_sync_clr	:	STD_LOGIC;
  SIGNAL 	snapshot	:	STD_LOGIC_VECTOR(31 downto 0);
  signal        min_tick        :       STD_LOGIC;
  SIGNAL	wr_0		:	STD_LOGIC;
  SIGNAL	wr_1		:	STD_LOGIC;
  SIGNAL	wr_2		:	STD_LOGIC;
  SIGNAL	wr_3		:	STD_LOGIC;
  SIGNAL	wr_4		:	STD_LOGIC;
  SIGNAL	wr_5		:	STD_LOGIC;
  SIGNAL	wr_6		:	STD_LOGIC;
  SIGNAL	wr_7		:	STD_LOGIC;
  SIGNAL	wr_8		:	STD_LOGIC;
  SIGNAL	wr_9		:	STD_LOGIC;
  SIGNAL	wr_a		:	STD_LOGIC;
  SIGNAL	wr_b		:	STD_LOGIC;
  SIGNAL	wr_c		:	STD_LOGIC;
  SIGNAL	wr_d		:	STD_LOGIC;
  SIGNAL	wr_e		:	STD_LOGIC;
  SIGNAL	wr_f		:	STD_LOGIC;
  signal 	reg_0		:	std_logic_vector(31 downto 0);
  signal 	reg_1		:	std_logic_vector(31 downto 0);
  signal 	reg_2		:	std_logic_vector(31 downto 0);
  signal 	reg_3		:	std_logic_vector(31 downto 0);
  signal 	reg_4		:	std_logic_vector(31 downto 0);
  signal 	reg_5		:	std_logic_vector(31 downto 0);
  signal 	reg_6		:	std_logic_vector(31 downto 0);
  signal 	reg_7		:	std_logic_vector(31 downto 0);
  signal 	reg_8		:	std_logic_vector(31 downto 0);
  signal 	reg_9		:	std_logic_vector(31 downto 0);
  signal 	reg_a		:	std_logic_vector(31 downto 0);
  signal 	reg_b		:	std_logic_vector(31 downto 0);
  signal 	reg_c		:	std_logic_vector(31 downto 0);
  signal 	reg_d		:	std_logic_vector(31 downto 0);
  signal 	reg_e		:	std_logic_vector(31 downto 0);
  signal 	reg_f		:	std_logic_vector(31 downto 0);
BEGIN
  clk_counter: entity work.univ_bin_counter
    generic map(
      N         =>             32
    )
    port map(
      clk       =>             clk,
      rst       =>           reset,
      ena       =>         ena_reg,
      sync_clr  =>    sync_clr_reg,
      load      =>             '0',
      up        =>             '1',
      data      =>      full_zeros,
      limit     =>     x"FFFFFFFF",
      max_tick  =>   set_done_tick,
      min_tick  =>        min_tick,
      counter   =>        snapshot
    );
--------------------------------------------------------
  PROCESS(clk, reset)
  BEGIN
    IF (reset = '1') THEN
      ena_reg      <= '0';
      sync_clr_reg <= '1';
      done_tick_reg <= '0';
    ELSIF(rising_edge(clk)) THEN
      IF(wr_finish = '1') THEN
        ena_reg <= '0';
        sync_clr_reg <= '0';
      END IF;
      IF (wr_sync_clr = '1') THEN
        sync_clr_reg <= count_writedata(0);
        ena_reg <= '0';
      END IF;
      if (wr_0 = '1') then
      	ena_reg <= '1';
			sync_clr_reg <= '0';
      	reg_0 <= count_writedata;
      end if;
      if (wr_1 = '1') then
      	reg_1 <= count_writedata;
      end if;
      if (wr_2 = '1') then
      	reg_2 <= count_writedata;
      end if;
      if (wr_3 = '1') then
      	reg_3 <= count_writedata;
      end if;
      if (wr_4 = '1') then
      	reg_4 <= count_writedata;
      end if;
      if (wr_5 = '1') then
      	reg_5 <= count_writedata;
      end if;
      if (wr_6 = '1') then
      	reg_6 <= count_writedata;
      end if;
      if (wr_7 = '1') then
      	reg_7 <= count_writedata;
      end if;
      if (wr_8 = '1') then
      	reg_8 <= count_writedata;
      end if;
      if (wr_9 = '1') then
      	reg_9 <= count_writedata;
      end if;
      if (wr_a = '1') then
      	reg_a <= count_writedata;
      end if;
      if (wr_b = '1') then
      	reg_b <= count_writedata;
      end if;
      if (wr_c = '1') then
      	reg_c <= count_writedata;
      end if;
      if (wr_d = '1') then
      	reg_d <= count_writedata;
      end if;
      if (wr_e = '1') then
      	reg_e <= count_writedata;
      end if;
      if (wr_f = '1') then
      	reg_f <= count_writedata;
      end if;
      IF (set_done_tick = '1') THEN
        done_tick_reg <= '1';
        ena_reg       <= '0';
        sync_clr_reg  <= '0';
      ELSIF (clr_done_tick = '1') THEN
        done_tick_reg <= '0';
        ena_reg       <= '0';
        sync_clr_reg  <= '1';
      END IF;
    END IF;
  END PROCESS;

  wr_en		<= '1' WHEN (count_write='1' AND count_chipselect='1') ELSE '0';
  wr_0		<= '1' when (count_address="000000" and wr_en = '1') else '0';
  wr_1		<= '1' when (count_address="000001" and wr_en = '1') else '0';
  wr_2		<= '1' when (count_address="000010" and wr_en = '1') else '0';
  wr_3		<= '1' when (count_address="000011" and wr_en = '1') else '0';
  wr_4		<= '1' when (count_address="000100" and wr_en = '1') else '0';
  wr_5		<= '1' when (count_address="000101" and wr_en = '1') else '0';
  wr_6		<= '1' when (count_address="000110" and wr_en = '1') else '0';
  wr_7		<= '1' when (count_address="000111" and wr_en = '1') else '0';
  wr_8		<= '1' when (count_address="001000" and wr_en = '1') else '0';
  wr_9		<= '1' when (count_address="001001" and wr_en = '1') else '0';
  wr_a		<= '1' when (count_address="001010" and wr_en = '1') else '0';
  wr_b		<= '1' when (count_address="001011" and wr_en = '1') else '0';
  wr_c		<= '1' when (count_address="001100" and wr_en = '1') else '0';
  wr_d		<= '1' when (count_address="001101" and wr_en = '1') else '0';
  wr_e		<= '1' when (count_address="001110" and wr_en = '1') else '0';
  wr_f		<= '1' when (count_address="001111" and wr_en = '1') else '0';
  wr_finish      <= '1' when (count_address="010000" and wr_en = '1') else '0'; 
  wr_sync_clr	<= '1' WHEN (count_address="010001" AND wr_en = '1') ELSE '0';
  clr_done_tick	<= '1' WHEN (count_address="010010" AND wr_en = '1') ELSE '0';
  
  count_readdata     <=  reg_0	when count_address="010011" else
								 reg_1	when count_address="010100" else
								 reg_2	when count_address="010101" else
								 reg_3	when count_address="010110" else
								 reg_4	when count_address="010111" else
								 reg_5	when count_address="011000" else
								 reg_6	when count_address="011001" else
								 reg_7	when count_address="011010" else
								 reg_8	when count_address="011011" else
								 reg_9	when count_address="011100" else
								 reg_a	when count_address="011101" else
								 reg_b  when count_address="011110" else
								 reg_c	when count_address="011111" else
								 reg_d	when count_address="100000" else
								 reg_e	when count_address="100001" else
								 reg_f	when count_address="100010" else
								 snapshot WHEN count_address="100011" ELSE
								 ZEROS & ena_reg when count_address="100100" else
								 full_zeros;
	enabled <= sync_clr_reg & ena_reg;
END ARCHITECTURE;


