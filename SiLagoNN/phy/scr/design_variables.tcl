#parititon instantiation labels
#set partition_hinst_list {
#    ROM_COEFFICIENTS_1 \
#    FSM_1 \
#    ARITHMETIC_UNIT_1 \
#    SHIFT_REGISTER_1 }

set partition_hinst_list {
#    Silago_top_r_corner_inst_7_0/SILEGO_cell 
    Silago_top_r_corner_inst_7_0 \
    Silago_top_l_corner_inst_0_0 \
    Silago_top_inst_1_0 \
    Silago_bot_r_corner_inst_7_0 \
    Silago_bot_l_corner_inst_0_0 \
    Silago_bot_inst_1_1 }
#partition module names from RTL
#set partition_module_list {
#    rom_coefficients \
#    FSM \
#    arithmetic_unit \
#    shift_register }

set partition_module_list {
#    silego
    Silago_top_left_corner \
    Silago_top \
    Silago_top_right_corner \
    Silago_bot_left_corner \
    Silago_bot \
    Silago_bot_right_corner }
