source ../phy/scr/read_design.tcl

#Floorplan
source ../phy/scr/FLAT_floorplan.tcl

#Place
place_design
assign_io_pins
#CTS
ccopt_design
#Route design
assign_io_pins
route_design

#Outputs
write_db ${OUTPUT_DIR}/FLAT_${TOP_NAME}.dat
write_netlist ${OUTPUT_DIR}/FLAT_${TOP_NAME}.v

#Reports
report_timing > ${RPT_DIR}/${TOP_NAME}_physical_timing.txt
report_power > ${RPT_DIR}/${TOP_NAME}_physical_power.txt
report_area > ${RPT_DIR}/${TOP_NAME}_physical_area.txt
time_design -post_route > ${RPT_DIR}/${TOP_NAME}_timing_postroute.txt
