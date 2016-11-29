
module amm_master_qsys_with_pcie (
	clk_clk,
	reset_reset_n,
	pcie_ip_reconfig_togxb_data,
	pcie_ip_refclk_export,
	pcie_ip_test_in_test_in,
	pcie_ip_pcie_rstn_export,
	pcie_ip_clocks_sim_clk250_export,
	pcie_ip_clocks_sim_clk500_export,
	pcie_ip_clocks_sim_clk125_export,
	pcie_ip_reconfig_busy_busy_altgxb_reconfig,
	pcie_ip_pipe_ext_pipe_mode,
	pcie_ip_pipe_ext_phystatus_ext,
	pcie_ip_pipe_ext_rate_ext,
	pcie_ip_pipe_ext_powerdown_ext,
	pcie_ip_pipe_ext_txdetectrx_ext,
	pcie_ip_pipe_ext_rxelecidle0_ext,
	pcie_ip_pipe_ext_rxdata0_ext,
	pcie_ip_pipe_ext_rxstatus0_ext,
	pcie_ip_pipe_ext_rxvalid0_ext,
	pcie_ip_pipe_ext_rxdatak0_ext,
	pcie_ip_pipe_ext_txdata0_ext,
	pcie_ip_pipe_ext_txdatak0_ext,
	pcie_ip_pipe_ext_rxpolarity0_ext,
	pcie_ip_pipe_ext_txcompl0_ext,
	pcie_ip_pipe_ext_txelecidle0_ext,
	pcie_ip_rx_in_rx_datain_0,
	pcie_ip_tx_out_tx_dataout_0,
	pcie_ip_reconfig_fromgxb_0_data,
	sdram_addr,
	sdram_ba,
	sdram_cas_n,
	sdram_cke,
	sdram_cs_n,
	sdram_dq,
	sdram_dqm,
	sdram_ras_n,
	sdram_we_n,
	altpll_sdram_clk,
	pcie_ip_powerdown_pll_powerdown,
	pcie_ip_powerdown_gxb_powerdown,
	user_module_conduit_rdwr_cntl,
	user_module_conduit_n_action,
	user_module_conduit_add_data_sel,
	user_module_conduit_rdwr_address,
	user_module_conduit_debug_flag,
	user_module_conduit_display_data);	

	input		clk_clk;
	input		reset_reset_n;
	input	[3:0]	pcie_ip_reconfig_togxb_data;
	input		pcie_ip_refclk_export;
	input	[39:0]	pcie_ip_test_in_test_in;
	input		pcie_ip_pcie_rstn_export;
	output		pcie_ip_clocks_sim_clk250_export;
	output		pcie_ip_clocks_sim_clk500_export;
	output		pcie_ip_clocks_sim_clk125_export;
	input		pcie_ip_reconfig_busy_busy_altgxb_reconfig;
	input		pcie_ip_pipe_ext_pipe_mode;
	input		pcie_ip_pipe_ext_phystatus_ext;
	output		pcie_ip_pipe_ext_rate_ext;
	output	[1:0]	pcie_ip_pipe_ext_powerdown_ext;
	output		pcie_ip_pipe_ext_txdetectrx_ext;
	input		pcie_ip_pipe_ext_rxelecidle0_ext;
	input	[7:0]	pcie_ip_pipe_ext_rxdata0_ext;
	input	[2:0]	pcie_ip_pipe_ext_rxstatus0_ext;
	input		pcie_ip_pipe_ext_rxvalid0_ext;
	input		pcie_ip_pipe_ext_rxdatak0_ext;
	output	[7:0]	pcie_ip_pipe_ext_txdata0_ext;
	output		pcie_ip_pipe_ext_txdatak0_ext;
	output		pcie_ip_pipe_ext_rxpolarity0_ext;
	output		pcie_ip_pipe_ext_txcompl0_ext;
	output		pcie_ip_pipe_ext_txelecidle0_ext;
	input		pcie_ip_rx_in_rx_datain_0;
	output		pcie_ip_tx_out_tx_dataout_0;
	output	[4:0]	pcie_ip_reconfig_fromgxb_0_data;
	output	[11:0]	sdram_addr;
	output	[1:0]	sdram_ba;
	output		sdram_cas_n;
	output		sdram_cke;
	output		sdram_cs_n;
	inout	[31:0]	sdram_dq;
	output	[3:0]	sdram_dqm;
	output		sdram_ras_n;
	output		sdram_we_n;
	output		altpll_sdram_clk;
	input		pcie_ip_powerdown_pll_powerdown;
	input		pcie_ip_powerdown_gxb_powerdown;
	input		user_module_conduit_rdwr_cntl;
	input		user_module_conduit_n_action;
	input		user_module_conduit_add_data_sel;
	input	[27:0]	user_module_conduit_rdwr_address;
	output	[15:0]	user_module_conduit_debug_flag;
	output	[31:0]	user_module_conduit_display_data;
endmodule
