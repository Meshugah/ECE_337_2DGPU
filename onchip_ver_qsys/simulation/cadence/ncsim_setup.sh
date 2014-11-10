
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

# ACDS 13.0sp1 232 linux 2014.11.05.17:16:24

# ----------------------------------------
# ncsim - auto-generated simulation script

# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="onchip_ver_qsys"
QSYS_SIMDIR="./../"
QUARTUS_INSTALL_DIR="/package/eda/altera/altera13.0sp1/quartus/"
SKIP_FILE_COPY=0
SKIP_DEV_COM=0
SKIP_COM=0
SKIP_ELAB=0
SKIP_SIM=0
USER_DEFINED_ELAB_OPTIONS=""
USER_DEFINED_SIM_OPTIONS="-input \"@run 100; exit\""

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
mkdir -p ./libraries/rst_controller/
mkdir -p ./libraries/onchip_memory2_0_s1_translator/
mkdir -p ./libraries/read_master_avalon_master_translator/
mkdir -p ./libraries/onchip_memory2_0/
mkdir -p ./libraries/write_master/
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
if [ $SKIP_FILE_COPY -eq 0 ]; then
  cp -f $QSYS_SIMDIR/submodules/onchip_ver_qsys_onchip_memory2_0.hex ./
fi

# ----------------------------------------
# compile device library files
if [ $SKIP_DEV_COM -eq 0 ]; then
  ncvlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"        -work altera_ver            
  ncvlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                 -work lpm_ver               
  ncvlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                    -work sgate_ver             
  ncvlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                -work altera_mf_ver         
  ncvlog -sv "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"            -work altera_lnsim_ver      
  ncvlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_hssi_atoms.v"     -work cycloneiv_hssi_ver    
  ncvlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_pcie_hip_atoms.v" -work cycloneiv_pcie_hip_ver
  ncvlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneiv_atoms.v"          -work cycloneiv_ver         
fi

# ----------------------------------------
# compile design files in correct order
if [ $SKIP_COM -eq 0 ]; then
  ncvlog     "$QSYS_SIMDIR/submodules/altera_reset_controller.v"          -work rst_controller                       -cdslib ./cds_libs/rst_controller.cds.lib                      
  ncvlog     "$QSYS_SIMDIR/submodules/altera_reset_synchronizer.v"        -work rst_controller                       -cdslib ./cds_libs/rst_controller.cds.lib                      
  ncvlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv"  -work onchip_memory2_0_s1_translator       -cdslib ./cds_libs/onchip_memory2_0_s1_translator.cds.lib      
  ncvlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_master_translator.sv" -work read_master_avalon_master_translator -cdslib ./cds_libs/read_master_avalon_master_translator.cds.lib
  ncvlog     "$QSYS_SIMDIR/submodules/onchip_ver_qsys_onchip_memory2_0.v" -work onchip_memory2_0                     -cdslib ./cds_libs/onchip_memory2_0.cds.lib                    
  ncvlog     "$QSYS_SIMDIR/submodules/custom_master.v"                    -work write_master                         -cdslib ./cds_libs/write_master.cds.lib                        
  ncvlog     "$QSYS_SIMDIR/submodules/burst_write_master.v"               -work write_master                         -cdslib ./cds_libs/write_master.cds.lib                        
  ncvlog     "$QSYS_SIMDIR/submodules/burst_read_master.v"                -work write_master                         -cdslib ./cds_libs/write_master.cds.lib                        
  ncvlog     "$QSYS_SIMDIR/submodules/write_master.v"                     -work write_master                         -cdslib ./cds_libs/write_master.cds.lib                        
  ncvlog     "$QSYS_SIMDIR/submodules/latency_aware_read_master.v"        -work write_master                         -cdslib ./cds_libs/write_master.cds.lib                        
  ncvlog     "$QSYS_SIMDIR/onchip_ver_qsys.v"                                                                                                                                       
fi

# ----------------------------------------
# elaborate top level design
if [ $SKIP_ELAB -eq 0 ]; then
  ncelab -access +w+r+c -namemap_mixgen $USER_DEFINED_ELAB_OPTIONS $TOP_LEVEL_NAME
fi

# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  eval ncsim -licqueue $USER_DEFINED_SIM_OPTIONS $TOP_LEVEL_NAME
fi
