create_clock -name "clock_50_1" -period 20.000ns [get_ports {CLOCK_50}]

create_clock -name "pcie_ref_clk" -period 10.000ns [get_ports {PCIE_REFCLK_P}]
set_clock_groups -exclusive -group [get_clocks { *central_clk_div0* }] -group [get_clocks { *_hssi_pcie_hip* }]
set_clock_groups -exclusive -group [get_clocks { refclk*clkout }] -group [get_clocks { *div0*coreclkout}]

derive_pll_clocks

derive_clock_uncertainty
