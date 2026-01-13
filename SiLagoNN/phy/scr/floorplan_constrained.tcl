source ../phy/scr/design_variables.tcl

#1. set margin
set margin 50
set gap_x 100
set gap_y 100
set x_offset [expr {$margin / 2.0}]
set y_offset [expr {$margin / 2.0}]

#2. set width for Silago design blocks
set tile_width 500

#3. set height for Silago design blocks
set tile_height 500

#4. create floorplan area
create_floorplan -site SC8T_104CPP_CMOS22FDX -core_size [expr {2*$margin + 8*$tile_width + 7*$gap_x}] [expr {2*$margin + 2*$tile_height + $gap_y}] $margin $margin $margin $margin -no_snap_to_grid

#5. Creating boundary constraints for Silago design blocks
for {set i 0} {$i < 8} {incr i} {

#Top row	
    #set x1 
    set x1 [expr {double($margin + $x_offset + ($tile_width + $gap_x) * $i)}]

    #set y1 
    set y1 [expr {double($margin + $y_offset + $tile_height + $gap_y)}]

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
    set x1 [expr {double($margin + $x_offset + ($tile_width + $gap_x) * $i)}]

    #set y1 
    set y1 [expr {double($margin + $y_offset)}]

    #set x2 
    set x2 [expr {double($x1 + $tile_width)}]

    #set y2 
    set y2 [expr {double($y1 + $tile_height)}]

    #set the cell 
    set cell [lindex ${partition_hinst_list} [expr {$i + 8}]]

    #create_boundary_constraint for the cell
    create_boundary_constraint -type fence -hinst $cell -rects [list [list $x1 $y1 $x2 $y2]]
}

