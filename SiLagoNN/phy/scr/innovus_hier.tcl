#Reading the design
puts "INFO_DFD:Doing Read Design"
source ../phy/scr/read_design_hier.tcl
#Floorplan
puts "INFO_DFD:Doing Floorplan"
source ../phy/scr/floorplan.tcl
#Power planning, I did it manually in the tutorial, you can create your power_planning.tcl script by noting the commands appearing in the terminal based on gui actions.
source ../phy/scr/power_planning.tcl
#Place
puts "INFO_DFD:Doing Place Design"
place_design
puts "INFO_DFD:Doing Place Design"
assign_io_pins
#CTS
ccopt_design
#Route design
assign_io_pins
route_design
write_db ../phy/db/parallel_fir.dat
write_netlist ../phy/db/parallel_fir.v
report_power
