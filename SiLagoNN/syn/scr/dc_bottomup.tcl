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
variable SOURCE_DIR ../rtl

variable DB_DIR ../db
variable SYN_DIR ../syn

#/* compile each subblock independently */
remove_design -all

# load synopsys config
source ${SYN_DIR}/synopsys_dc.setup

proc nth_pass {n} {
    set prev_n [expr {$n - 1}]

    ##############################
    #Then the design components
    set hierarchy_files [split [read [open ${SOURCE_DIR}/silego_hierarchy.txt r]] "\n"]
    foreach filename [lrange ${hierarchy_files} 0 end-1] {
        puts "${filename}"
        analyze -format VHDL -lib WORK "${SOURCE_DIR}/${filename}"
    }
    elaborate silego
    current_design silego
    link
    uniquify
    source ${SYN_DIR}/constraints.sdc
    if  {$n > 1} {
        source ${DB_DIR}/silego_${prev_n}.wscr
    }
    compile
    ##############################
    
    ##############################
    #Compile TOP LEFT
    set temp_top Silago_top_left_corner
    analyze -format vhdl -lib WORK {"${SOURCE_DIR}/mtrf/${temp_top}.vhd"}
    elaborate ${temp_top}
    current_design ${temp_top}
    link
    uniquify
    source ${SYN_DIR}/constraints.sdc
    if  {$n > 1} {
        source ${DB_DIR}/${temp_top}_${prev_n}.wscr
    }
    compile
    ##############################

    ##############################
    #Compile TOP
    set temp_top Silago_top
    analyze -format vhdl -lib WORK {"${SOURCE_DIR}/mtrf/${temp_top}.vhd"}
    elaborate ${temp_top}
    current_design ${temp_top}
    link
    uniquify
    source ${SYN_DIR}/constraints.sdc
    if  {$n > 1} {
        source ${DB_DIR}/${temp_top}_${prev_n}.wscr
    }
    compile
    ##############################
    ##############################
    #Compile TOP RIGHT
    set temp_top Silago_right_corner
    analyze -format vhdl -lib WORK {"${SOURCE_DIR}/mtrf/${temp_top}.vhd"}
    elaborate ${temp_top}
    current_design ${temp_top}
    link
    uniquify
    source ${SYN_DIR}/constraints.sdc
    if  {$n > 1} {
        source ${DB_DIR}/${temp_top}_${prev_n}.wscr
    }
    compile
    ##############################
    ##############################
    #Compile TOP
    set temp_top Silago_bot_left_corner
    analyze -format vhdl -lib WORK {"${SOURCE_DIR}/mtrf/${temp_top}.vhd"}
    elaborate ${temp_top}
    current_design ${temp_top}
    link
    uniquify
    source ${SYN_DIR}/constraints.sdc
    if  {$n > 1} {
        source ${DB_DIR}/${temp_top}_${prev_n}.wscr
    }
    compile
    ##############################
    ##############################
    #Compile TOP
    set temp_top Silago_bot
    analyze -format vhdl -lib WORK {"${SOURCE_DIR}/mtrf/${temp_top}.vhd"}
    elaborate ${temp_top}
    current_design ${temp_top}
    link
    uniquify
    source ${SYN_DIR}/constraints.sdc
    if  {$n > 1} {
        source ${DB_DIR}/${temp_top}_${prev_n}.wscr
    }
    compile
    ##############################
    ##############################
    #Compile TOP
    set temp_top Silago_bot_right_corner
    analyze -format vhdl -lib WORK {"${SOURCE_DIR}/mtrf/${temp_top}.vhd"}
    elaborate ${temp_top}
    current_design ${temp_top}
    link
    uniquify
    source ${SYN_DIR}/constraints.sdc
    if  {$n > 1} {
        source ${DB_DIR}/${temp_top}_${prev_n}.wscr
    }
    compile
    ##############################

    ##############################
    #Compile TOP
    set temp_top drra_wrapper
    analyze -format vhdl -lib WORK {"${SOURCE_DIR}/mtrf/${temp_top}.vhd"}
    elaborate ${temp_top}
    current_design ${temp_top}
    link
    uniquify
    source ${SYN_DIR}/constraints.sdc

    #LAST ONE DOESNT HAVE A COMPILE BEFORE WE NEED TO SET THE DO NOT TOUCH
    ##############################

    dont_touch silego true
    dont_touch Silago_top_left_corner true
    dont_touch Silago_top true
    dont_touch Silago_top_right_corner true
    dont_touch Silago_bot_left_corner true
    dont_touch Silago_bot true
    dont_touch Silago_bot_right_corner true

    compile
    ##############################

    #check if the constraints are met
    report_constraint
    report_area
    report_power
    report_timing
    report_constraint
    characterize -constraint {SILEGO_cell Silago_top_l_corner_inst Silago_top_inst Silago_top_r_corner_inst Silago_bot_l_corner_inst Silago_bot_inst Silago_bot_r_corner_inst}

    set tmp_top silego
    current_design ${tmp_top}
    write_script > ${DB_DIR}/${temp_top}_${n}.wscr

    set tmp_top Silago_top_left_corner
    current_design ${tmp_top}
    write_script > ${DB_DIR}/${temp_top}_${n}.wscr

    set tmp_top  Silago_top
    current_design ${tmp_top}
    write_script > ${DB_DIR}/${temp_top}_${n}.wscr

    set tmp_top  Silago_top_right_corner
    current_design ${tmp_top}
    write_script > ${DB_DIR}/${temp_top}_${n}.wscr

    set tmp_top Silago_bot_left_corner
    current_design ${tmp_top}
    write_script > ${DB_DIR}/${temp_top}_${n}.wscr

    set tmp_top  Silago_bot
    current_design ${tmp_top}
    write_script > ${DB_DIR}/${temp_top}_${n}.wscr

    set tmp_top  Silago_bot_right_corner
    current_design ${tmp_top}
    write_script > ${DB_DIR}/${temp_top}_${n}.wscr

}

puts "First pass"
nth_pass 1
nth_pass 2
current_design drra_wrapper
report_power > ${SYN_DIR}/rpt/area.txt
report_power > ${SYN_DIR}/rpt/power.txt
report_timing > ${SYN_DIR}/rpt/timing.txt
write_file -format verilog -hier -output ${DB_DIR}/parallel_fir.v
