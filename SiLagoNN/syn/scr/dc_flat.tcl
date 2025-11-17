################################################################################
# Flat logic synthesis script
################################################################################
#
# This script is meant to be executed with the following directory structure
#
# project_top_folder
# |
# |- db: store output data like mapped designs or physical files like GDSII
# |
# |- phy: physical synthesis material (scripts, pins, etc)
# |
# |- rtl: contains rtl code for the design, it should also contain a
# |       hierarchy.txt file with the all the files that compose the design
# |
# |- syn: logic synthesis material (this script, SDC constraints, etc)
# |
# |- sim: simulation stuff like waveforms, reports, coverage etc.
# |
# |- tb: testbenches for the rtl code
# |
# |- exe: the directory where it should be executed. This keeps all the temp files
#         created by DC in that directory
#
#
# The standard way of executing the is from the project_top_folder
# with the following command
#
# $ dc_shell -f ../syn/dc_flat.tcl
################################################################################

#Directory variables
set REPORT_DIR ../rpt; 			# report directory for synthesis reports on timing and area
set OUT_DIR ../db; 				# output directory for output files: netlist, sdf sdc.
set SOURCE_DIR ../../rtl; 				# source directory with the rtl 
set SYN_DIR ../; 				# synthesis directory

source ${SYN_DIR}/scr/synopsys_dc.setup

set TOP_NAME drra_wrapper

# Read files
set hierarchy_files [split [read [open ${SOURCE_DIR}/${TOP_NAME}_hierarchy.txt r]] "\n"]
foreach filename [lrange ${hierarchy_files} 0 end-1] {
	puts "${filename}"
	analyze -format VHDL -lib WORK "${SOURCE_DIR}/${filename}"
}

elaborate drra_wrapper
link

set_wire_load_mode segmented
# set_wire_load_model -name TSMC8K_Lowk_Aggresive
# set_operating_condition NCCOM

source ${SYN_DIR}/constraints.sdc;

compile -map_effort medium

report_constraints 	> ${REPORT_DIR}/${TOP_NAME}_constratints.sdc
report_area 		> ${REPORT_DIR}/${TOP_NAME}_area.txt
report_cell 		> ${REPORT_DIR}/${TOP_NAME}_cells.txt
report_timing 		> ${REPORT_DIR}/${TOP_NAME}_timing.txt
report_power 		> ${REPORT_DIR}/${TOP_NAME}_power.txt

# Export netlist
write -hierarchy -format ddc -output ${OUT_DIR}/${TOP_NAME}.ddc
write -hierarchy -format verilog -output ${OUT_DIR}/${TOP_NAME}.v
