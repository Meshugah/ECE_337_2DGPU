
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
# vcs - auto-generated simulation script

# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="amm_master_qsys_with_pcie"
QSYS_SIMDIR="./../../"
QUARTUS_INSTALL_DIR="/package/eda/altera/altera14.0/quartus/"
SKIP_FILE_COPY=0
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
# initialize simulation properties - DO NOT MODIFY!
ELAB_OPTIONS=""
SIM_OPTIONS=""
if [[ `vcs -platform` != *"amd64"* ]]; then
  :
else
  :
fi

# ----------------------------------------
# copy RAM/ROM files to simulation directory

vcs -lca -timescale=1ps/1ps -sverilog +verilog2001ext+.v -ntb_opts dtm $ELAB_OPTIONS $USER_DEFINED_ELAB_OPTIONS \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v \
  $QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_hssi_atoms.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_pcie_hip_atoms.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_atoms.v \
  $QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_2_rsp_mux.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_2_rsp_demux.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_2_cmd_mux.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_2_cmd_demux.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_2_router_001.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_2_router.sv \
  $QSYS_SIMDIR/submodules/altera_avalon_st_handshake_clock_crosser.v \
  $QSYS_SIMDIR/submodules/altera_avalon_st_clock_crosser.v \
  $QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_base.v \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_rsp_mux_004.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_rsp_mux_002.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_rsp_mux.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_rsp_demux_001.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_rsp_demux.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_cmd_mux_001.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_cmd_mux.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_cmd_demux_004.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_cmd_demux_003.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_cmd_demux_002.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_cmd_demux.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_router_006.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_router_005.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_router_004.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_router_002.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1_router.sv \
  $QSYS_SIMDIR/submodules/altera_merlin_width_adapter.sv \
  $QSYS_SIMDIR/submodules/altera_merlin_address_alignment.sv \
  $QSYS_SIMDIR/submodules/altera_merlin_burst_uncompressor.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_0_rsp_mux.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_0_rsp_demux.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_0_cmd_mux.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_0_cmd_demux.sv \
  $QSYS_SIMDIR/submodules/altera_merlin_burst_adapter_13_1.sv \
  $QSYS_SIMDIR/submodules/altera_merlin_burst_adapter.sv \
  $QSYS_SIMDIR/submodules/altera_merlin_burst_adapter_new.sv \
  $QSYS_SIMDIR/submodules/altera_wrap_burst_converter.sv \
  $QSYS_SIMDIR/submodules/altera_incr_burst_converter.sv \
  $QSYS_SIMDIR/submodules/altera_default_burst_converter.sv \
  $QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_stage.sv \
  $QSYS_SIMDIR/submodules/altera_merlin_traffic_limiter.sv \
  $QSYS_SIMDIR/submodules/altera_merlin_reorder_memory.sv \
  $QSYS_SIMDIR/submodules/altera_avalon_sc_fifo.v \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_0_router_001.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_0_router.sv \
  $QSYS_SIMDIR/submodules/altera_merlin_slave_agent.sv \
  $QSYS_SIMDIR/submodules/altera_merlin_master_agent.sv \
  $QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv \
  $QSYS_SIMDIR/submodules/altera_merlin_master_translator.sv \
  $QSYS_SIMDIR/submodules/altpcie_pipe_interface.v \
  $QSYS_SIMDIR/submodules/altpcie_pcie_reconfig_bridge.v \
  $QSYS_SIMDIR/submodules/altera_pcie_hard_ip_reset_controller.v \
  $QSYS_SIMDIR/submodules/altpcie_rs_serdes.v \
  $QSYS_SIMDIR/submodules/altpcie_pll_100_250.v \
  $QSYS_SIMDIR/submodules/altpcie_pll_125_250.v \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_pcie_ip_altgx_internal.vo \
  $QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_a2p_addrtrans.v \
  $QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_a2p_fixtrans.v \
  $QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_a2p_vartrans.v \
  $QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_control_register.v \
  $QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_cfg_status.v \
  $QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_cr_avalon.v \
  $QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_cr_interrupt.v \
  $QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_cr_mailbox.v \
  $QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_p2a_addrtrans.v \
  $QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_reg_fifo.v \
  $QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_rx.v \
  $QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_rx_cntrl.v \
  $QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_rx_resp.v \
  $QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_tx.v \
  $QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_tx_cntrl.v \
  $QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_txavl_cntrl.v \
  $QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_stif_txresp_cntrl.v \
  $QSYS_SIMDIR/submodules/synopsys/avalon_stif/altpciexpav_clksync.v \
  $QSYS_SIMDIR/submodules/synopsys/avalon_lite/altpciexpav_lite_app.v \
  $QSYS_SIMDIR/submodules/altpciexpav_stif_app.v \
  $QSYS_SIMDIR/submodules/altpcie_hip_pipen1b_qsys.v \
  $QSYS_SIMDIR/submodules/altera_reset_controller.v \
  $QSYS_SIMDIR/submodules/altera_reset_synchronizer.v \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_irq_mapper.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_2.v \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_1.v \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_mm_interconnect_0.v \
  $QSYS_SIMDIR/submodules/user_module.sv \
  $QSYS_SIMDIR/submodules/arit.sv \
  $QSYS_SIMDIR/submodules/controlunit.sv \
  $QSYS_SIMDIR/submodules/flex_counter.sv \
  $QSYS_SIMDIR/submodules/ImageSpecRegs.sv \
  $QSYS_SIMDIR/submodules/memory_cntrl.sv \
  $QSYS_SIMDIR/submodules/outputlogic.sv \
  $QSYS_SIMDIR/submodules/readCounter.sv \
  $QSYS_SIMDIR/submodules/shift_register.sv \
  $QSYS_SIMDIR/submodules/startdecoder.sv \
  $QSYS_SIMDIR/submodules/top_levelu.sv \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_altpll_qsys.vo \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_sdram.v \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_sgdma.v \
  $QSYS_SIMDIR/submodules/amm_master_qsys_with_pcie_pcie_ip.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie.v \
  -top $TOP_LEVEL_NAME
# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  ./simv $SIM_OPTIONS $USER_DEFINED_SIM_OPTIONS
fi
