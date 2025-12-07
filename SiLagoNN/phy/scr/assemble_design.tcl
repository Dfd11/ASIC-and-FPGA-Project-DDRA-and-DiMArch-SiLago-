#1. read the top place-and-routed top partition
read_db ../phy/db/part/drra_wrapper.enc.dat/pnr

foreach module $partition_module_list {
#2. assemble the design from the constituent place and routed partitions
    assemble_design -block_dir ../phy/db/part/${module}.enc.dat/pnr -encounter_format 
}
