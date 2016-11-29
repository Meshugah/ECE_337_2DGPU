
# (C) 2001-2015 Altera Corporation. All rights reserved.
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

# ACDS 14.0 200 linux 2015.02.23.22:38:15

# ----------------------------------------
# Auto-generated simulation script

# ----------------------------------------
# Initialize variables
if ![info exists SYSTEM_INSTANCE_NAME] { 
  set SYSTEM_INSTANCE_NAME ""
} elseif { ![ string match "" $SYSTEM_INSTANCE_NAME ] } { 
  set SYSTEM_INSTANCE_NAME "/$SYSTEM_INSTANCE_NAME"
}

if ![info exists TOP_LEVEL_NAME] { 
  set TOP_LEVEL_NAME "amm_master_qsys_with_pcie"
}

if ![info exists QSYS_SIMDIR] { 
  set QSYS_SIMDIR "./../"
}

if ![info exists QUARTUS_INSTALL_DIR] { 
  set QUARTUS_INSTALL_DIR "/package/eda/altera/altera14.0/quartus/"
}

# ----------------------------------------
# Initialize simulation properties - DO NOT MODIFY!
set ELAB_OPTIONS ""
set SIM_OPTIONS ""
if ![ string match "*-64 vsim*" [ vsim -version ] ] {
} else {
}

set Aldec "Riviera"
if { [ string match "*Active-HDL*" [ vsim -version ] ] } {
  set Aldec "Active"
}

if { [ string match "Active" $Aldec ] } {
  scripterconf -tcl
  createdesign "$TOP_LEVEL_NAME"  "."
  opendesign "$TOP_LEVEL_NAME"
}

# ----------------------------------------
# Copy ROM/RAM files to simulation directory
alias file_copy {
  echo "\[exec\] file_copy"
}

# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib      ./libraries     
ensure_lib      ./libraries/work
vmap       work ./libraries/work
ensure_lib                        ./libraries/altera_ver            
vmap       altera_ver             ./libraries/altera_ver            
ensure_lib                        ./libraries/lpm_ver               
vmap       lpm_ver                ./libraries/lpm_ver               
ensure_lib                        ./libraries/sgate_ver             
vmap       sgate_ver              ./libraries/sgate_ver             
ensure_lib                        ./libraries/altera_mf_ver         
vmap       altera_mf_ver          ./libraries/altera_mf_ver         
ensure_lib                        ./libraries/altera_lnsim_ver      
vmap       altera_lnsim_ver       ./libraries/altera_lnsim_ver      
ensure_lib                        ./libraries/cycloneiv_hssi_ver    
vmap       cycloneiv_hssi_ver     ./libraries/cycloneiv_hssi_ver    
ensure_lib                        ./libraries/cycloneiv_pcie_hip_ver
vmap       cycloneiv_pcie_hip_ver ./libraries/cycloneiv_pcie_hip_ver
ensure_lib                        ./libraries/cycloneiv_ver         
vmap       cycloneiv_ver          ./libraries/cycloneiv_ver         
ensure_lib                             ./libraries/rsp_mux                    
vmap       rsp_mux                     ./libraries/rsp_mux                    
ensure_lib                             ./libraries/rsp_demux                  
vmap       rsp_demux                   ./libraries/rsp_demux                  
ensure_lib                             ./libraries/cmd_mux                    
vmap       cmd_mux                     ./libraries/cmd_mux                    
ensure_lib                             ./libraries/cmd_demux                  
vmap       cmd_demux                   ./libraries/cmd_demux                  
ensure_lib                             ./libraries/router_001                 
vmap       router_001                  ./libraries/router_001                 
ensure_lib                             ./libraries/router                     
vmap       router                      ./libraries/router                     
ensure_lib                             ./libraries/crosser                    
vmap       crosser                     ./libraries/crosser                    
ensure_lib                             ./libraries/rsp_mux_004                
vmap       rsp_mux_004                 ./libraries/rsp_mux_004                
ensure_lib                             ./libraries/rsp_mux_002                
vmap       rsp_mux_002                 ./libraries/rsp_mux_002                
ensure_lib                             ./libraries/rsp_demux_001              
vmap       rsp_demux_001               ./libraries/rsp_demux_001              
ensure_lib                             ./libraries/cmd_mux_001                
vmap       cmd_mux_001                 ./libraries/cmd_mux_001                
ensure_lib                             ./libraries/cmd_demux_004              
vmap       cmd_demux_004               ./libraries/cmd_demux_004              
ensure_lib                             ./libraries/cmd_demux_003              
vmap       cmd_demux_003               ./libraries/cmd_demux_003              
ensure_lib                             ./libraries/cmd_demux_002              
vmap       cmd_demux_002               ./libraries/cmd_demux_002              
ensure_lib                             ./libraries/router_006                 
vmap       router_006                  ./libraries/router_006                 
ensure_lib                             ./libraries/router_005                 
vmap       router_005                  ./libraries/router_005                 
ensure_lib                             ./libraries/router_004                 
vmap       router_004                  ./libraries/router_004                 
ensure_lib                             ./libraries/router_002                 
vmap       router_002                  ./libraries/router_002                 
ensure_lib                             ./libraries/sgdma_csr_rsp_width_adapter
vmap       sgdma_csr_rsp_width_adapter ./libraries/sgdma_csr_rsp_width_adapter
ensure_lib                             ./libraries/sgdma_csr_burst_adapter    
vmap       sgdma_csr_burst_adapter     ./libraries/sgdma_csr_burst_adapter    
ensure_lib                             ./libraries/pcie_ip_bar2_limiter       
vmap       pcie_ip_bar2_limiter        ./libraries/pcie_ip_bar2_limiter       
ensure_lib                             ./libraries/sgdma_csr_agent_rsp_fifo   
vmap       sgdma_csr_agent_rsp_fifo    ./libraries/sgdma_csr_agent_rsp_fifo   
ensure_lib                             ./libraries/sgdma_csr_agent            
vmap       sgdma_csr_agent             ./libraries/sgdma_csr_agent            
ensure_lib                             ./libraries/pcie_ip_bar2_agent         
vmap       pcie_ip_bar2_agent          ./libraries/pcie_ip_bar2_agent         
ensure_lib                             ./libraries/sgdma_csr_translator       
vmap       sgdma_csr_translator        ./libraries/sgdma_csr_translator       
ensure_lib                             ./libraries/pcie_ip_bar2_translator    
vmap       pcie_ip_bar2_translator     ./libraries/pcie_ip_bar2_translator    
ensure_lib                             ./libraries/pipe_interface_internal    
vmap       pipe_interface_internal     ./libraries/pipe_interface_internal    
ensure_lib                             ./libraries/reset_controller_internal  
vmap       reset_controller_internal   ./libraries/reset_controller_internal  
ensure_lib                             ./libraries/altgx_internal             
vmap       altgx_internal              ./libraries/altgx_internal             
ensure_lib                             ./libraries/pcie_internal_hip          
vmap       pcie_internal_hip           ./libraries/pcie_internal_hip          
ensure_lib                             ./libraries/rst_controller             
vmap       rst_controller              ./libraries/rst_controller             
ensure_lib                             ./libraries/irq_mapper                 
vmap       irq_mapper                  ./libraries/irq_mapper                 
ensure_lib                             ./libraries/mm_interconnect_2          
vmap       mm_interconnect_2           ./libraries/mm_interconnect_2          
ensure_lib                             ./libraries/mm_interconnect_1          
vmap       mm_interconnect_1           ./libraries/mm_interconnect_1          
ensure_lib                             ./libraries/mm_interconnect_0          
vmap       mm_interconnect_0           ./libraries/mm_interconnect_0          
ensure_lib                             ./libraries/user_module_0              
vmap       user_module_0               ./libraries/user_module_0              
ensure_lib                             ./libraries/altpll_qsys                
vmap       altpll_qsys                 ./libraries/altpll_qsys                
ensure_lib                             ./libraries/sdram                      
vmap       sdram                       ./libraries/sdram                      
ensure_lib                             ./libraries/sgdma                      
vmap       sgdma                       ./libraries/sgdma                      
ensure_lib                             ./libraries/pcie_ip                    
vmap       pcie_ip                     ./libraries/pcie_ip                    

