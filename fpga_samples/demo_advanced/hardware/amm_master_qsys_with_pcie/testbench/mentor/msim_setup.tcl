
# (C) 2001-2014 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and 
# other software and tools, and its AMPP partner logic functions, and 
# any output files any of the foregoing (including device programming 
# or simulation files), and any associated documentation or information 
# are expressly subject to the terms and conditions of the Altera 
# Program License Subscription Agreement, Altera MegaCore Function 
# License Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by Altera 
# or its authorized distributors. Please refer to the applicable 
# agreement for further details.

# ACDS 13.0sp1 232 linux 2014.11.18.17:01:39

# ----------------------------------------
# Auto-generated simulation script

# ----------------------------------------
# Initialize the variable
if ![info exists SYSTEM_INSTANCE_NAME] { 
  set SYSTEM_INSTANCE_NAME ""
} elseif { ![ string match "" $SYSTEM_INSTANCE_NAME ] } { 
  set SYSTEM_INSTANCE_NAME "/$SYSTEM_INSTANCE_NAME"
} 

if ![info exists TOP_LEVEL_NAME] { 
  set TOP_LEVEL_NAME "amm_master_qsys_with_pcie_tb"
} 

if ![info exists QSYS_SIMDIR] { 
  set QSYS_SIMDIR "./../"
} 

if ![info exists QUARTUS_INSTALL_DIR] { 
  set QUARTUS_INSTALL_DIR "/package/eda/altera/altera13.0sp1/quartus/"
} 


# ----------------------------------------
# Copy ROM/RAM files to simulation directory
alias file_copy {
  echo "\[exec\] file_copy"
  file copy -force $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_reconf_registers.hex ./
}

# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib          ./libraries/     
ensure_lib          ./libraries/work/
vmap       work     ./libraries/work/
vmap       work_lib ./libraries/work/
if { ![ string match "*ModelSim ALTERA*" [ vsim -version ] ] } {
  ensure_lib                        ./libraries/altera_ver/            
  vmap       altera_ver             ./libraries/altera_ver/            
  ensure_lib                        ./libraries/lpm_ver/               
  vmap       lpm_ver                ./libraries/lpm_ver/               
  ensure_lib                        ./libraries/sgate_ver/             
  vmap       sgate_ver              ./libraries/sgate_ver/             
  ensure_lib                        ./libraries/altera_mf_ver/         
  vmap       altera_mf_ver          ./libraries/altera_mf_ver/         
  ensure_lib                        ./libraries/altera_lnsim_ver/      
  vmap       altera_lnsim_ver       ./libraries/altera_lnsim_ver/      
  ensure_lib                        ./libraries/cycloneiv_hssi_ver/    
  vmap       cycloneiv_hssi_ver     ./libraries/cycloneiv_hssi_ver/    
  ensure_lib                        ./libraries/cycloneiv_pcie_hip_ver/
  vmap       cycloneiv_pcie_hip_ver ./libraries/cycloneiv_pcie_hip_ver/
  ensure_lib                        ./libraries/cycloneiv_ver/         
  vmap       cycloneiv_ver          ./libraries/cycloneiv_ver/         
}
ensure_lib                                                              ./libraries/altera_avalon_vip_pkgs_lib/                                  
vmap       altera_avalon_vip_pkgs_lib                                   ./libraries/altera_avalon_vip_pkgs_lib/                                  
ensure_lib                                                              ./libraries/pipe_interface_internal/                                     
vmap       pipe_interface_internal                                      ./libraries/pipe_interface_internal/                                     
ensure_lib                                                              ./libraries/reset_controller_internal/                                   
vmap       reset_controller_internal                                    ./libraries/reset_controller_internal/                                   
ensure_lib                                                              ./libraries/altgx_internal/                                              
vmap       altgx_internal                                               ./libraries/altgx_internal/                                              
ensure_lib                                                              ./libraries/pcie_internal_hip/                                           
vmap       pcie_internal_hip                                            ./libraries/pcie_internal_hip/                                           
ensure_lib                                                              ./libraries/irq_mapper/                                                  
vmap       irq_mapper                                                   ./libraries/irq_mapper/                                                  
ensure_lib                                                              ./libraries/crosser/                                                     
vmap       crosser                                                      ./libraries/crosser/                                                     
ensure_lib                                                              ./libraries/width_adapter/                                               
vmap       width_adapter                                                ./libraries/width_adapter/                                               
ensure_lib                                                              ./libraries/rsp_xbar_mux_005/                                            
vmap       rsp_xbar_mux_005                                             ./libraries/rsp_xbar_mux_005/                                            
ensure_lib                                                              ./libraries/rsp_xbar_mux_003/                                            
vmap       rsp_xbar_mux_003                                             ./libraries/rsp_xbar_mux_003/                                            
ensure_lib                                                              ./libraries/rsp_xbar_demux_004/                                          
vmap       rsp_xbar_demux_004                                           ./libraries/rsp_xbar_demux_004/                                          
ensure_lib                                                              ./libraries/rsp_xbar_demux_003/                                          
vmap       rsp_xbar_demux_003                                           ./libraries/rsp_xbar_demux_003/                                          
ensure_lib                                                              ./libraries/rsp_xbar_demux_002/                                          
vmap       rsp_xbar_demux_002                                           ./libraries/rsp_xbar_demux_002/                                          
ensure_lib                                                              ./libraries/cmd_xbar_mux_004/                                            
vmap       cmd_xbar_mux_004                                             ./libraries/cmd_xbar_mux_004/                                            
ensure_lib                                                              ./libraries/cmd_xbar_mux_003/                                            
vmap       cmd_xbar_mux_003                                             ./libraries/cmd_xbar_mux_003/                                            
ensure_lib                                                              ./libraries/cmd_xbar_mux_002/                                            
vmap       cmd_xbar_mux_002                                             ./libraries/cmd_xbar_mux_002/                                            
ensure_lib                                                              ./libraries/cmd_xbar_demux_007/                                          
vmap       cmd_xbar_demux_007                                           ./libraries/cmd_xbar_demux_007/                                          
ensure_lib                                                              ./libraries/cmd_xbar_demux_006/                                          
vmap       cmd_xbar_demux_006                                           ./libraries/cmd_xbar_demux_006/                                          
ensure_lib                                                              ./libraries/cmd_xbar_demux_005/                                          
vmap       cmd_xbar_demux_005                                           ./libraries/cmd_xbar_demux_005/                                          
ensure_lib                                                              ./libraries/cmd_xbar_demux_004/                                          
vmap       cmd_xbar_demux_004                                           ./libraries/cmd_xbar_demux_004/                                          
ensure_lib                                                              ./libraries/cmd_xbar_demux_003/                                          
vmap       cmd_xbar_demux_003                                           ./libraries/cmd_xbar_demux_003/                                          
ensure_lib                                                              ./libraries/cmd_xbar_demux_001/                                          
vmap       cmd_xbar_demux_001                                           ./libraries/cmd_xbar_demux_001/                                          
ensure_lib                                                              ./libraries/rsp_xbar_mux/                                                
vmap       rsp_xbar_mux                                                 ./libraries/rsp_xbar_mux/                                                
ensure_lib                                                              ./libraries/rsp_xbar_demux/                                              
vmap       rsp_xbar_demux                                               ./libraries/rsp_xbar_demux/                                              
ensure_lib                                                              ./libraries/cmd_xbar_demux/                                              
vmap       cmd_xbar_demux                                               ./libraries/cmd_xbar_demux/                                              
ensure_lib                                                              ./libraries/rst_controller/                                              
vmap       rst_controller                                               ./libraries/rst_controller/                                              
ensure_lib                                                              ./libraries/burst_adapter/                                               
vmap       burst_adapter                                                ./libraries/burst_adapter/                                               
ensure_lib                                                              ./libraries/limiter/                                                     
vmap       limiter                                                      ./libraries/limiter/                                                     
ensure_lib                                                              ./libraries/id_router_004/                                               
vmap       id_router_004                                                ./libraries/id_router_004/                                               
ensure_lib                                                              ./libraries/id_router_003/                                               
vmap       id_router_003                                                ./libraries/id_router_003/                                               
ensure_lib                                                              ./libraries/id_router_002/                                               
vmap       id_router_002                                                ./libraries/id_router_002/                                               
ensure_lib                                                              ./libraries/addr_router_006/                                             
vmap       addr_router_006                                              ./libraries/addr_router_006/                                             
ensure_lib                                                              ./libraries/addr_router_005/                                             
vmap       addr_router_005                                              ./libraries/addr_router_005/                                             
ensure_lib                                                              ./libraries/addr_router_003/                                             
vmap       addr_router_003                                              ./libraries/addr_router_003/                                             
ensure_lib                                                              ./libraries/addr_router_001/                                             
vmap       addr_router_001                                              ./libraries/addr_router_001/                                             
ensure_lib                                                              ./libraries/id_router/                                                   
vmap       id_router                                                    ./libraries/id_router/                                                   
ensure_lib                                                              ./libraries/addr_router/                                                 
vmap       addr_router                                                  ./libraries/addr_router/                                                 
ensure_lib                                                              ./libraries/sgdma_csr_translator_avalon_universal_slave_0_agent_rsp_fifo/
vmap       sgdma_csr_translator_avalon_universal_slave_0_agent_rsp_fifo ./libraries/sgdma_csr_translator_avalon_universal_slave_0_agent_rsp_fifo/
ensure_lib                                                              ./libraries/sgdma_csr_translator_avalon_universal_slave_0_agent/         
vmap       sgdma_csr_translator_avalon_universal_slave_0_agent          ./libraries/sgdma_csr_translator_avalon_universal_slave_0_agent/         
ensure_lib                                                              ./libraries/pcie_ip_bar2_translator_avalon_universal_master_0_agent/     
vmap       pcie_ip_bar2_translator_avalon_universal_master_0_agent      ./libraries/pcie_ip_bar2_translator_avalon_universal_master_0_agent/     
ensure_lib                                                              ./libraries/sgdma_csr_translator/                                        
vmap       sgdma_csr_translator                                         ./libraries/sgdma_csr_translator/                                        
ensure_lib                                                              ./libraries/pcie_ip_bar2_translator/                                     
vmap       pcie_ip_bar2_translator                                      ./libraries/pcie_ip_bar2_translator/                                     
ensure_lib                                                              ./libraries/read_master/                                                 
vmap       read_master                                                  ./libraries/read_master/                                                 
ensure_lib                                                              ./libraries/reconf_registers/                                            
vmap       reconf_registers                                             ./libraries/reconf_registers/                                            
ensure_lib                                                              ./libraries/altpll_qsys/                                                 
vmap       altpll_qsys                                                  ./libraries/altpll_qsys/                                                 
ensure_lib                                                              ./libraries/sdram/                                                       
vmap       sdram                                                        ./libraries/sdram/                                                       
ensure_lib                                                              ./libraries/sgdma/                                                       
vmap       sgdma                                                        ./libraries/sgdma/                                                       
ensure_lib                                                              ./libraries/pcie_ip/                                                     
vmap       pcie_ip                                                      ./libraries/pcie_ip/                                                     
ensure_lib                                                              ./libraries/pcie_ip_pcie_bfm_0/                                          
vmap       pcie_ip_pcie_bfm_0                                           ./libraries/pcie_ip_pcie_bfm_0/                                          
ensure_lib                                                              ./libraries/amm_master_qsys_with_pcie_inst_reset_bfm/                    
vmap       amm_master_qsys_with_pcie_inst_reset_bfm                     ./libraries/amm_master_qsys_with_pcie_inst_reset_bfm/                    
ensure_lib                                                              ./libraries/amm_master_qsys_with_pcie_inst_clk_bfm/                      
vmap       amm_master_qsys_with_pcie_inst_clk_bfm                       ./libraries/amm_master_qsys_with_pcie_inst_clk_bfm/                      
ensure_lib                                                              ./libraries/amm_master_qsys_with_pcie_inst/                              
vmap       amm_master_qsys_with_pcie_inst                               ./libraries/amm_master_qsys_with_pcie_inst/                              

