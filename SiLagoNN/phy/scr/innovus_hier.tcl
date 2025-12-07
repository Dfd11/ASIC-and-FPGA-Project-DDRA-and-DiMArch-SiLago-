file mkdir ../phy/db
file mkdir ../phy/db/part
file mkdir ../phy/rpt

#Reading the design
puts "INFO_DFD:Doing Read Design"
source ../phy/scr/read_design_hier.tcl
#Floorplan
puts "INFO_DFD:Doing Floorplan"
source ../phy/scr/floorplan_constrained.tcl
#Power planning, I did it manually in the tutorial, you can create your power_planning.tcl script by noting the commands appearing in the terminal based on gui actions.
puts "INFO_DFD:Doing Power Planning"
source ../phy/scr/power_planning.tcl
#Place
puts "INFO_DFD:Doing Parition Creation"
source ../phy/scr/partition.tcl

puts "INFO_DFD:Doing Place and Route Parition "
source ../phy/scr/pnr_partition.sh

puts "INFO_DFD:Doing Place and Route Top"
#CTS
source ../phy/scr/pnr_top.tcl
puts "INFO_DFD:Doing Assembly Design"
source ../phy/scr/assembly_design.tcl

puts "INFO_DFD:Doing Writting Design"
write_db ../phy/db/drra_wrapper.dat
write_netlist ../phy/db/drra_wrapper.v
report_power
