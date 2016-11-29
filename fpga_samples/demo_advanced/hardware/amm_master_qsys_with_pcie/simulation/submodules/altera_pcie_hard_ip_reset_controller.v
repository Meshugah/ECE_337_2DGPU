// (C) 2001-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



//Copyright (C) 1991-2011 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions
//and other software and tools, and its AMPP partner logic
//functions, and any output files from any of the foregoing
//(including device programming or simulation files), and any
//associated documentation or information are expressly subject
//to the terms and conditions of the Altera Program License
//Subscription Agreement, Altera MegaCore Function License
//Agreement, or other applicable license agreement, including,
//without limitation, that your use is for the sole purpose of
//programming logic devices manufactured by Altera and sold by
//Altera or its authorized distributors.  Please refer to the
//applicable agreement for further details.
//
//
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on

module altera_pcie_hard_ip_reset_controller

#(   
     parameter              link_width = 4,
     parameter              cyclone4 = 0
  )


 (
   input pld_clk,

   input pcie_rstn,   // npor
   input [39:0]   test_in,
   input [4:0]    ltssm,
   input pll_locked,
   input busy_altgxb_reconfig,      
    output reg    srst,  
    output reg    crst, 
   input         l2_exit,
   input         hotrst_exit,
   input         dlup_exit,
   output        reset_n_out,
   
   input [link_width-1:0] rx_pll_locked,
   input [link_width-1:0] rx_freqlocked,
    input [link_width-1:0]  rx_signaldetect,
   input rc_inclk_eq_125mhz,

   output txdigitalreset,
   output rxanalogreset,
   output rx_digitalreset_serdes,
   
   input         refclk,
   output        clk250_out,
   output        clk500_out,
   output        clk250_export,
   output        clk500_export,       
   output        clk125_export
);


  wire             reset_n;
  wire             npor;
  reg     [ 10: 0] rsnt_cntn;
  reg     [4:0] ltssm_reg;
  reg              reset_n_rr; /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R102"  */
  reg              reset_n_r;  /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R102"  */
  reg     [  4: 0] dl_ltssm_r;
  reg              dlup_exit_r;
  reg              exits_r;
  reg              hotrst_exit_r;
  reg              l2_exit_r;
  reg              app_rstn;
  reg              app_rstn0;
  reg              srst0;
  reg              crst0;
  wire             test_sim;
  wire [7:0] rx_pll_locked_8;   
  wire [7:0] rx_freqlocked_8;    
  wire [7:0] rx_signaldetect_8;
  wire use_c4gx_serdes;
  wire             otb0;
  wire             otb1;
  assign otb0 = 1'b0;
  assign otb1 = 1'b1;
  assign test_sim = 1'b1;
 //pipe line exit conditions
  always @(posedge pld_clk or negedge reset_n_rr)
    begin
      if (reset_n_rr == 0)
        begin
          dlup_exit_r <= otb1;
          hotrst_exit_r <= otb1;
          l2_exit_r <= otb1;
          exits_r <= otb0;
        end
      else 
        begin
          dlup_exit_r <= dlup_exit;
          hotrst_exit_r <= hotrst_exit;
          l2_exit_r <= l2_exit;
          exits_r <= (l2_exit_r == 1'b0) | (hotrst_exit_r == 1'b0) | (dlup_exit_r == 1'b0) | (dl_ltssm_r == 5'h10);
        end
    end

  //LTSSM pipeline
  always @(posedge pld_clk or negedge reset_n_rr)
    begin
      if (reset_n_rr == 0)
          dl_ltssm_r <= 0;
      else 
        dl_ltssm_r <= ltssm;
    end

