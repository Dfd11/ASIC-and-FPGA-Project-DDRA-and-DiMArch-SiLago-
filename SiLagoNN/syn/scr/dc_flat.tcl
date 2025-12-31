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
set SOURCE_DIR ../rtl
set SYN_DIR ../syn
set OUT_DIR ../syn/db
set REPORT_DIR ../syn/rpt

source ${SYN_DIR}/synopsys_dc.setup

set TOP_NAME drra_wrapper

### First we use the analyze command reads and parses all of your VHDL source files, storing the information into a WORK library.

# DWARE Components
set hierarchy_files [split [read [open ${SOURCE_DIR}/dware_hierarchy_verilog.txt r]] "\n"]
foreach filename [lrange ${hierarchy_files} 0 end-1] {
    puts "${filename}"
    analyze -format verilog -lib WORK "${SOURCE_DIR}/${filename}"
}

# Design Components
set hierarchy_files [split [read [open ${SOURCE_DIR}/${TOP_NAME}_hierarchy.txt r]] "\n"]
foreach filename [lrange ${hierarchy_files} 0 end-1] {
    puts "${filename}"
    analyze -format VHDL -lib WORK "${SOURCE_DIR}/${filename}"
}

### Elaborate: After analysis, elaborate takes the top-level design and builds a detailed design from the intermediate format of a Verilog module.

elaborate drra_wrapper

### Link: The purpose of this command is to locate all of the designs and library components referenced in the current  desig and connect (link) them to the current design.
link

## ???
uniquify
if {[check_design] == 0} {
    puts "Error: check design failed"
    exit 1
}

## To remove the CAPACITANCE Violated we use the next line:
set_load 0.13 [all_outputs]

### Compiling the design
source ${SYN_DIR}/constraints.sdc
compile -map_effort medium

report_area > ${REPORT_DIR}/FLAT_${TOP_NAME}_area.txt
report_cell > ${REPORT_DIR}/FLAT_${TOP_NAME}_cells.txt
report_timing > ${REPORT_DIR}/FLAT_${TOP_NAME}_timing.txt
report_power > ${REPORT_DIR}/FLAT_${TOP_NAME}_power.txt
report_constraints > ${REPORT_DIR}/FLAT_${TOP_NAME}_constratints.sdc

## Create Netlists
write -hierarchy -format ddc -output ${OUT_DIR}/FLAT_${TOP_NAME}.ddc
write -hierarchy -format verilog -output ${OUT_DIR}/FLAT_${TOP_NAME}.v

## For Task 4 we need:
write_sdc ${OUT_DIR}/FLAT_${TOP_NAME}.sdc


