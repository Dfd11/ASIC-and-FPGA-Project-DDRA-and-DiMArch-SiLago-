#This is a testing clock constraint, we want to reduce the period to make it faster but its a good starting point 
create_clock -name "clk" -period 80 -waveform {0 40} [get_ports clk]
#create_clock -name "clk" -period 20 -waveform {0 10} [get_ports clk]
set_false_path -from [get_port rst_n]
set_clock_uncertainty 0.2 [get_clock clk]
