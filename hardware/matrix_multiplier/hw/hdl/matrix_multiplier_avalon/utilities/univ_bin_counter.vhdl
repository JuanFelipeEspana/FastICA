library ieee;

use ieee.std_logic_1164.all;
use    ieee.numeric_std.all;

entity univ_bin_counter is
   generic(
      N            :         integer       := 4
   );   
   port(
      clk          :     in                            std_logic;
      rst          :     in                            std_logic;
      ena          :     in                            std_logic;
      sync_clr     :     in                            std_logic;
      load         :     in                            std_logic;
      up           :     in                            std_logic;
      data         :     in       std_logic_vector(N-1 downto 0);
      limit        :     in       std_logic_vector(N-1 downto 0);
      max_tick     :     out                           std_logic;
      min_tick     :     out                           std_logic;
      counter      :     out      std_logic_vector(N-1 downto 0)
   );
end entity univ_bin_counter;

architecture univ_bin_counter_arch of univ_bin_counter is
   constant   ONES       :   unsigned(N-1 downto 0) := (others => '1');
   constant   ZEROS      :   unsigned(N-1 downto 0) := (others => '0');

   --COUNTERS
   signal   count_s      :   unsigned(N-1 downto 0) := (others => '0');
   signal   count_next   :                      unsigned(N-1 downto 0);
BEGIN

	--NEXT VALUE OF COUNTER
	count_next <= (others => '0') when ((sync_clr = '1') or (count_s = unsigned(limit)))      else
                 unsigned(data)  when (load = '1')                                           else
                 (others => '1') when (ena = '1' and up = '1' and count_s > unsigned(limit)) else
                 count_s + 1     when (ena = '1' and up = '1' and count_s < unsigned(limit)) else
                 count_s - 1     when (ena = '1' and up = '0' )                              else
                 count_s;
	
	--UPDATE CURRENT COUNTER VALUE
   	process(clk,rst)
    	variable   temp   :   unsigned(N-1 downto 0);
   	begin
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
      	counter <= std_logic_vector(temp);
      	count_s <= temp;
	end process;
   
   --OUTPUT LOGIC
   max_tick <= '1' when count_s = unsigned(limit)  else '0';
   min_tick <= '1' when count_s = ZEROS else '0';
	
end architecture univ_bin_counter_arch;
