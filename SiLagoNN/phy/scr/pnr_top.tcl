source ../phy/scr/global_variables.tcl
source ../phy/scr/design_variables.tcl

cd ../phy/db/part
read_db ${DRRATOP_NAME}.enc.dat

foreach module $partition_module_list {
	#1. read ilm master partitions
	read_ilm -cell $module -dir ${module}.enc.dat/ilm
}
#2. flatten ilms
flatten_ilm

#3. place 
place_design
#4. ccopt
ccopt_design
#5. route
route_design

#6. write the place and routed db
write_db ${TOP_NAME}.enc.dat/pnr

