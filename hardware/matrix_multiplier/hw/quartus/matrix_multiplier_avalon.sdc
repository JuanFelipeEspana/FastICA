set_time_format -unit ns -decimal_places 3
create_clock -name {wr_clk} -period 10.000 -waveform { 0.000 5.000 } [get_ports {wr_clk}]
create_clock -name {rd_clk} -period 10.000 -waveform { 0.000 5.000 } [get_ports {rd_clk}]