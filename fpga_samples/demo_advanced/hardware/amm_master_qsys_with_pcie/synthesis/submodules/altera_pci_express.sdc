# (C) 2001-2014 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


create_clock -period "100 MHz" -name {refclk_pci_express} {*refclk_export}
# SERDES Digital Reset inputs are asynchronous
set_false_path -to {*tx_digitalreset_reg0c[0]}
set_false_path -to {*rx_digitalreset_reg0c[0]}
set_clock_groups -exclusive -group [get_clocks { *central_clk_div0* }] -group [get_clocks { *_hssi_pcie_hip* }]
set_multicycle_path -end -setup -from [get_keepers *tl_cfg_ctl_wr*] 2;      
set_multicycle_path -end -hold  -from [get_keepers  *tl_cfg_ctl_wr*] 1; 
set_multicycle_path -end -setup -from [get_keepers *tl_cfg_ctl\[*\]] 3; 
set_multicycle_path -end -hold  -from [get_keepers *tl_cfg_ctl\[*\]] 2;        
