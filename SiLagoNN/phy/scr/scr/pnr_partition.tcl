#cd into the specific partition directory
#set PART_DIR_PATH "../phy/db/part/${PART_NAME}"
#puts "INFO: PNR partition in: $PART_DIR_PATH"

#cd $PART_DIR_PATH

#3. read the parition
read_db .

#4. place
place_design

#5. ccopt
ccopt_design

#6. route
route_design

#7. write the partition db
write_db ./pnr

#8. write ilm
write_ilm

