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

remove_design -all

# load synopsys config
source ../syn/synopsys_dc.setup

#/* compile each subblock independently */

proc nth_pass {n} {
    set prev_n [expr {$n - 1}]

    analyze -format vhdl -lib WORK {"../rtl/types_and_constants.vhd"}

    #Compile ROM_COEFFICIENTS_1
    analyze -format vhdl -lib WORK {"../rtl/rom_coefficients.vhd"}
    elaborate rom_coefficients
    current_design rom_coefficients
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/rom_coefficients_${prev_n}.wscr
    }
    compile

    #Compile FSM_1
    analyze -format vhdl -lib WORK {"../rtl/fsm.vhd"}
    elaborate FSM
    current_design FSM
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/FSM_${prev_n}.wscr
    }
    compile

    #Compile ARITHMETIC_UNIT_1
    analyze -format vhdl -lib WORK {"../rtl/mac.vhd"}
    elaborate mac
    analyze -format vhdl -lib WORK {"../rtl/arithmetic_unit.vhd"}
    elaborate arithmetic_unit
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {


      source ../syn/db/arithmetic_unit_${prev_n}.wscr
    }
    compile

    #Compile SHIFT_REGISTER_1
    analyze -format vhdl -lib WORK {"../rtl/shift_register.vhd"}
    elaborate shift_register
    current_design shift_register
    link
    uniquify
    source ../syn/constraints.sdc
    if  {$n > 1} {
        source ../syn/db/shift_register_${prev_n}.wscr
    }
    compile

    #compile FIR toplevel
    analyze -format vhdl -lib WORK {"../rtl/parallel_fir.vhd"}
    elaborate parallel_fir
    current_design parallel_fir
    link
    uniquify
    source ../syn/constraints.sdc
    dont_touch rom_coefficients true
    dont_touch FSM true
    dont_touch arithmetic_unit true
    dont_touch shift_register true
    compile

    #check if the constraints are met
    report_constraint
    report_area
    report_power
    report_timing
    report_constraint
    characterize -constraint {ROM_COEFFICIENTS_1 FSM_1 ARITHMETIC_UNIT_1 SHIFT_REGISTER_1}
    current_design FSM
    write_script > ../syn/db/FSM_${n}.wscr
    current_design arithmetic_unit
    write_script > ../syn/db/arithmetic_unit_${n}.wscr
    current_design shift_register
    write_script > ../syn/db/shift_register_${n}.wscr
    current_design rom_coefficients
    write_script > ../syn/db/rom_coefficients_${n}.wscr
}

puts "First pass"
nth_pass 1
nth_pass 2
current_design parallel_fir
report_power > ../syn/rpt/area.txt
report_power > ../syn/rpt/power.txt
report_timing > ../syn/rpt/timing.txt
write_file -format verilog -hier -output ../syn/db/parallel_fir.v
