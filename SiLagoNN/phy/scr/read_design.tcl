#1. source global variables
source ../phy/scr/global_variables.tcl
puts "INFO_DFD:Done with Global Variables"
#2. source design variables
set_multi_cpu_usage -local_cpu ${NUM_CPUS} -cpu_per_remote_host 1 -remote_host 0 -keep_license true
set_distributed_hosts -local
puts "INFO_DFD:Done with Local Variables"
#3. set vdd net
set_db init_power_nets {VDD}
#4. set vss net
set_db init_ground_nets {VSS}
#5. read mmmc file
puts "INFO_DFD:Reading MMC File"
read_mmmc ${MMMC_FILE}
#6. read lef 
puts "INFO_DFD:Reading LEF File"
read_physical -lef ${LEF_FILE}
#7. read logic synthesis netlist
puts "INFO_DFD:Reading Netlist File"
read_netlist ${NETLIST_FILE}

init_design
