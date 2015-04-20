
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

# ACDS 13.0sp1 232 linux 2015.04.20.11:04:21

# ----------------------------------------
# vcsmx - auto-generated simulation script

# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="amm_master_qsys_with_pcie"
QSYS_SIMDIR="./../../"
QUARTUS_INSTALL_DIR="/package/eda/altera/altera13.0sp1/quartus/"
SKIP_FILE_COPY=0
SKIP_DEV_COM=0
SKIP_COM=0
SKIP_ELAB=0
SKIP_SIM=0
USER_DEFINED_ELAB_OPTIONS=""
USER_DEFINED_SIM_OPTIONS="+vcs+finish+100"

# ----------------------------------------
# overwrite variables - DO NOT MODIFY!
# This block evaluates each command line argument, typically used for 
# overwriting variables. An example usage:
#   sh <simulator>_setup.sh SKIP_ELAB=1 SKIP_SIM=1
for expression in "$@"; do
  eval $expression
  if [ $? -ne 0 ]; then
    echo "Error: This command line argument, \"$expression\", is/has an invalid expression." >&2
    exit $?
  fi
done

# ----------------------------------------
# create compilation libraries
mkdir -p ./libraries/work/
mkdir -p ./libraries/pipe_interface_internal/
mkdir -p ./libraries/reset_controller_internal/
mkdir -p ./libraries/altgx_internal/
mkdir -p ./libraries/pcie_internal_hip/
mkdir -p ./libraries/irq_mapper/
mkdir -p ./libraries/crosser/
mkdir -p ./libraries/width_adapter/
mkdir -p ./libraries/cmd_xbar_demux_006/
mkdir -p ./libraries/rsp_xbar_mux_003/
mkdir -p ./libraries/rsp_xbar_demux_003/
mkdir -p ./libraries/rsp_xbar_demux_002/
mkdir -p ./libraries/cmd_xbar_mux_003/
mkdir -p ./libraries/cmd_xbar_mux_002/
mkdir -p ./libraries/cmd_xbar_demux_004/
mkdir -p ./libraries/cmd_xbar_demux_003/
mkdir -p ./libraries/cmd_xbar_demux_001/
mkdir -p ./libraries/rsp_xbar_mux/
mkdir -p ./libraries/rsp_xbar_demux/
mkdir -p ./libraries/cmd_xbar_demux/
mkdir -p ./libraries/rst_controller/
mkdir -p ./libraries/burst_adapter/
mkdir -p ./libraries/limiter/
mkdir -p ./libraries/id_router_004/
mkdir -p ./libraries/addr_router_006/
mkdir -p ./libraries/id_router_003/
mkdir -p ./libraries/id_router_002/
mkdir -p ./libraries/addr_router_005/
mkdir -p ./libraries/addr_router_003/
mkdir -p ./libraries/addr_router_001/
mkdir -p ./libraries/id_router/
mkdir -p ./libraries/addr_router/
mkdir -p ./libraries/sgdma_csr_translator_avalon_universal_slave_0_agent_rsp_fifo/
mkdir -p ./libraries/sgdma_csr_translator_avalon_universal_slave_0_agent/
mkdir -p ./libraries/pcie_ip_bar2_translator_avalon_universal_master_0_agent/
mkdir -p ./libraries/sgdma_csr_translator/
mkdir -p ./libraries/pcie_ip_bar2_translator/
mkdir -p ./libraries/custom_module/
mkdir -p ./libraries/altpll_qsys/
mkdir -p ./libraries/sdram/
mkdir -p ./libraries/sgdma/
mkdir -p ./libraries/pcie_ip/
mkdir -p ./libraries/altera_ver/
mkdir -p ./libraries/lpm_ver/
mkdir -p ./libraries/sgate_ver/
mkdir -p ./libraries/altera_mf_ver/
mkdir -p ./libraries/altera_lnsim_ver/
mkdir -p ./libraries/cycloneiv_hssi_ver/
mkdir -p ./libraries/cycloneiv_pcie_hip_ver/
mkdir -p ./libraries/cycloneiv_ver/

# ----------------------------------------
# copy RAM/ROM files to simulation directory

# ----------------------------------------
# compile device library files
if [ $SKIP_DEV_COM -eq 0 ]; then
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"        -work altera_ver            
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                 -work lpm_ver               
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                    -work sgate_ver             
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                -work altera_mf_ver         
  vlogan +v2k -sverilog "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"            -work altera_lnsim_ver      
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_hssi_atoms.v"     -work cycloneiv_hssi_ver    
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_pcie_hip_atoms.v" -work cycloneiv_pcie_hip_ver
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_atoms.v"          -work cycloneiv_ver         
fi