# ----------------------------------------
# Compile device library files
alias dev_com {
  echo "\[exec\] dev_com"
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"        -work altera_ver            
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                 -work lpm_ver               
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                    -work sgate_ver             
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                -work altera_mf_ver         
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"            -work altera_lnsim_ver      
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_hssi_atoms.v"     -work cycloneiv_hssi_ver    
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_pcie_hip_atoms.v" -work cycloneiv_pcie_hip_ver
  vlog  "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_atoms.v"          -work cycloneiv_ver         
}

# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                  -work rsp_mux                    
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_2_rsp_mux.sv"       -work rsp_mux                    
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_2_rsp_demux.sv"     -work rsp_demux                  
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                  -work cmd_mux                    
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_2_cmd_mux.sv"       -work cmd_mux                    
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_2_cmd_demux.sv"     -work cmd_demux                  
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_2_router_001.sv"    -work router_001                 
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_2_router.sv"        -work router                     
  vlog  "$QSYS_SIMDIR/submodules/altera_avalon_st_handshake_clock_crosser.v"                   -work crosser                    
  vlog  "$QSYS_SIMDIR/submodules/altera_avalon_st_clock_crosser.v"                             -work crosser                    
  vlog  "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_base.v"                             -work crosser                    
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                  -work rsp_mux_004                
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_rsp_mux_004.sv"   -work rsp_mux_004                
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                  -work rsp_mux_002                
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_rsp_mux_002.sv"   -work rsp_mux_002                
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                  -work rsp_mux                    
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_rsp_mux.sv"       -work rsp_mux                    
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_rsp_demux_001.sv" -work rsp_demux_001              
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_rsp_demux.sv"     -work rsp_demux                  
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                  -work cmd_mux_001                
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_cmd_mux_001.sv"   -work cmd_mux_001                
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                  -work cmd_mux                    
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_cmd_mux.sv"       -work cmd_mux                    
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_cmd_demux_004.sv" -work cmd_demux_004              
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_cmd_demux_003.sv" -work cmd_demux_003              
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_cmd_demux_002.sv" -work cmd_demux_002              
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_cmd_demux.sv"     -work cmd_demux                  
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_router_006.sv"    -work router_006                 
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_router_005.sv"    -work router_005                 
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_router_004.sv"    -work router_004                 
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_router_002.sv"    -work router_002                 
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_router.sv"        -work router                     
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_width_adapter.sv"                               -work sgdma_csr_rsp_width_adapter
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_address_alignment.sv"                           -work sgdma_csr_rsp_width_adapter
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_burst_uncompressor.sv"                          -work sgdma_csr_rsp_width_adapter
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                  -work rsp_mux                    
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_0_rsp_mux.sv"       -work rsp_mux                    
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_0_rsp_demux.sv"     -work rsp_demux                  
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                  -work cmd_mux                    
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_0_cmd_mux.sv"       -work cmd_mux                    
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_0_cmd_demux.sv"     -work cmd_demux                  
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_burst_adapter_13_1.sv"                          -work sgdma_csr_burst_adapter    
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_burst_adapter.sv"                               -work sgdma_csr_burst_adapter    
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_burst_adapter_new.sv"                           -work sgdma_csr_burst_adapter    
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_address_alignment.sv"                           -work sgdma_csr_burst_adapter    
  vlog  "$QSYS_SIMDIR/submodules/altera_wrap_burst_converter.sv"                               -work sgdma_csr_burst_adapter    
  vlog  "$QSYS_SIMDIR/submodules/altera_incr_burst_converter.sv"                               -work sgdma_csr_burst_adapter    
  vlog  "$QSYS_SIMDIR/submodules/altera_default_burst_converter.sv"                            -work sgdma_csr_burst_adapter    
  vlog  "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_stage.sv"                           -work sgdma_csr_burst_adapter    
  vlog  "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_base.v"                             -work sgdma_csr_burst_adapter    
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_traffic_limiter.sv"                             -work pcie_ip_bar2_limiter       
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_reorder_memory.sv"                              -work pcie_ip_bar2_limiter       
  vlog  "$QSYS_SIMDIR/submodules/altera_avalon_sc_fifo.v"                                      -work pcie_ip_bar2_limiter       
  vlog  "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_base.v"                             -work pcie_ip_bar2_limiter       
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_0_router_001.sv"    -work router_001                 
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_0_router.sv"        -work router                     
  vlog  "$QSYS_SIMDIR/submodules/altera_avalon_sc_fifo.v"                                      -work sgdma_csr_agent_rsp_fifo   
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_slave_agent.sv"                                 -work sgdma_csr_agent            
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_burst_uncompressor.sv"                          -work sgdma_csr_agent            
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_master_agent.sv"                                -work pcie_ip_bar2_agent         
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv"                            -work sgdma_csr_translator       
  vlog  "$QSYS_SIMDIR/submodules/altera_merlin_master_translator.sv"                           -work pcie_ip_bar2_translator    
  vlog  "$QSYS_SIMDIR/submodules/altpcie_pipe_interface.v"                                     -work pipe_interface_internal    
  vlog  "$QSYS_SIMDIR/submodules/altpcie_pcie_reconfig_bridge.v"                               -work pipe_interface_internal    
  vlog  "$QSYS_SIMDIR/submodules/altera_pcie_hard_ip_reset_controller.v"                       -work reset_controller_internal  
  vlog  "$QSYS_SIMDIR/submodules/altpcie_rs_serdes.v"                                          -work reset_controller_internal  
  vlog  "$QSYS_SIMDIR/submodules/altpcie_pll_100_250.v"                                        -work reset_controller_internal  
  vlog  "$QSYS_SIMDIR/submodules/altpcie_pll_125_250.v"                                        -work reset_controller_internal  
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_pcie_ip_altgx_internal.vo"          -work altgx_internal             
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_stif/altpciexpav_stif_a2p_addrtrans.v"           -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_stif/altpciexpav_stif_a2p_fixtrans.v"            -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_stif/altpciexpav_stif_a2p_vartrans.v"            -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_stif/altpciexpav_stif_control_register.v"        -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_stif/altpciexpav_stif_cfg_status.v"              -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_stif/altpciexpav_stif_cr_avalon.v"               -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_stif/altpciexpav_stif_cr_interrupt.v"            -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_stif/altpciexpav_stif_cr_mailbox.v"              -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_stif/altpciexpav_stif_p2a_addrtrans.v"           -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_stif/altpciexpav_stif_reg_fifo.v"                -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_stif/altpciexpav_stif_rx.v"                      -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_stif/altpciexpav_stif_rx_cntrl.v"                -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_stif/altpciexpav_stif_rx_resp.v"                 -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_stif/altpciexpav_stif_tx.v"                      -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_stif/altpciexpav_stif_tx_cntrl.v"                -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_stif/altpciexpav_stif_txavl_cntrl.v"             -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_stif/altpciexpav_stif_txresp_cntrl.v"            -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_stif/altpciexpav_clksync.v"                      -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/aldec/avalon_lite/altpciexpav_lite_app.v"                     -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/altpciexpav_stif_app.v"                                       -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/altpcie_hip_pipen1b_qsys.v"                                   -work pcie_internal_hip          
  vlog  "$QSYS_SIMDIR/submodules/altera_reset_controller.v"                                    -work rst_controller             
  vlog  "$QSYS_SIMDIR/submodules/altera_reset_synchronizer.v"                                  -work rst_controller             
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_irq_mapper.sv"                      -work irq_mapper                 
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_2.v"                -work mm_interconnect_2          
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1.v"                -work mm_interconnect_1          
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_0.v"                -work mm_interconnect_0          
  vlog  "$QSYS_SIMDIR/submodules/user_module.sv"                                               -work user_module_0              
  vlog  "$QSYS_SIMDIR/submodules/arit.sv"                                                      -work user_module_0              
  vlog  "$QSYS_SIMDIR/submodules/controlunit.sv"                                               -work user_module_0              
  vlog  "$QSYS_SIMDIR/submodules/flex_counter.sv"                                              -work user_module_0              
  vlog  "$QSYS_SIMDIR/submodules/ImageSpecRegs.sv"                                             -work user_module_0              
  vlog  "$QSYS_SIMDIR/submodules/memory_cntrl.sv"                                              -work user_module_0              
  vlog  "$QSYS_SIMDIR/submodules/outputlogic.sv"                                               -work user_module_0              
  vlog  "$QSYS_SIMDIR/submodules/readCounter.sv"                                               -work user_module_0              
  vlog  "$QSYS_SIMDIR/submodules/shift_register.sv"                                            -work user_module_0              
  vlog  "$QSYS_SIMDIR/submodules/startdecoder.sv"                                              -work user_module_0              
  vlog  "$QSYS_SIMDIR/submodules/top_levelu.sv"                                                -work user_module_0              
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_altpll_qsys.vo"                     -work altpll_qsys                
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_sdram.v"                            -work sdram                      
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_sgdma.v"                            -work sgdma                      
  vlog  "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_pcie_ip.v"                          -work pcie_ip                    
  vlog  "$QSYS_SIMDIR/amm_master_qsys_with_pcie.v"                                                                              
}

