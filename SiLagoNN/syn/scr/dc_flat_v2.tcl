source ../syn/synopsys_dc.setup

#Directory variables
set SOURCE_DIR ../rtl
set SYN_DIR ../syn
set OUT_DIR ../syn/db
set REPORT_DIR ../syn/rpt

## (Removed duplicate source setup command, it was there twice)

set TOP_NAME drra_wrapper

## Read files
## First the DesignWare Components
set hierarchy_files [split [read [open ${SOURCE_DIR}/dware_hierarchy_verilog.txt r]] "\n"]
foreach filename [lrange ${hierarchy_files} 0 end-1] {
    puts "${filename}"
    analyze -format verilog -lib WORK "${SOURCE_DIR}/${filename}"
}

 #Then the design components
 # CRITICAL CHECK: Ensure 'silego.vhd' is listed BEFORE 'Silago_top_left_corner.vhd' 
 # inside the text file '${TOP_NAME}_hierarchy.txt'
set hierarchy_files [split [read [open ${SOURCE_DIR}/${TOP_NAME}_hierarchy.txt r]] "\n"]
foreach filename [lrange ${hierarchy_files} 0 end-1] {
    puts "${filename}"
    analyze -format VHDL -lib WORK "${SOURCE_DIR}/${filename}"
}

elaborate drra_wrapper

# --- FIX START: Resolve "silego_0" errors ---
current_design drra_wrapper
link

# 1. UNIQUIFY: This fixes the "Unable to resolve reference" errors.
#    It takes the generic 'silego' and creates real definitions for 'silego_0', 'silego_1', etc.
uniquify 

# 2. CHECK: Verify the link worked before compiling. 
#    If this fails, do not proceed.
if {[check_design] == 0} {
    puts "Error: Check design failed"
    exit 1 
}
# --- FIX END ---

#set_wire_load_mode segmented
#set_wire_load_model -name TSMC8K_Lowk_Aggresive
#set_operating_condition NCCOM

set_load 0.13 [all_outputs]
source ${SYN_DIR}/constraints.sdc;

# Note: compile_ultra is preferred if you have the license, otherwise compile is fine
compile -map_effort medium

report_constraints      > ${REPORT_DIR}/${TOP_NAME}_constraints.sdc
report_area             > ${REPORT_DIR}/${TOP_NAME}_area.txt
report_cell             > ${REPORT_DIR}/${TOP_NAME}_cells.txt
report_timing           > ${REPORT_DIR}/${TOP_NAME}_timing.txt
report_power            > ${REPORT_DIR}/${TOP_NAME}_power.txt

# --- FIX START: Prepared Output for Innovus ---

# 3. CHANGE NAMES: Converts VHDL names (brackets, case insensitivity) to Verilog standards.
#    Without this, Innovus often fails to map signals correctly.
change_names -rules verilog -hierarchy

# Export netlist (Explicitly naming it .v)
write_file -format verilog -hierarchy -output ${OUT_DIR}/${TOP_NAME}.v

# Export Binary (Optional, for Design Compiler debug)
write_file -format ddc -hierarchy -output ${OUT_DIR}/${TOP_NAME}.ddc

# Export SDC (Crucial for ccopt_design in Innovus!)
write_sdc ${OUT_DIR}/${TOP_NAME}.sdc

# --- FIX END ---
