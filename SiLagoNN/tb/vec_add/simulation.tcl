vlib work

set SOURCE_DIR ./rtl;
        
#1. Compile dware libraries into "dware" and the design into "work"
if {![file exists "DWARE"]} {
        vlib DWARE
}

#MAP logical library name to directory
vmap DWARE ./DWARE


# Compile parallel_fir design into "work"
set hierarchy_files [split [read [open ${SOURCE_DIR}/dware_hierarchy_verilog.txt r]] "\n"]

foreach filename [lrange ${hierarchy_files} 0 end-1] {
    if {[string equal [file extension $filename] ".vhd"]} {
        vcom -2008 -work DWARE ${SOURCE_DIR}/${filename}
    } else {
        vlog -sv -work DWARE ${SOURCE_DIR}/${filename}
    }
}

set hierarchy_files [split [read [open ${SOURCE_DIR}/dware_hierarchy.txt r]] "\n"]

foreach filename [lrange ${hierarchy_files} 0 end-1] {
    if {[string equal [file extension $filename] ".vhd"]} {
        vcom -2008 -work DWARE ${SOURCE_DIR}/${filename}
    } else {
        vlog -sv -work DWARE ${SOURCE_DIR}/${filename}
    }
}

set hierarchy_files [split [read [open ${SOURCE_DIR}/silagonn_hierarchy.txt r]] "\n"]

foreach filename [lrange ${hierarchy_files} 0 end-1] {
    if {[string equal [file extension $filename] ".vhd"]} {
        vcom -2008 -work work ${SOURCE_DIR}/${filename}
    } else {
        vlog -v2001 -work work ${SOURCE_DIR}/${filename}
    }
}

#2. Compile testbench. 
vcom -2008 -work work ./tb/vec_add/const_package.vhd
vcom -2008 -work work ./tb/vec_add/testbench.vhd

#3. Run simulation. 
vsim -voptargs=+acc work.testbench
do ./tb/vec_add/wave.do
run 5000ns;

