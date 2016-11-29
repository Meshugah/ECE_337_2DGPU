
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

# ACDS 13.0sp1 232 linux 2014.11.18.17:01:40

# ----------------------------------------
# vcs - auto-generated simulation script

# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="amm_master_qsys_with_pcie_tb"
QSYS_SIMDIR="./../../"
QUARTUS_INSTALL_DIR="/package/eda/altera/altera13.0sp1/quartus/"
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
# copy RAM/ROM files to simulation directory
if [ $SKIP_FILE_COPY -eq 0 ]; then
  cp -f $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_reconf_registers.hex ./
fi

vcs -lca -timescale=1ps/1ps -sverilog +verilog2001ext+.v -ntb_opts dtm $USER_DEFINED_ELAB_OPTIONS \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v \
  $QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_hssi_atoms.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_pcie_hip_atoms.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_atoms.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altpcie_pipe_interface.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altpcie_pcie_reconfig_bridge.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_pcie_hard_ip_reset_controller.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altpcie_rs_serdes.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altpcie_pll_100_250.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altpcie_pll_125_250.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_pcie_ip_altgx_internal.vo \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/synopsys/avalon_stif/altpciexpav_stif_a2p_addrtrans.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/synopsys/avalon_stif/altpciexpav_stif_a2p_fixtrans.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/synopsys/avalon_stif/altpciexpav_stif_a2p_vartrans.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/synopsys/avalon_stif/altpciexpav_stif_control_register.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/synopsys/avalon_stif/altpciexpav_stif_cr_avalon.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/synopsys/avalon_stif/altpciexpav_stif_cr_interrupt.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/synopsys/avalon_stif/altpciexpav_stif_cr_mailbox.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/synopsys/avalon_stif/altpciexpav_stif_p2a_addrtrans.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/synopsys/avalon_stif/altpciexpav_stif_reg_fifo.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/synopsys/avalon_stif/altpciexpav_stif_rx.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/synopsys/avalon_stif/altpciexpav_stif_rx_cntrl.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/synopsys/avalon_stif/altpciexpav_stif_rx_resp.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/synopsys/avalon_stif/altpciexpav_stif_tx.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/synopsys/avalon_stif/altpciexpav_stif_tx_cntrl.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/synopsys/avalon_stif/altpciexpav_stif_txavl_cntrl.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/synopsys/avalon_stif/altpciexpav_stif_txresp_cntrl.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/synopsys/avalon_stif/altpciexpav_clksync.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/synopsys/avalon_lite/altpciexpav_lite_app.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altpciexpav_stif_app.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altpcie_hip_pipen1b_qsys.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_irq_mapper.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_avalon_st_handshake_clock_crosser.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_avalon_st_clock_crosser.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_avalon_st_pipeline_base.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_width_adapter.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_address_alignment.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_burst_uncompressor.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_arbitrator.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_rsp_xbar_mux_005.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_rsp_xbar_mux_003.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_rsp_xbar_demux_004.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_rsp_xbar_demux_003.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_rsp_xbar_demux_002.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_mux_004.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_mux_003.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_mux_002.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux_007.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux_006.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux_005.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux_004.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux_003.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux_001.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_rsp_xbar_mux.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_rsp_xbar_demux.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_cmd_xbar_demux.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_reset_controller.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_reset_synchronizer.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_burst_adapter.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_traffic_limiter.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_id_router_004.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_id_router_003.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_id_router_002.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_addr_router_006.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_addr_router_005.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_addr_router_003.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_addr_router_001.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_id_router.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_addr_router.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_avalon_sc_fifo.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_slave_agent.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_master_agent.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_slave_translator.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_merlin_master_translator.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/custom_master.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/burst_write_master.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/burst_read_master.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/write_master.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/latency_aware_read_master.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_reconf_registers.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_altpll_qsys.vo \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_sdram.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_sgdma.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie_pcie_ip.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_pcie_bfm.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_pcie_bfm_components.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altpcietb_bfm_driver.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/verbosity_pkg.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_avalon_reset_source.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/altera_avalon_clock_source.sv \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/submodules/amm_master_qsys_with_pcie.v \
  $QSYS_SIMDIR/amm_master_qsys_with_pcie_tb/simulation/amm_master_qsys_with_pcie_tb.v \
  -top $TOP_LEVEL_NAME
# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  ./simv $USER_DEFINED_SIM_OPTIONS
fi
