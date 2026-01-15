source ../phy/scr/global_variables.tcl
#1. read the top place-and-routed top partition
read_db ../phy/db/part/${DRRATOP_NAME}.enc.dat/pnr

#2. assemble the design from the constituent place and routed partitions
#Used with bottomup logic synthesis
assemble_design -block_dir ../phy/db/part/Silago_top_left_corner.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_top.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_top_right_corner.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_bot_left_corner.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_bot.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_bot_right_corner.enc.dat/pnr -encounter_format

#Used with flat logic synthesis output
#assemble_design -block_dir ../phy/db/part/Silago_top_left_corner.enc.dat/pnr -encounter_format
#assemble_design -block_dir ../phy/db/part/Silago_top_0.enc.dat/pnr -encounter_format
#assemble_design -block_dir ../phy/db/part/Silago_top_1.enc.dat/pnr -encounter_format
#assemble_design -block_dir ../phy/db/part/Silago_top_2.enc.dat/pnr -encounter_format
#assemble_design -block_dir ../phy/db/part/Silago_top_3.enc.dat/pnr -encounter_format
#assemble_design -block_dir ../phy/db/part/Silago_top_4.enc.dat/pnr -encounter_format
#assemble_design -block_dir ../phy/db/part/Silago_top_5.enc.dat/pnr -encounter_format
#assemble_design -block_dir ../phy/db/part/Silago_top_right_corner.enc.dat/pnr -encounter_format
#assemble_design -block_dir ../phy/db/part/Silago_bot_left_corner.enc.dat/pnr -encounter_format
#assemble_design -block_dir ../phy/db/part/Silago_bot_0.enc.dat/pnr -encounter_format
#assemble_design -block_dir ../phy/db/part/Silago_bot_1.enc.dat/pnr -encounter_format
#assemble_design -block_dir ../phy/db/part/Silago_bot_2.enc.dat/pnr -encounter_format
#assemble_design -block_dir ../phy/db/part/Silago_bot_3.enc.dat/pnr -encounter_format
#assemble_design -block_dir ../phy/db/part/Silago_bot_4.enc.dat/pnr -encounter_format
#assemble_design -block_dir ../phy/db/part/Silago_bot_5.enc.dat/pnr -encounter_format
#assemble_design -block_dir ../phy/db/part/Silago_bot_right_corner.enc.dat/pnr -encounter_format

#Saving the db
file mkdir ../phy/db/part/${DRRATOP_NAME}.enc.dat/assembled
write_db ../phy/db/part/${DRRATOP_NAME}.enc.dat/assembled

#PPA
report_area > hierarchical_area.txt
report_timing > hierarchical_timing.txt
report_power > hierarchical_power.txt
report_cell > hierarchical_cell.txt
report_constraints > hierarchical_constraints.txt


