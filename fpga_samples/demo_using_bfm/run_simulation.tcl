# setup variables for simulation script
set system_name      amm_master_qsys_custom_with_bfm
set QSYS_SIMDIR      $system_name/simulation
set TOP_LEVEL_NAME   tb
source $QSYS_SIMDIR/mentor/msim_setup.tcl

# compile system
dev_com
com

# compile testbench and test program
vlog -sv master_example_test.sv
vlog -sv test_program.sv -L altera_avalon_vip_pkgs_lib
vlog -sv tb.sv

# load and run simulation
elab_debug
##do wave.do
run 50ns

# alias to re-compile changes made to test program, load and run simulation
alias rerun {
    vlog -sv master_example.sv:
   vlog -sv test_program.sv -L altera_avalon_vip_pkgs_lib
   elab_debug
   do wave.do
   run 50ns
}

