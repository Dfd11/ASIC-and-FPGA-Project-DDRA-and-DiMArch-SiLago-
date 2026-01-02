source ../phy/scr/design_variables.tcl

#1. set margin
set margin 10

#2. set width for Silago design blocks
set tile_width 200

#3. set height for Silago design blocks
set tile_height 200

#4. create floorplan area
create_floorplan -site SC8T_104CPP_CMOS22FDX -core_size [expr {2*$margin + 8*$tile_width}] [expr {2*$margin + 2*$tile_height}] $margin $margin $margin $margin -no_snap_to_grid

#5. Creating boundary constraints for Silago design blocks
for {set i 0} {$i < 8} {incr i} {

#Top row	
    #set x1 
    set x1 [expr {double($margin + $tile_width * $i)}]

    #set y1 
    set y1 [expr {double($margin + $tile_height)}]

    #set x2 
    set x2 [expr {double($x1 + $tile_width)}]

    #set y2 
    set y2 [expr {double($y1 + $tile_height)}]

    #set the cell 
    set cell [lindex ${partition_hinst_list} $i]

    #create_boundary_constraint for the cell
    create_boundary_constraint -type fence -hinst $cell -rects [list [list $x1 $y1 $x2 $y2]]

#Bottom row
    #set x1 
    set x1 [expr {double($margin + $tile_width * $i)}]

    #set y1 
    set y1 [expr {double($margin)}]

    #set x2 
    set x2 [expr {double($x1 + $tile_width)}]

    #set y2 
    set y2 [expr {double($y1 + $tile_height)}]

    #set the cell 
    set cell [lindex ${partition_hinst_list} [expr {$i + 8}]]

    #create_boundary_constraint for the cell
    create_boundary_constraint -type fence -hinst $cell -rects [list [list $x1 $y1 $x2 $y2]]
}

