module master_example_test (
 input logic clock,
 input logic reset_n,
 input logic rdwr_cntl,
 input logic n_action,
 input logic [26:0] rdwr_address
);

amm_master_qsys_custom_with_bfm u0 (
.clk_clk(clock),
.reset_reset_n (reset_n),
.custom_module_conduit_rdwr_cntl  (rdwr_cntl),
.custom_module_conduit_n_action  (n_action),
.custom_module_conduit_rdwr_address (rdwr_address)
);

endmodule
