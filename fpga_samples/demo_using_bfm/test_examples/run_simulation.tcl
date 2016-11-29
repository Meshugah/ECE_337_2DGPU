# setup variables for simulation script
set system_name      avlm_avls_1x1
set QSYS_SIMDIR      $system_name/simulation
set TOP_LEVEL_NAME   tb
source $QSYS_SIMDIR/mentor/msim_setup.tcl

# compile system
dev_com
com

# compile testbench and test program
vlog -sv test_program.sv -L altera_common_sv_packages
vlog -sv tb.sv

# load and run simulation
elab_debug
do wave.do
run 50ns

# alias to re-compile changes made to test program, load and run simulation
alias rerun {
   vlog -sv test_program.sv -L altera_common_sv_packages
   elab_debug
   do wave.do
   run 50ns
}

