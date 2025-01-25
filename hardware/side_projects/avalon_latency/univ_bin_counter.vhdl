LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

LIBRARY ALTERA;
USE ALTERA.altera_primitives_components.all;
-------------------------------------------------------------------
ENTITY univ_bin_counter IS
	GENERIC	(	N			:	INTEGER	:=	4);
	PORT	(	clk		:	IN	STD_LOGIC;
			rst		:	IN	STD_LOGIC;
			ena		:	IN	STD_LOGIC;
			sync_clr	:	IN	STD_LOGIC;
			load		:	IN	STD_LOGIC;
			up		:	IN	STD_LOGIC;
			data		:	IN	STD_LOGIC_VECTOR(N-1 downto 0);
			limit		:	IN	STD_LOGIC_VECTOR(N-1 downto 0);
			max_tick	:	OUT	STD_LOGIC;
			min_tick	:	OUT	STD_LOGIC;
			counter	        :	OUT	STD_LOGIC_VECTOR(N-1 downto 0));
END ENTITY;
-------------------------------------------------------------------
ARCHITECTURE univ_bin_counter_arch OF univ_bin_counter IS
	CONSTANT	ONES	:	UNSIGNED(N-1 downto 0) := (others => '1');
	CONSTANT	ZEROS	:	UNSIGNED(N-1 downto 0) := (others => '0');
	SIGNAL	count_s		:	UNSIGNED(N-1 downto 0) := (others => '0');
	SIGNAL	count_next	:	UNSIGNED(N-1 downto 0);
	
-------------------------------------------------------------------
BEGIN

count_next<= (others => '0') when ((sync_clr = '1') or (count_s = unsigned(limit))) else
	     unsigned(data)  when (load = '1') else
	     (others => '1') when (ena = '1' and up = '1' and count_s > unsigned(limit)) else
	     count_s + 1 when (ena = '1' and up = '1' and count_s < unsigned(limit)) else
	     count_s - 1 when (ena = '1' and up = '0' )	else
	     count_s;
						
	PROCESS(clk,rst)
		VARIABLE	temp	:	UNSIGNED(N-1 downto 0);
	BEGIN
		if (rst = '1') then
			temp := (others => '0');
		elsif (rising_edge(clk)) then
			if(ena = '1') then
				temp := count_next;
			end if;
			if(sync_clr = '1') then
				temp := (others => '0');
			end if;
		end if;
		counter <= STD_LOGIC_VECTOR(temp);
		count_s <= temp;
	END PROCESS;
	
	--OUTPUT LOGIC
	max_tick <= '1' when count_s = unsigned(limit)  else '0';
	min_tick <= '1' when count_s = ZEROS else '0';
END ARCHITECTURE univ_bin_counter_arch;