# ----------------------------------------
# Compile device library files
alias dev_com {
  echo "\[exec\] dev_com"
  if { ![ string match "*ModelSim ALTERA*" [ vsim -version ] ] } {
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"        -work altera_ver            
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                 -work lpm_ver               
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                    -work sgate_ver             
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                -work altera_mf_ver         
    vlog -sv "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"            -work altera_lnsim_ver      
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_hssi_atoms.v"     -work cycloneiv_hssi_ver    
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_pcie_hip_atoms.v" -work cycloneiv_pcie_hip_ver
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_atoms.v"          -work cycloneiv_ver         
  }
}

# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/verbosity_pkg.sv"                                                                     -work altera_avalon_vip_pkgs_lib                                  
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altpcie_pipe_interface.v"                                                             -work pipe_interface_internal                                     
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altpcie_pcie_reconfig_bridge.v"                                                       -work pipe_interface_internal                                     
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_pcie_hard_ip_reset_controller.v"                                               -work reset_controller_internal                                   
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altpcie_rs_serdes.v"                                                                  -work reset_controller_internal                                   
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altpcie_pll_100_250.v"                                                                -work reset_controller_internal                                   
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altpcie_pll_125_250.v"                                                                -work reset_controller_internal                                   
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_pcie_ip_altgx_internal.vo"                                  -work altgx_internal                                              
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/mentor/avalon_stif/altpciexpav_stif_a2p_addrtrans.v"                                  -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/mentor/avalon_stif/altpciexpav_stif_a2p_fixtrans.v"                                   -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/mentor/avalon_stif/altpciexpav_stif_a2p_vartrans.v"                                   -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/mentor/avalon_stif/altpciexpav_stif_control_register.v"                               -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/mentor/avalon_stif/altpciexpav_stif_cr_avalon.v"                                      -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/mentor/avalon_stif/altpciexpav_stif_cr_interrupt.v"                                   -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/mentor/avalon_stif/altpciexpav_stif_cr_mailbox.v"                                     -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/mentor/avalon_stif/altpciexpav_stif_p2a_addrtrans.v"                                  -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/mentor/avalon_stif/altpciexpav_stif_reg_fifo.v"                                       -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/mentor/avalon_stif/altpciexpav_stif_rx.v"                                             -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/mentor/avalon_stif/altpciexpav_stif_rx_cntrl.v"                                       -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/mentor/avalon_stif/altpciexpav_stif_rx_resp.v"                                        -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/mentor/avalon_stif/altpciexpav_stif_tx.v"                                             -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/mentor/avalon_stif/altpciexpav_stif_tx_cntrl.v"                                       -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/mentor/avalon_stif/altpciexpav_stif_txavl_cntrl.v"                                    -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/mentor/avalon_stif/altpciexpav_stif_txresp_cntrl.v"                                   -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/mentor/avalon_stif/altpciexpav_clksync.v"                                             -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/mentor/avalon_lite/altpciexpav_lite_app.v"                                            -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altpciexpav_stif_app.v"                                                               -work pcie_internal_hip                                           
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altpcie_hip_pipen1b_qsys.v"                                                           -work pcie_internal_hip                                           
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_irq_mapper.sv"                                              -work irq_mapper                                                  
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_avalon_st_handshake_clock_crosser.v"                                           -work crosser                                                     
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_avalon_st_clock_crosser.v"                                                     -work crosser                                                     
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_avalon_st_pipeline_base.v"                                                     -work crosser                                                     
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_width_adapter.sv"                                                       -work width_adapter                                               
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_address_alignment.sv"                                                   -work width_adapter                                               
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_burst_uncompressor.sv"                                                  -work width_adapter                                               
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                                          -work rsp_xbar_mux_005                                            
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_rsp_xbar_mux_005.sv"                                        -work rsp_xbar_mux_005                                            
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                                          -work rsp_xbar_mux_003                                            
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_rsp_xbar_mux_003.sv"                                        -work rsp_xbar_mux_003                                            
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_rsp_xbar_demux_004.sv"                                      -work rsp_xbar_demux_004                                          
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_rsp_xbar_demux_003.sv"                                      -work rsp_xbar_demux_003                                          
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_rsp_xbar_demux_002.sv"                                      -work rsp_xbar_demux_002                                          
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                                          -work cmd_xbar_mux_004                                            
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_mux_004.sv"                                        -work cmd_xbar_mux_004                                            
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                                          -work cmd_xbar_mux_003                                            
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_mux_003.sv"                                        -work cmd_xbar_mux_003                                            
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                                          -work cmd_xbar_mux_002                                            
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_mux_002.sv"                                        -work cmd_xbar_mux_002                                            
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux_007.sv"                                      -work cmd_xbar_demux_007                                          
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux_006.sv"                                      -work cmd_xbar_demux_006                                          
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux_005.sv"                                      -work cmd_xbar_demux_005                                          
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux_004.sv"                                      -work cmd_xbar_demux_004                                          
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux_003.sv"                                      -work cmd_xbar_demux_003                                          
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux_001.sv"                                      -work cmd_xbar_demux_001                                          
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                                          -work rsp_xbar_mux                                                
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_rsp_xbar_mux.sv"                                            -work rsp_xbar_mux                                                
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_rsp_xbar_demux.sv"                                          -work rsp_xbar_demux                                              
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux.sv"                                          -work cmd_xbar_demux                                              
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_reset_controller.v"                                                            -work rst_controller                                              
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_reset_synchronizer.v"                                                          -work rst_controller                                              
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_burst_adapter.sv"                                                       -work burst_adapter                                               
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_address_alignment.sv"                                                   -work burst_adapter                                               
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_traffic_limiter.sv"                                                     -work limiter                                                     
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_avalon_st_pipeline_base.v"                                                     -work limiter                                                     
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_id_router_004.sv"                                           -work id_router_004                                               
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_id_router_003.sv"                                           -work id_router_003                                               
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_id_router_002.sv"                                           -work id_router_002                                               
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_addr_router_006.sv"                                         -work addr_router_006                                             
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_addr_router_005.sv"                                         -work addr_router_005                                             
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_addr_router_003.sv"                                         -work addr_router_003                                             
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_addr_router_001.sv"                                         -work addr_router_001                                             
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_id_router.sv"                                               -work id_router                                                   
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_addr_router.sv"                                             -work addr_router                                                 
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_avalon_sc_fifo.v"                                                              -work sgdma_csr_translator_avalon_universal_slave_0_agent_rsp_fifo
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_slave_agent.sv"                                                         -work sgdma_csr_translator_avalon_universal_slave_0_agent         
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_burst_uncompressor.sv"                                                  -work sgdma_csr_translator_avalon_universal_slave_0_agent         
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_master_agent.sv"                                                        -work pcie_ip_bar2_translator_avalon_universal_master_0_agent     
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_slave_translator.sv"                                                    -work sgdma_csr_translator                                        
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_master_translator.sv"                                                   -work pcie_ip_bar2_translator                                     
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/custom_master.v"                                                                      -work read_master                                                 
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/burst_write_master.v"                                                                 -work read_master                                                 
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/burst_read_master.v"                                                                  -work read_master                                                 
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/write_master.v"                                                                       -work read_master                                                 
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/latency_aware_read_master.v"                                                          -work read_master                                                 
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_reconf_registers.v"                                         -work reconf_registers                                            
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_altpll_qsys.vo"                                             -work altpll_qsys                                                 
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_sdram.v"                                                    -work sdram                                                       
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_sgdma.v"                                                    -work sgdma                                                       
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_pcie_ip.v"                                                  -work pcie_ip                                                     
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_pcie_bfm.v"                                                                    -work pcie_ip_pcie_bfm_0                                          
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_pcie_bfm_components.v"                                                         -work pcie_ip_pcie_bfm_0                                          
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altpcietb_bfm_driver.v"                                                               -work pcie_ip_pcie_bfm_0                                          
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_avalon_reset_source.sv"                          -L altera_avalon_vip_pkgs_lib -work amm_master_qsys_with_pcie_inst_reset_bfm                    
  vlog -sv "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_avalon_clock_source.sv"                          -L altera_avalon_vip_pkgs_lib -work amm_master_qsys_with_pcie_inst_clk_bfm                      
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie.v"                                                          -work amm_master_qsys_with_pcie_inst                              
  vlog     "$QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/amm_master_qsys_with_pcie_tb.v"                                                                                                                                    
}

