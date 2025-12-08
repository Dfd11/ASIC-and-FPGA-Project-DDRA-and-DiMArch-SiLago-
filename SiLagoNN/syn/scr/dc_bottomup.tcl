################################################################################
# Design Compiler bottom-up logic synthesis script
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


#DFD Need to check it the source file is correct
set SOURCE_DIR ../rtl

set DB_DIR ../syn/db
set SYN_DIR ../syn
set OUT_DIR ../syn/db
set TOP_NAME drra_wrapper
file mkdir ../syn/rpt
file mkdir ../syn/db
#/* compile each subblock independently */

# load synopsys config
source "${SYN_DIR}/synopsys_dc.setup"

proc nth_pass {n} {
    set prev_n [expr {$n - 1}]
    global SOURCE_DIR DB_DIR SYN_DIR TOP_NAME
    ##############################
    #Then the design components
    remove_design -all
    puts "INFO_DFD: Reading All Files | Pass: ${n}"
    set hierarchy_files [split [read [open "${SOURCE_DIR}/${TOP_NAME}_hierarchy.txt" r]] "\n"]
    foreach filename [lrange ${hierarchy_files} 0 end-1] {
        puts "INFO_DFD: Reading File: ${filename} | Pass: ${n}"
        analyze -format VHDL -lib WORK "${SOURCE_DIR}/${filename}"
    }

    set temp_top silego
    puts "INFO_DFD: Starting ${temp_top} | Pass: ${n}"
    elaborate ${temp_top}
    current_design ${temp_top}
    link
    source "${SYN_DIR}/constraints.sdc"
    if  {$n > 1} {
        puts "INFO_DFD: Reading File: ${DB_DIR}/${temp_top}_${prev_n}.wscr | Pass: ${n}"
        source "${DB_DIR}/${temp_top}_${prev_n}.wscr"
    }
    compile
    dont_touch ${temp_top} true
    ##############################
    
    ##############################
    #Compile TOP LEFT
    set temp_top Silago_top_left_corner
    puts "INFO_DFD: Starting ${temp_top} | Pass: ${n}"
    #analyze -format vhdl -lib WORK "${SOURCE_DIR}/mtrf/${temp_top}.vhd"
    elaborate ${temp_top}
    current_design ${temp_top}
    link
    source "${SYN_DIR}/constraints.sdc"
    if  {$n > 1} {
        puts "INFO_DFD: Reading File: ${DB_DIR}/${temp_top}_${prev_n}.wscr | Pass: ${n}"
        source "${DB_DIR}/${temp_top}_${prev_n}.wscr"
    }
    compile
    dont_touch ${temp_top} true
    ##############################

    ##############################
    #Compile TOP
    set temp_top Silago_top
    puts "INFO_DFD: Starting ${temp_top} | Pass: ${n}"
    #analyze -format vhdl -lib WORK "${SOURCE_DIR}/mtrf/${temp_top}.vhd"
    elaborate ${temp_top}
    current_design ${temp_top}
    link
    source "${SYN_DIR}/constraints.sdc"
    if  {$n > 1} {
        puts "INFO_DFD: Reading File: ${DB_DIR}/${temp_top}_${prev_n}.wscr | Pass: ${n}"
        source "${DB_DIR}/${temp_top}_${prev_n}.wscr"
    }
    compile
    dont_touch ${temp_top} true
    ##############################
    ##############################
    #Compile TOP RIGHT
    set temp_top Silago_top_right_corner
    puts "INFO_DFD: Starting ${temp_top} | Pass: ${n}"
    #analyze -format vhdl -lib WORK "${SOURCE_DIR}/mtrf/${temp_top}.vhd"
    elaborate ${temp_top}
    current_design ${temp_top}
    link
    source "${SYN_DIR}/constraints.sdc"
    if  {$n > 1} {
        puts "INFO_DFD: Reading File: ${DB_DIR}/${temp_top}_${prev_n}.wscr | Pass: ${n}"
        source "${DB_DIR}/${temp_top}_${prev_n}.wscr"
    }
    compile
    dont_touch ${temp_top} true
    ##############################
    ##############################
    #Compile TOP
    set temp_top Silago_bot_left_corner
    puts "INFO_DFD: Starting ${temp_top} | Pass: ${n}"
    #analyze -format vhdl -lib WORK "${SOURCE_DIR}/mtrf/${temp_top}.vhd"
    elaborate ${temp_top}
    current_design ${temp_top}
    link
    source "${SYN_DIR}/constraints.sdc"
    if  {$n > 1} {
        puts "INFO_DFD: Reading File: ${DB_DIR}/${temp_top}_${prev_n}.wscr | Pass: ${n}"
        source "${DB_DIR}/${temp_top}_${prev_n}.wscr"
    }
    compile
    dont_touch ${temp_top} true
    ##############################
    ##############################
    #Compile TOP
    set temp_top Silago_bot
    puts "INFO_DFD: Starting ${temp_top} | Pass: ${n}"
    #analyze -format vhdl -lib WORK "${SOURCE_DIR}/mtrf/${temp_top}.vhd"
    elaborate ${temp_top}
    current_design ${temp_top}
    link
    source "${SYN_DIR}/constraints.sdc"
    if  {$n > 1} {
        puts "INFO_DFD: Reading File: ${DB_DIR}/${temp_top}_${prev_n}.wscr | Pass: ${n}"
        source "${DB_DIR}/${temp_top}_${prev_n}.wscr"
    }
    compile
    dont_touch ${temp_top} true
    ##############################
    ##############################
    #Compile TOP
    set temp_top Silago_bot_right_corner
    puts "INFO_DFD: Starting ${temp_top} | Pass: ${n}"
    #analyze -format vhdl -lib WORK "${SOURCE_DIR}/mtrf/${temp_top}.vhd"
    elaborate ${temp_top}
    current_design ${temp_top}
    link
    source "${SYN_DIR}/constraints.sdc"
    if  {$n > 1} {
        puts "INFO_DFD: Reading File: ${DB_DIR}/${temp_top}_${prev_n}.wscr | Pass: ${n}"
        source "${DB_DIR}/${temp_top}_${prev_n}.wscr"
    }
    compile
    dont_touch ${temp_top} true
    ##############################

    ##############################
    #Compile TOP
    set temp_top drra_wrapper
    puts "INFO_DFD: Starting ${temp_top} | Pass: ${n}"
    #analyze -format vhdl -lib WORK "${SOURCE_DIR}/mtrf/${temp_top}.vhd"
    elaborate ${temp_top}
    current_design ${temp_top}
    link
    set_load 0.13 [all_outputs]
    source "${SYN_DIR}/constraints.sdc"

    #LAST ONE DOESNT HAVE A COMPILE BEFORE WE NEED TO SET THE DO NOT TOUCH
    ##############################
    puts "INFO_DFD: Compiling ${temp_top} | Pass: ${n}"
    compile
    ##############################

    #check if the constraints are met
    puts "INFO_DFD: Reporting ${temp_top} | Pass: ${n}"
    report_constraint > "${SYN_DIR}/rpt/contraint_${n}.txt" 
    report_area > "${SYN_DIR}/rpt/area_${n}.txt"
    report_power > "${SYN_DIR}/rpt/power_${n}.txt"
    report_timing > "${SYN_DIR}/rpt/timing_${n}.txt"

    puts "INFO_DFD: Characterizing ${temp_top} | Pass: ${n}"
    characterize -constraint {Silago_top_r_corner_inst_7_0/SILEGO_cell Silago_top_r_corner_inst_7_0 Silago_top_l_corner_inst_0_0 Silago_top_inst_1_0 Silago_bot_r_corner_inst_7_1 Silago_bot_l_corner_inst_0_1 Silago_bot_inst_1_1 }

    puts "INFO_DFD: Writting Files ${temp_top} | Pass: ${n}"
    set tmp_top silego
    current_design ${tmp_top}
    write_script > "${DB_DIR}/${tmp_top}_${n}.wscr"

    set tmp_top Silago_top_left_corner
    current_design ${tmp_top}
    write_script > "${DB_DIR}/${tmp_top}_${n}.wscr"

    set tmp_top  Silago_top
    current_design ${tmp_top}
    write_script > "${DB_DIR}/${tmp_top}_${n}.wscr"

    set tmp_top  Silago_top_right_corner
    current_design ${tmp_top}
    write_script > "${DB_DIR}/${tmp_top}_${n}.wscr"

    set tmp_top Silago_bot_left_corner
    current_design ${tmp_top}
    write_script > "${DB_DIR}/${tmp_top}_${n}.wscr"

    set tmp_top  Silago_bot
    current_design ${tmp_top}
    write_script > "${DB_DIR}/${tmp_top}_${n}.wscr"

    set tmp_top  Silago_bot_right_corner
    current_design ${tmp_top}
    write_script > "${DB_DIR}/${tmp_top}_${n}.wscr"

}

puts "First pass"
nth_pass 1
puts "Second pass"
nth_pass 2
current_design drra_wrapper
report_area > "${SYN_DIR}/rpt/area.txt"
report_power > "${SYN_DIR}/rpt/power.txt"
report_timing > "${SYN_DIR}/rpt/timing.txt"


change_names -rules verilog -hierarchy
# Export netlist (Explicitly naming it .v)
write_file -format verilog -hierarchy -output ${OUT_DIR}/${current_design}.v

# Export Binary (Optional, for Design Compiler debug)
write_file -format ddc -hierarchy -output ${OUT_DIR}/${current_design}.ddc

# Export SDC (Crucial for ccopt_design in Innovus!)
write_sdc ${OUT_DIR}/${current_design}.sdc
