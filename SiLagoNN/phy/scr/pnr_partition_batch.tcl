#1 Set your Top Name (or get it from the current design if loaded)
# You can change "cpu" to [get_db current_design .name] if a design is loaded
set TIMESTAMP [clock format [clock seconds] -format %Y%m%d_%H%M]

# 2. Find the partition files (Equivalent to 'ls')
# glob finds files. -nocomplain prevents error if no files found.
set partition_list [glob -nocomplain "../phy/db/part/*.enc"]

# Save current directory so we can return to it
set orig_dir [pwd]

foreach partition_path $partition_list {
    
   # 3. Get filename and extension (Equivalent to basename/string manipulation)
   set filename [file tail $partition_path]
   
   # Skip if the filename contains the TOP_NAME (grep -v logic)
   if {[string match "*${TOP_NAME}*" $filename]} {
       continue
   }

   # Strip extension (.enc) to get base name
   set core_name [file rootname $filename]

   puts "Launching PnR for partition: $core_name"

   # 4. Handle Directories (cd, mkdir, rm)
   set work_dir "${partition_path}.dat"
                                              
   if {[file exists $work_dir]} {
       cd $work_dir
                                                                  
       # Clean and recreate pnr folder
       file delete -force pnr
       file mkdir pnr
                                                                                                  
       # 5. Launch the Background Job
       # We use 'exec' with '&' at the end to make it run in background
       # We redirect stdout/stderr to files just like the shell script
                                                                                                                                  
       set log_base "../../../../log"
       set cmd_log "${log_base}/pnr_${core_name}_${TIMESTAMP}.cmd"
       set main_log "${log_base}/pnr_${core_name}_${TIMESTAMP}.log"
       set verbose_log "${log_base}/pnr_${core_name}_${TIMESTAMP}.logv"
                                                                                                                                                                                 
       # Note: We use 'sh -c' to ensure nohup works correctly regarding signals
       # depending on your OS, simple 'exec nohup ... &' might behave differently.
       catch {
           exec sh -c "nohup innovus -stylus -no_gui -batch -files ../../../scr/pnr_partition.tcl -log \"$main_log $cmd_log $verbose_log\" > /dev/null 2>&1 &"
       }
                                                                                                                                                                                                                                                                      
       # Return to original directory for the next loop iteration
       cd $orig_dir
                                                                                                                                                                                                                                                                                                  
    } else {
        puts "WARNING: Directory $work_dir does not exist."
    }
}

puts "All partition jobs have been submitted."