# ----------------------------------------
# Elaborate top level design
alias elab {
  echo "\[exec\] elab"
  eval vsim +access +r -t ps $ELAB_OPTIONS -L work -L rsp_mux -L rsp_demux -L cmd_mux -L cmd_demux -L router_001 -L router -L crosser -L rsp_mux_004 -L rsp_mux_002 -L rsp_demux_001 -L cmd_mux_001 -L cmd_demux_004 -L cmd_demux_003 -L cmd_demux_002 -L router_006 -L router_005 -L router_004 -L router_002 -L sgdma_csr_rsp_width_adapter -L sgdma_csr_burst_adapter -L pcie_ip_bar2_limiter -L sgdma_csr_agent_rsp_fifo -L sgdma_csr_agent -L pcie_ip_bar2_agent -L sgdma_csr_translator -L pcie_ip_bar2_translator -L pipe_interface_internal -L reset_controller_internal -L altgx_internal -L pcie_internal_hip -L rst_controller -L irq_mapper -L mm_interconnect_2 -L mm_interconnect_1 -L mm_interconnect_0 -L user_module_0 -L altpll_qsys -L sdram -L sgdma -L pcie_ip -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiv_hssi_ver -L cycloneiv_pcie_hip_ver -L cycloneiv_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Elaborate the top level design with -dbg -O2 option
alias elab_debug {
  echo "\[exec\] elab_debug"
  eval vsim -dbg -O2 +access +r -t ps $ELAB_OPTIONS -L work -L rsp_mux -L rsp_demux -L cmd_mux -L cmd_demux -L router_001 -L router -L crosser -L rsp_mux_004 -L rsp_mux_002 -L rsp_demux_001 -L cmd_mux_001 -L cmd_demux_004 -L cmd_demux_003 -L cmd_demux_002 -L router_006 -L router_005 -L router_004 -L router_002 -L sgdma_csr_rsp_width_adapter -L sgdma_csr_burst_adapter -L pcie_ip_bar2_limiter -L sgdma_csr_agent_rsp_fifo -L sgdma_csr_agent -L pcie_ip_bar2_agent -L sgdma_csr_translator -L pcie_ip_bar2_translator -L pipe_interface_internal -L reset_controller_internal -L altgx_internal -L pcie_internal_hip -L rst_controller -L irq_mapper -L mm_interconnect_2 -L mm_interconnect_1 -L mm_interconnect_0 -L user_module_0 -L altpll_qsys -L sdram -L sgdma -L pcie_ip -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiv_hssi_ver -L cycloneiv_pcie_hip_ver -L cycloneiv_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Compile all the design files and elaborate the top level design
alias ld "
  dev_com
  com
  elab
"

# ----------------------------------------
# Compile all the design files and elaborate the top level design with -dbg -O2
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
  echo "elab_debug                    -- Elaborate the top level design with -dbg -O2 option"
  echo
  echo "ld                            -- Compile all the design files and elaborate the top level design"
  echo
  echo "ld_debug                      -- Compile all the design files and elaborate the top level design with -dbg -O2"
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