# ----------------------------------------
# Elaborate top level design
alias elab {
  echo "\[exec\] elab"
  vsim -t ps -L work -L work_lib -L altera_avalon_vip_pkgs_lib -L pipe_interface_internal -L reset_controller_internal -L altgx_internal -L pcie_internal_hip -L irq_mapper -L crosser -L width_adapter -L rsp_xbar_mux_005 -L rsp_xbar_mux_003 -L rsp_xbar_demux_004 -L rsp_xbar_demux_003 -L rsp_xbar_demux_002 -L cmd_xbar_mux_004 -L cmd_xbar_mux_003 -L cmd_xbar_mux_002 -L cmd_xbar_demux_007 -L cmd_xbar_demux_006 -L cmd_xbar_demux_005 -L cmd_xbar_demux_004 -L cmd_xbar_demux_003 -L cmd_xbar_demux_001 -L rsp_xbar_mux -L rsp_xbar_demux -L cmd_xbar_demux -L rst_controller -L burst_adapter -L limiter -L id_router_004 -L id_router_003 -L id_router_002 -L addr_router_006 -L addr_router_005 -L addr_router_003 -L addr_router_001 -L id_router -L addr_router -L sgdma_csr_translator_avalon_universal_slave_0_agent_rsp_fifo -L sgdma_csr_translator_avalon_universal_slave_0_agent -L pcie_ip_bar2_translator_avalon_universal_master_0_agent -L sgdma_csr_translator -L pcie_ip_bar2_translator -L read_master -L reconf_registers -L altpll_qsys -L sdram -L sgdma -L pcie_ip -L pcie_ip_pcie_bfm_0 -L amm_master_qsys_with_pcie_inst_reset_bfm -L amm_master_qsys_with_pcie_inst_clk_bfm -L amm_master_qsys_with_pcie_inst -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiv_hssi_ver -L cycloneiv_pcie_hip_ver -L cycloneiv_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Elaborate the top level design with novopt option
alias elab_debug {
  echo "\[exec\] elab_debug"
  vsim -novopt -t ps -L work -L work_lib -L altera_avalon_vip_pkgs_lib -L pipe_interface_internal -L reset_controller_internal -L altgx_internal -L pcie_internal_hip -L irq_mapper -L crosser -L width_adapter -L rsp_xbar_mux_005 -L rsp_xbar_mux_003 -L rsp_xbar_demux_004 -L rsp_xbar_demux_003 -L rsp_xbar_demux_002 -L cmd_xbar_mux_004 -L cmd_xbar_mux_003 -L cmd_xbar_mux_002 -L cmd_xbar_demux_007 -L cmd_xbar_demux_006 -L cmd_xbar_demux_005 -L cmd_xbar_demux_004 -L cmd_xbar_demux_003 -L cmd_xbar_demux_001 -L rsp_xbar_mux -L rsp_xbar_demux -L cmd_xbar_demux -L rst_controller -L burst_adapter -L limiter -L id_router_004 -L id_router_003 -L id_router_002 -L addr_router_006 -L addr_router_005 -L addr_router_003 -L addr_router_001 -L id_router -L addr_router -L sgdma_csr_translator_avalon_universal_slave_0_agent_rsp_fifo -L sgdma_csr_translator_avalon_universal_slave_0_agent -L pcie_ip_bar2_translator_avalon_universal_master_0_agent -L sgdma_csr_translator -L pcie_ip_bar2_translator -L read_master -L reconf_registers -L altpll_qsys -L sdram -L sgdma -L pcie_ip -L pcie_ip_pcie_bfm_0 -L amm_master_qsys_with_pcie_inst_reset_bfm -L amm_master_qsys_with_pcie_inst_clk_bfm -L amm_master_qsys_with_pcie_inst -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiv_hssi_ver -L cycloneiv_pcie_hip_ver -L cycloneiv_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Compile all the design files and elaborate the top level design
alias ld "
  dev_com
  com
  elab
"

# ----------------------------------------
# Compile all the design files and elaborate the top level design with -novopt
alias ld_debug "
  dev_com
  com
  elab_debug
"

# ----------------------------------------
# Print out user commmand line aliases
alias h {
  echo "List Of Command Line Aliases"
  echo
  echo "file_copy                     -- Copy ROM/RAM files to simulation directory"
  echo
  echo "dev_com                       -- Compile device library files"
  echo
  echo "com                           -- Compile the design files in correct order"
  echo
  echo "elab                          -- Elaborate top level design"
  echo
  echo "elab_debug                    -- Elaborate the top level design with novopt option"
  echo
  echo "ld                            -- Compile all the design files and elaborate the top level design"
  echo
  echo "ld_debug                      -- Compile all the design files and elaborate the top level design with -novopt"
  echo
  echo 
  echo
  echo "List Of Variables"
  echo
  echo "TOP_LEVEL_NAME                -- Top level module name."
  echo
  echo "SYSTEM_INSTANCE_NAME          -- Instantiated system module name inside top level module."
  echo
  echo "QSYS_SIMDIR                   -- Qsys base simulation directory."
  echo
  echo "QUARTUS_INSTALL_DIR           -- Quartus installation directory."
}
file_copy
h
