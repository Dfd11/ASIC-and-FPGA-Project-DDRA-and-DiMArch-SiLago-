#1. read the top place-and-routed top partition
read_db ../phy/db/part/${TOP_NAME}.enc.dat/pnr

#2. assemble the design from the constituent place and routed partitions
assemble_design -block_dir ../phy/db/part/Silago_top_l_corner_inst_0_0.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_top_inst_1_0.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_top_inst_2_0.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_top_inst_3_0.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_top_inst_4_0.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_top_inst_5_0.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_top_inst_6_0.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_top_r_corner_inst_7_0.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_bot_l_corner_inst_0_1.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_bot_inst_1_1.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_bot_inst_2_1.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_bot_inst_3_1.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_bot_inst_4_1.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_bot_inst_5_1.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_bot_inst_6_1.enc.dat/pnr -encounter_format
assemble_design -block_dir ../phy/db/part/Silago_bot_r_corner_inst_7_1.enc.dat/pnr -encounter_format

