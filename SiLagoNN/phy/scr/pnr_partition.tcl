#1. cd into the specific partition
#3. read the parition
#4. place
#5. ccopt
#6. route
#7. write the partition db
#8. write ilm
#cd into the specific partition directory e.g. 

#source ../../../../phy/scr/global_variables_hier.tcl
puts "INFO_DFD: Reading Data Base"
read_db .

puts "INFO_DFD: Placing Design"
place_design > debug_place.log
puts "INFO_DFD: CCOPT Design"
ccopt_design > debug_ccopt.log
puts "INFO_DFD: Routing Design"
route_design > debug_route.log
#
puts "INFO_DFD: Writing Database"
write_db ./pnr/

#cd into the partition directory and write the ilm
puts "INFO_DFD: Writing ILM"
write_ilm 
