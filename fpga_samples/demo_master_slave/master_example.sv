module master_example ( 
	CLOCK_50 , 
	SW , 
	KEY, 
	LEDG, 
	LEDR , 
	// DRAM signals
	DRAM_CLK, 
	DRAM_CKE, 
	DRAM_ADDR ,
	
	DRAM_BA ,
	DRAM_CS_N ,
	DRAM_CAS_N , 
	DRAM_RAS_N , 
	DRAM_WE_N, 
	DRAM_DQ ,
	DRAM_DQM ,
	
	// HEX 7 SEG DISPLAY
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6, 
	HEX7,
	// PCIE signals
	PCIE_PERST_N,
	PCIE_REFCLK_P,
	PCIE_RX_P,
	PCIE_TX_P,
	PCIE_WAKE_N,
	FAN_CTRL

);		
	

input logic  CLOCK_50  ;
input logic [17:0] SW ; 
input logic [3:0] KEY ;
output logic [8:0] LEDG; 
output logic [17:0]LEDR;
output logic [6:0] HEX0;
output logic [6:0] HEX1;
output logic [6:0] HEX2;
output logic [6:0] HEX3;
output logic [6:0] HEX4;
output logic [6:0] HEX5;
output logic [6:0] HEX6;
output logic [6:0] HEX7;

output logic [11:0]DRAM_ADDR;
output logic [1:0]DRAM_BA;
output logic DRAM_CAS_N;
output logic DRAM_CKE;
output logic DRAM_CLK;
output logic DRAM_CS_N;
inout	logic  [31:0] DRAM_DQ;
output logic [3:0] DRAM_DQM;
output logic DRAM_RAS_N;
output logic DRAM_WE_N;
 
inout logic FAN_CTRL;

input logic PCIE_PERST_N;
input logic PCIE_REFCLK_P;
input logic PCIE_RX_P;
output logic PCIE_TX_P;
output logic PCIE_WAKE_N;

//parameter ADDRESSWIDTH = 32 ;
parameter ADDRESSWIDTH = 28;
parameter DATAWIDTH = 32;

logic soc_clk;


logic [31:0] display_data;
/* 
pll pll_inst(
	.inclk0( CLOCK_50) ,
	.c1( temp_vga_clk ) ,
	.c0(DRAM_CLK ) ,	
	.c2( soc_clk) );
*/
	
assign FAN_CTRL = 1'b0;
assign PCIE_WAKE_N = 1'b1;

assign soc_clk = CLOCK_50;


assign DRAM_CLK = CLOCK_50;

	
always_ff @(posedge CLOCK_50) begin
	if(!KEY[0]) begin
		LEDG <= 0; 
	end else begin
	end
end	

//amm_master_qsys amm_master_inst  ( 
 amm_master_qsys_with_pcie amm_master_inst  ( 
 	.clk_clk				(soc_clk),  				  // clk.clk
 	.reset_reset_n				(KEY[0]),                  	          // reset.reset_n
 	.sdram_addr				(DRAM_ADDR),         			  // new_sdram_controller_0_wire.addr
 	.sdram_ba				(DRAM_BA),           			  // ba
 	.sdram_cas_n				(DRAM_CAS_N),        			  // cas_n
 	.sdram_cke				(DRAM_CKE),          			  // cke
 	.sdram_cs_n				(DRAM_CS_N),         			  // cs_n
 	.sdram_dq				(DRAM_DQ),           			  // dq
 	.sdram_dqm				(DRAM_DQM),          			  // dqm
 	.sdram_ras_n				(DRAM_RAS_N),        			  // ras_n
 	.sdram_we_n				(DRAM_WE_N),         			  // we_n 
	.custom_module_conduit_rdwr_cntl	(SW[17]),
	.custom_module_conduit_n_action		(KEY[1]),
	.custom_module_conduit_add_data_sel	(SW[16]),
	.custom_module_conduit_rdwr_address	(SW[15:0]),
	.custom_module_conduit_display_data	(display_data),
 	.pcie_ip_refclk_export           	(PCIE_REFCLK_P),                      // pcie_ip_refclk.export
 	.pcie_ip_pcie_rstn_export        	(PCIE_PERST_N),             	  // pcie_ip_pcie_rstn.export
 	.pcie_ip_rx_in_rx_datain_0       	(PCIE_RX_P),                          // pcie_ip_rx_in.rx_datain_0
 	.pcie_ip_tx_out_tx_dataout_0     	(PCIE_TX_P)                           // pcie_ip_tx_out.tx_dataout_0
 );
 
 
 
 SEG_HEX hex7(
 	   .iDIG(display_data[31:28]),         
 	   .oHEX_D(HEX7)
            );  
 SEG_HEX hex6(                              
            .iDIG(display_data[27:24]),
            .oHEX_D(HEX6)
            );
 SEG_HEX hex5(                           
            .iDIG(display_data[23:20]),
            .oHEX_D(HEX5)
            );
 SEG_HEX hex4(                              
            .iDIG(display_data[19:16]),
            .oHEX_D(HEX4)
            );
 SEG_HEX hex3(                               
            .iDIG(display_data[15:12]),
            .oHEX_D(HEX3)
            );
 SEG_HEX hex2(                          
            .iDIG(display_data[11:8]), 
            .oHEX_D(HEX2)
            );
 SEG_HEX hex1(                      
            .iDIG(display_data[7:4]),
            .oHEX_D(HEX1)
            );
 SEG_HEX hex0(              
            .iDIG(display_data[3:0]) ,
            .oHEX_D(HEX0)
            );

endmodule 
