
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

# ACDS 13.0sp1 232 linux 2014.11.05.17:16:47

# ----------------------------------------
# vcs - auto-generated simulation script

# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="onchip_ver_qsys_tb"
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
  cp -f $QSYS_SIMDIR/onchip_ver_qsys_tb/simulation/submodules/onchip_ver_qsys_onchip_memory2_0.hex ./
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
  $QSYS_SIMDIR/onchip_ver_qsys_tb/simulation/submodules/altera_reset_controller.v \
  $QSYS_SIMDIR/onchip_ver_qsys_tb/simulation/submodules/altera_reset_synchronizer.v \
  $QSYS_SIMDIR/onchip_ver_qsys_tb/simulation/submodules/altera_merlin_slave_translator.sv \
  $QSYS_SIMDIR/onchip_ver_qsys_tb/simulation/submodules/altera_merlin_master_translator.sv \
  $QSYS_SIMDIR/onchip_ver_qsys_tb/simulation/submodules/onchip_ver_qsys_onchip_memory2_0.v \
  $QSYS_SIMDIR/onchip_ver_qsys_tb/simulation/submodules/custom_master.v \
  $QSYS_SIMDIR/onchip_ver_qsys_tb/simulation/submodules/burst_write_master.v \
  $QSYS_SIMDIR/onchip_ver_qsys_tb/simulation/submodules/burst_read_master.v \
  $QSYS_SIMDIR/onchip_ver_qsys_tb/simulation/submodules/write_master.v \
  $QSYS_SIMDIR/onchip_ver_qsys_tb/simulation/submodules/latency_aware_read_master.v \
  $QSYS_SIMDIR/onchip_ver_qsys_tb/simulation/submodules/verbosity_pkg.sv \
  $QSYS_SIMDIR/onchip_ver_qsys_tb/simulation/submodules/altera_avalon_reset_source.sv \
  $QSYS_SIMDIR/onchip_ver_qsys_tb/simulation/submodules/altera_avalon_clock_source.sv \
  $QSYS_SIMDIR/onchip_ver_qsys_tb/simulation/submodules/onchip_ver_qsys.v \
  $QSYS_SIMDIR/onchip_ver_qsys_tb/simulation/onchip_ver_qsys_tb.v \
  -top $TOP_LEVEL_NAME
# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  ./simv $USER_DEFINED_SIM_OPTIONS
fi
