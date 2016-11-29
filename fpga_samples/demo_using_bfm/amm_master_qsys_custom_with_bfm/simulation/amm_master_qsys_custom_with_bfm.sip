set_global_assignment -entity "amm_master_qsys_custom_with_bfm" -library "lib_amm_master_qsys_custom_with_bfm" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "amm_master_qsys_custom_with_bfm" -library "lib_amm_master_qsys_custom_with_bfm" -name IP_TOOL_VERSION "13.0sp1"
set_global_assignment -entity "amm_master_qsys_custom_with_bfm" -library "lib_amm_master_qsys_custom_with_bfm" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_amm_master_qsys_custom_with_bfm" -name SPD_FILE [file join $::quartus(sip_path) "../../amm_master_qsys_custom_with_bfm.spd"]
set_global_assignment -library "lib_amm_master_qsys_custom_with_bfm" -name MISC_FILE [file join $::quartus(sip_path) "../../amm_master_qsys_custom_with_bfm.qsys"]

set_global_assignment -library "lib_amm_master_qsys_custom_with_bfm" -name MISC_FILE [file join $::quartus(sip_path) "amm_master_qsys_custom_with_bfm.v"]
set_global_assignment -library "lib_amm_master_qsys_custom_with_bfm" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_controller.v"]
set_global_assignment -library "lib_amm_master_qsys_custom_with_bfm" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_synchronizer.v"]
set_global_assignment -library "lib_amm_master_qsys_custom_with_bfm" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_controller.sdc"]
set_global_assignment -library "lib_amm_master_qsys_custom_with_bfm" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_merlin_slave_translator.sv"]
set_global_assignment -library "lib_amm_master_qsys_custom_with_bfm" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_merlin_master_translator.sv"]
set_global_assignment -library "lib_amm_master_qsys_custom_with_bfm" -name MISC_FILE [file join $::quartus(sip_path) "submodules/custom_master_slave.sv"]
set_global_assignment -library "lib_amm_master_qsys_custom_with_bfm" -name MISC_FILE [file join $::quartus(sip_path) "submodules/verbosity_pkg.sv"]
set_global_assignment -library "lib_amm_master_qsys_custom_with_bfm" -name MISC_FILE [file join $::quartus(sip_path) "submodules/avalon_mm_pkg.sv"]
set_global_assignment -library "lib_amm_master_qsys_custom_with_bfm" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_avalon_mm_slave_bfm.sv"]
set_global_assignment -library "lib_amm_master_qsys_custom_with_bfm" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_avalon_mm_master_bfm.sv"]
