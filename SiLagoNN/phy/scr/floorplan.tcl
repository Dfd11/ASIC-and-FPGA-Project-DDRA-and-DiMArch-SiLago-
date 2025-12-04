set margin 10
set dim 60

set utilization 0.7
set ratio 0.25

#create_floorplan -site SC8T_104CPP_CMOS22FDX -core_density_size [expr {$ratio}] [expr {$utilization}] 10 10 10 10
#Size is 1260 x 330
#size without margins 1240 x 310
#So a block is of size 155 x 155 so a should margin of 10 would be good
set width 155
set height 155

create_floorplan -site SC8T_104CPP_CMOS22FDX -core_size [expr {8*($width) + 3*$margin}] [expr { 2*($height) + $margin }] 10 10 10 10

#for {set i 0} {$i < 4} {incr i} {
#    set x1 [expr {double($margin + $dim * $i)}]
#    set y1 [expr {double($margin)}]
#    set x2 [expr {double($x1 + $dim)}]
#    set y2 [expr {double($y1 + $dim)}]
#
#    set cell [lindex ${partition_hinst_list} $i ]
#    puts $cell
#    create_boundary_constraint -type fence -hinst $cell -rects [list [list $x1 $y1 $x2 $y2]]
#}