# ----------------------------------------
# compile design files in correct order
if [ $SKIP_COM -eq 0 ]; then
  vlogan +v2k           "$QSYS_SIMDIR/submodules/altpcie_pipe_interface.v"                                 -work pipe_interface_internal                                     
  vlogan +v2k           "$QSYS_SIMDIR/submodules/altpcie_pcie_reconfig_bridge.v"                           -work pipe_interface_internal                                     
  vlogan +v2k           "$QSYS_SIMDIR/submodules/altera_pcie_hard_ip_reset_controller.v"                   -work reset_controller_internal                                   
  vlogan +v2k           "$QSYS_SIMDIR/submodules/altpcie_rs_serdes.v"                                      -work reset_controller_internal                                   
  vlogan +v2k           "$QSYS_SIMDIR/submodules/altpcie_pll_100_250.v"                                    -work reset_controller_internal                                   
  vlogan +v2k           "$QSYS_SIMDIR/submodules/altpcie_pll_125_250.v"                                    -work reset_controller_internal                                   
  vlogan +v2k           "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_pcie_ip_altgx_internal.vo"      -work altgx_internal                                              
  vlogan +v2k           "$QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_a2p_addrtrans.v"    -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_a2p_fixtrans.v"     -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_a2p_vartrans.v"     -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_control_register.v" -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_cr_avalon.v"        -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_cr_interrupt.v"     -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_cr_mailbox.v"       -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_p2a_addrtrans.v"    -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_reg_fifo.v"         -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_rx.v"               -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_rx_cntrl.v"         -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_rx_resp.v"          -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_tx.v"               -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_tx_cntrl.v"         -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_txavl_cntrl.v"      -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_txresp_cntrl.v"     -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_clksync.v"               -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/synopsys/avalon_lite/altpciexpav_lite_app.v"              -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/altpciexpav_stif_app.v"                                   -work pcie_internal_hip                                           
  vlogan +v2k           "$QSYS_SIMDIR/submodules/altpcie_hip_pipen1b_qsys.v"                               -work pcie_internal_hip                                           
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_irq_mapper.sv"                  -work irq_mapper                                                  
  vlogan +v2k           "$QSYS_SIMDIR/submodules/altera_avalon_st_handshake_clock_crosser.v"               -work crosser                                                     
  vlogan +v2k           "$QSYS_SIMDIR/submodules/altera_avalon_st_clock_crosser.v"                         -work crosser                                                     
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_base.v"                         -work crosser                                                     
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/altera_merlin_width_adapter.sv"                           -work width_adapter                                               
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/altera_merlin_address_alignment.sv"                       -work width_adapter                                               
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/altera_merlin_burst_uncompressor.sv"                      -work width_adapter                                               
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux_006.sv"          -work cmd_xbar_demux_006                                          
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                              -work rsp_xbar_mux_003                                            
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_rsp_xbar_mux_003.sv"            -work rsp_xbar_mux_003                                            
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_rsp_xbar_demux_003.sv"          -work rsp_xbar_demux_003                                          
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_rsp_xbar_demux_002.sv"          -work rsp_xbar_demux_002                                          
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                              -work cmd_xbar_mux_003                                            
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_cmd_xbar_mux_003.sv"            -work cmd_xbar_mux_003                                            
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                              -work cmd_xbar_mux_002                                            
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_cmd_xbar_mux_002.sv"            -work cmd_xbar_mux_002                                            
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux_004.sv"          -work cmd_xbar_demux_004                                          
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux_003.sv"          -work cmd_xbar_demux_003                                          
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux_001.sv"          -work cmd_xbar_demux_001                                          
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                              -work rsp_xbar_mux                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_rsp_xbar_mux.sv"                -work rsp_xbar_mux                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_rsp_xbar_demux.sv"              -work rsp_xbar_demux                                              
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux.sv"              -work cmd_xbar_demux                                              
  vlogan +v2k           "$QSYS_SIMDIR/submodules/altera_reset_controller.v"                                -work rst_controller                                              
  vlogan +v2k           "$QSYS_SIMDIR/submodules/altera_reset_synchronizer.v"                              -work rst_controller                                              
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/altera_merlin_burst_adapter.sv"                           -work burst_adapter                                               
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/altera_merlin_address_alignment.sv"                       -work burst_adapter                                               
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/altera_merlin_traffic_limiter.sv"                         -work limiter                                                     
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_base.v"                         -work limiter                                                     
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_id_router_004.sv"               -work id_router_004                                               
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_addr_router_006.sv"             -work addr_router_006                                             
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_id_router_003.sv"               -work id_router_003                                               
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_id_router_002.sv"               -work id_router_002                                               
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_addr_router_005.sv"             -work addr_router_005                                             
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_addr_router_003.sv"             -work addr_router_003                                             
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_addr_router_001.sv"             -work addr_router_001                                             
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_id_router.sv"                   -work id_router                                                   
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_addr_router.sv"                 -work addr_router                                                 
  vlogan +v2k           "$QSYS_SIMDIR/submodules/altera_avalon_sc_fifo.v"                                  -work sgdma_csr_translator_avalon_universal_slave_0_agent_rsp_fifo
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/altera_merlin_slave_agent.sv"                             -work sgdma_csr_translator_avalon_universal_slave_0_agent         
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/altera_merlin_burst_uncompressor.sv"                      -work sgdma_csr_translator_avalon_universal_slave_0_agent         
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/altera_merlin_master_agent.sv"                            -work pcie_ip_bar2_translator_avalon_universal_master_0_agent     
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv"                        -work sgdma_csr_translator                                        
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/altera_merlin_master_translator.sv"                       -work pcie_ip_bar2_translator                                     
  vlogan +v2k -sverilog "$QSYS_SIMDIR/submodules/custom_master_slave.sv"                                   -work custom_module                                               
  vlogan +v2k           "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_altpll_qsys.vo"                 -work altpll_qsys                                                 
  vlogan +v2k           "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_sdram.v"                        -work sdram                                                       
  vlogan +v2k           "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_sgdma.v"                        -work sgdma                                                       
  vlogan +v2k           "$QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_pcie_ip.v"                      -work pcie_ip                                                     
  vlogan +v2k           "$QSYS_SIMDIR/amm_master_qsys_with_pcie.v"                                                                                                           
fi

# ----------------------------------------
# elaborate top level design
if [ $SKIP_ELAB -eq 0 ]; then
  vcs -lca -t ps $USER_DEFINED_ELAB_OPTIONS $TOP_LEVEL_NAME
fi

# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  ./simv $USER_DEFINED_SIM_OPTIONS
fi
