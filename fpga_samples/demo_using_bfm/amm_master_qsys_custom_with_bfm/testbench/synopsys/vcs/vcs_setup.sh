
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

# ACDS 13.0sp1 232 linux 2015.04.20.18:00:08

# ----------------------------------------
# vcs - auto-generated simulation script

# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="amm_master_qsys_custom_with_bfm_tb"
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

vcs -lca -timescale=1ps/1ps -sverilog +verilog2001ext+.v -ntb_opts dtm $USER_DEFINED_ELAB_OPTIONS \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v \
  $QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_hssi_atoms.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_pcie_hip_atoms.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_atoms.v \
  $QSYS_SIMDIR/amm_master_qsys_custom_with_bfm_tb/simulation/submodules/altera_reset_controller.v \
  $QSYS_SIMDIR/amm_master_qsys_custom_with_bfm_tb/simulation/submodules/altera_reset_synchronizer.v \
  $QSYS_SIMDIR/amm_master_qsys_custom_with_bfm_tb/simulation/submodules/altera_merlin_slave_translator.sv \
  $QSYS_SIMDIR/amm_master_qsys_custom_with_bfm_tb/simulation/submodules/altera_merlin_master_translator.sv \
  $QSYS_SIMDIR/amm_master_qsys_custom_with_bfm_tb/simulation/submodules/custom_master_slave.sv \
  $QSYS_SIMDIR/amm_master_qsys_custom_with_bfm_tb/simulation/submodules/verbosity_pkg.sv \
  $QSYS_SIMDIR/amm_master_qsys_custom_with_bfm_tb/simulation/submodules/avalon_mm_pkg.sv \
  $QSYS_SIMDIR/amm_master_qsys_custom_with_bfm_tb/simulation/submodules/altera_avalon_mm_slave_bfm.sv \
  $QSYS_SIMDIR/amm_master_qsys_custom_with_bfm_tb/simulation/submodules/altera_avalon_mm_master_bfm.sv \
  $QSYS_SIMDIR/amm_master_qsys_custom_with_bfm_tb/simulation/submodules/altera_conduit_bfm.sv \
  $QSYS_SIMDIR/amm_master_qsys_custom_with_bfm_tb/simulation/submodules/altera_avalon_reset_source.sv \
  $QSYS_SIMDIR/amm_master_qsys_custom_with_bfm_tb/simulation/submodules/altera_avalon_clock_source.sv \
  $QSYS_SIMDIR/amm_master_qsys_custom_with_bfm_tb/simulation/submodules/amm_master_qsys_custom_with_bfm.v \
  $QSYS_SIMDIR/amm_master_qsys_custom_with_bfm_tb/simulation/amm_master_qsys_custom_with_bfm_tb.v \
  -top $TOP_LEVEL_NAME
# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  ./simv $USER_DEFINED_SIM_OPTIONS
fi