assign rx_pll_locked_8  	= {{(8-link_width){1'b1}}, rx_pll_locked[link_width-1:0]};    
assign rx_freqlocked_8  	= {{(8-link_width){1'b1}}, rx_freqlocked[link_width-1:0]};       
assign rx_signaldetect_8 	= {{(8-link_width){1'b0}}, rx_signaldetect[link_width-1:0]};   

   
    assign npor = pcie_rstn;

    generate if (cyclone4 == 1)
         assign use_c4gx_serdes = 1'b1;
     else 
        assign use_c4gx_serdes = 1'b0;
    endgenerate


 assign reset_n_out = app_rstn;
 assign reset_n = npor;
    
  //reset counter
  always @(posedge pld_clk or negedge reset_n_rr)
    begin
      if (reset_n_rr == 0)
          rsnt_cntn <= 0;
      else if (exits_r == 1'b1)
          rsnt_cntn <= 11'h3f0;
      else if (rsnt_cntn != 11'd1024)
          rsnt_cntn <= rsnt_cntn + 1;
    end
    
    
   //sync and config reset
  always @(posedge pld_clk or negedge reset_n_rr)
    begin
      if (reset_n_rr == 0)
        begin
          app_rstn0 <= 0;
          srst0 <= 1;
          crst0 <= 1;
        end
      else if (exits_r == 1'b1)
        begin
          srst0 <= 1;
          crst0 <= 1;
          app_rstn0 <= 0;
        end
      else // synthesis translate_off
      if ((test_sim == 1'b1) & (rsnt_cntn >= 11'd32))
        begin
          srst0 <= 0;
          crst0 <= 0;
          app_rstn0 <= 1;
        end
      else // synthesis translate_on
      if (rsnt_cntn == 11'd1024)
        begin
          srst0 <= 0;
          crst0 <= 0;
          app_rstn0 <= 1;
        end
    end
   //reset Synchronizer to PCIe clock
  always @(posedge pld_clk or negedge reset_n)
    begin
      if (reset_n == 0)
        begin
          reset_n_r <= 0;
          reset_n_rr <= 0;
        end
      else 
        begin
          reset_n_r <= 1;
          reset_n_rr <= reset_n_r;
        end
    end

 //sync and config reset pipeline
  always @(posedge pld_clk or negedge reset_n_rr)
    begin
      if (reset_n_rr == 0)
        begin
          app_rstn <= 0;
          srst <= 1;
          crst <= 1;
        end
      else 
        begin
          app_rstn <= app_rstn0;
          srst <= srst0;
          crst <= crst0;
        end
    end



/// Instantiate the reset controller 

altpcie_rs_serdes altgx_reset(
   .pld_clk(pld_clk),
   .test_in(test_in),
   .ltssm(ltssm),
   .npor(pcie_rstn),
   .pll_locked(pll_locked),
   .busy_altgxb_reconfig(busy_altgxb_reconfig),
   .rx_pll_locked(rx_pll_locked_8),
   .rx_freqlocked(rx_freqlocked_8),
   .rx_signaldetect(rx_signaldetect_8),
   .use_c4gx_serdes(use_c4gx_serdes),
   .fifo_err(1'b0),
   .rc_inclk_eq_125mhz(rc_inclk_eq_125mhz),
   .txdigitalreset(txdigitalreset),
   .rxanalogreset(rxanalogreset),
   .rxdigitalreset(rx_digitalreset_serdes),
   .detect_mask_rxdrst(1'b0)
);


//////////////// SIMULATION-ONLY CONTENTS
//synthesis translate_off
  altpcie_pll_100_250 refclk_to_250mhz
    (
      .areset (1'b0),
      .c0 (clk250_out),
      .inclk0 (refclk)
    );


  altpcie_pll_125_250 pll_250mhz_to_500mhz
    (
      .areset (1'b0),
      .c0 (clk500_out),
      .inclk0 (clk250_out)
    );

//synthesis translate_on
//synthesis read_comments_as_HDL on
//  assign pipe_mode_int = 0;
//synthesis read_comments_as_HDL off    

 assign clk250_export = clk250_out;
 assign  clk500_export = clk500_out;



endmodule
