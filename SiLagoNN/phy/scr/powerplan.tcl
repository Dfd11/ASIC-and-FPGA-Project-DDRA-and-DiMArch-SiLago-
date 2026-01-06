# RINGS
add_rings -nets {VDD VSS} -type core_rings -follow core -layer {top JB bottom JB left LB right LB} -width {top 1.5 bottom 1.5 left 1.8 right 1.8} -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none

# STRIPES
add_stripes -nets {VDD VSS} -layer LB -direction vertical -width 1.8 -spacing 1.8 -set_to_set_distance 200 -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit LB -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit LB -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

# SPECIAL ROUTING
set_db route_special_via_connect_to_shape { noshape }

route_special -connect {block_pin pad_pin pad_ring core_pin floating_stripe} -layer_change_range { M1(1) LB(11) } -block_pin_target {nearest_target} -pad_pin_port_connect {all_port one_geom} -pad_pin_target {nearest_target} -core_pin_target {first_after_row_end} -floating_stripe_target {block_ring pad_ring ring stripe ring_pin block_pin followpin} -allow_jogging 1 -crossover_via_layer_range { M1(1) LB(11) } -nets { VDD VSS } -allow_layer_change 1 -block_pin use_lef -target_via_layer_range { M1(1) LB(11) }
