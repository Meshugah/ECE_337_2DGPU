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


// (C) 2001-2010 Altera Corporation. All rights reserved.
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


module altpcie_pipe_interface
#(   
     parameter              max_link_width = 4,
     parameter              gen2_lane_rate_mode= "false",
     parameter              p_pcie_hip_type = "0"
  )

 (
       input                            pipe_mode, 
       input                            pcie_rstn,    
       output                           rc_areset,                                                    
       input  [7:0]                     rxdata0_ext,                                                       
       input  [7:0]                     rxdata1_ext,                                                       
       input  [7:0]                     rxdata2_ext,                                                       
       input  [7:0]                     rxdata3_ext,   
       input  [7:0]                     rxdata4_ext,                                                       
       input  [7:0]                     rxdata5_ext,                                                       
       input  [7:0]                     rxdata6_ext,                                                       
       input  [7:0]                     rxdata7_ext,                                                     
       input  [max_link_width*8-1:0]    rxdata_pcs,                                                        
       output [max_link_width*8-1:0]    rxdata_hip,                                                        
                                                                                                           
       input                            phystatus_ext,                                                     
       input  [max_link_width-1:0]      phystatus_pcs,                                                     
       output  [max_link_width-1:0]     phystatus_hip,      //##                                                                                              
                                                                                                           
       input                           rxelecidle0_ext,                                                    
       input                           rxelecidle1_ext,                                                    
       input                           rxelecidle2_ext,                                                    
       input                           rxelecidle3_ext,  
       input                           rxelecidle4_ext,                                                    
       input                           rxelecidle5_ext,                                                    
       input                           rxelecidle6_ext,                                                    
       input                           rxelecidle7_ext,                                                  
       input [max_link_width-1:0]      rxelecidle_pcs,   
       output [max_link_width-1:0]     rxelecidle_hip,     //                                          
                                                                                                           
       input                           rxvalid0_ext,                                                       
       input                           rxvalid1_ext,                                                       
       input                           rxvalid2_ext,                                                       
       input                           rxvalid3_ext,     
        input                          rxvalid4_ext,                                                       
       input                           rxvalid5_ext,                                                       
       input                           rxvalid6_ext,                                                       
       input                           rxvalid7_ext,                                                  
       input [max_link_width-1:0]      rxvalid_pcs,   
       output [max_link_width-1:0]     rxvalid_hip,   //                                                
                                                                                                           
       input [7:0]                     txdata0_hip,                                                        
       input [7:0]                     txdata1_hip,                                                        
       input [7:0]                     txdata2_hip,                                                        
       input [7:0]                     txdata3_hip,   
       input [7:0]                     txdata4_hip,                                                        
       input [7:0]                     txdata5_hip,                                                        
       input [7:0]                     txdata6_hip,                                                        
       input [7:0]                     txdata7_hip,                                                     
       output [max_link_width*8-1:0]   txdata_pcs,                                                         
       output [7:0]                    txdata0_ext,                                                        
       output [7:0]                    txdata1_ext,                                                        
       output [7:0]                    txdata2_ext,                                                        
       output [7:0]                    txdata3_ext,  
       output [7:0]                    txdata4_ext,                                                        
       output [7:0]                    txdata5_ext,                                                        
       output [7:0]                    txdata6_ext,                                                        
       output [7:0]                    txdata7_ext,                                                      
                                                                                                           
       input                           rxdatak0_ext,                                                       
       input                           rxdatak1_ext,                                                       
       input                           rxdatak2_ext,                                                       
       input                           rxdatak3_ext,    
       input                           rxdatak4_ext,                                                       
       input                           rxdatak5_ext,                                                       
       input                           rxdatak6_ext,                                                       
       input                           rxdatak7_ext,                                                   
       input  [max_link_width-1:0]     rxdatak_pcs,                                                        
       output [max_link_width-1:0]     rxdatak_hip,                                                        
                                                                                                           
       input [2:0]                     rxstatus0_ext,                                                      
       input [2:0]                     rxstatus1_ext,                                                      
       input [2:0]                     rxstatus2_ext,                                                      
       input [2:0]                     rxstatus3_ext,   
       input [2:0]                     rxstatus4_ext,                                                      
       input [2:0]                     rxstatus5_ext,                                                      
       input [2:0]                     rxstatus6_ext,                                                      
       input [2:0]                     rxstatus7_ext,                                                   
       input [max_link_width*3-1:0]    rxstatus_pcs,                                                       
       output [max_link_width*3-1:0]   rxstatus_hip,                                                       
                                                                                                           
       input [1:0]                     powerdown0_hip,                                                     
       input [1:0]                     powerdown1_hip,                                                     
       input [1:0]                     powerdown2_hip,                                                     
       input [1:0]                     powerdown3_hip,      
       input [1:0]                     powerdown4_hip,                                                     
       input [1:0]                     powerdown5_hip,                                                     
       input [1:0]                     powerdown6_hip,                                                     
       input [1:0]                     powerdown7_hip,                                               
       output [max_link_width*2-1:0]   powerdown_pcs,                                                    
       output [1:0]                    powerdown_ext,                                                     
                                                                                                           
       input                           rxpolarity0_hip,                                                    
       input                           rxpolarity1_hip,                                                    
       input                           rxpolarity2_hip,                                                    
       input                           rxpolarity3_hip, 
        input                          rxpolarity4_hip,                                                    
       input                           rxpolarity5_hip,                                                    
       input                           rxpolarity6_hip,                                                    
       input                           rxpolarity7_hip, 
                                                          
       output [max_link_width-1:0]     rxpolarity_pcs, 
                                                            
       output                          rxpolarity0_ext,                                                    
       output                          rxpolarity1_ext,                                                    
       output                          rxpolarity2_ext,                                                    
       output                          rxpolarity3_ext,  
       output                          rxpolarity4_ext,                                                    
       output                          rxpolarity5_ext,                                                    
       output                          rxpolarity6_ext,                                                    
       output                          rxpolarity7_ext,                                                  
                                                                                                           
       input                           txcompl0_hip,                                                       
       input                           txcompl1_hip,                                                       
       input                           txcompl2_hip,                                                       
       input                           txcompl3_hip, 
       input                           txcompl4_hip,                                                       
       input                           txcompl5_hip,                                                       
       input                           txcompl6_hip,                                                       
       input                           txcompl7_hip,
                                                             
       output [max_link_width-1:0]     txcompl_pcs, 
                                                               
       output                          txcompl0_ext,                                                       
       output                          txcompl1_ext,                                                       
       output                          txcompl2_ext,                                                       
       output                          txcompl3_ext,  
       output                          txcompl4_ext,                                                       
       output                          txcompl5_ext,                                                       
       output                          txcompl6_ext,                                                       
       output                          txcompl7_ext,                                                      
                                                                                                           
       input                           txdatak0_hip,                                                       
       input                           txdatak1_hip,                                                       
       input                           txdatak2_hip,                                                       
       input                           txdatak3_hip,  
       input                           txdatak4_hip,                                                       
       input                           txdatak5_hip,                                                       
       input                           txdatak6_hip,                                                       
       input                           txdatak7_hip,
                                                            
       output [max_link_width-1:0]     txdatak_pcs,  
                                                              
       output                          txdatak0_ext,                                                       
       output                          txdatak1_ext,                                                       
       output                          txdatak2_ext,                                                       
       output                          txdatak3_ext,        
       output                          txdatak4_ext,                                                       
       output                          txdatak5_ext,                                                       
       output                          txdatak6_ext,                                                       
       output                          txdatak7_ext,                                               
                                                                                                           
       input                           txdetectrx0_hip,                                                    
       input                           txdetectrx1_hip,                                                    
       input                           txdetectrx2_hip,                                                    
       input                           txdetectrx3_hip, 
       input                           txdetectrx4_hip,                                                    
       input                           txdetectrx5_hip,                                                    
       input                           txdetectrx6_hip,                                                    
       input                           txdetectrx7_hip,
                                                          
       output [max_link_width-1:0]     txdetectrx_pcs,                                                      
       output                          txdetectrx_ext,                                                    
                                                                                                           
       input                           txelecidle0_hip,                                                    
       input                           txelecidle1_hip,                                                    
       input                           txelecidle2_hip,                                                    
       input                           txelecidle3_hip, 
       input                           txelecidle4_hip,                                                    
       input                           txelecidle5_hip,                                                    
       input                           txelecidle6_hip,                                                    
       input                           txelecidle7_hip, 
                                                          
       output [max_link_width-1:0]     txelecidle_pcs,    
                                                         
       output                          txelecidle0_ext,                                                    
       output                          txelecidle1_ext,                                                    
       output                          txelecidle2_ext,                                                    
       output                          txelecidle3_ext, 
       output                          txelecidle4_ext,                                                    
       output                          txelecidle5_ext,                                                    
       output                          txelecidle6_ext,                                                    
       output                          txelecidle7_ext, 
                                                          
                                                                                                           
       input                           pll_locked_pcs,                                                     
       output                          rc_pll_locked,                                                      
       input                           gxb_powerdown,                                                      
       output                          gxb_powerdown_pcs,                                                  
                                                                                                           
       input                           pll_powerdown,                                                      
       output                          pll_powerdown_pcs,      
                                                   
       input                           hip_tx_clkout_pcs,                                                  
       output                          pclk_central_hip,    
       output                          pclk_ch0_hip,                                               
                                                                                                           
       input                           rate_hip,                                                           
       output                          rate_ext,                                                           
       output                          rateswitch_pcs,                                                     
       input                           clk500_out,                                                         
       input                           clk250_out,             
       
       input                           rateswitchbaseclock_pcs,                                            
                                                                                                           
       input                           core_clk_out,                                                  
       output                          pll_fixed_clk_hip                                                   

);

wire          pclk_in;

tri0 	      pipe_mode_int;
// synthesis translate_off
// set assignment for simulation only
assign 	      pipe_mode_int = pipe_mode;
// synthesis translate_on

wire gen2_core;
wire hip_type;



   generate if(gen2_lane_rate_mode == "false")
     begin
          assign gen2_core = 1'b0;
     end
        else
          begin
           assign gen2_core = 1'b1;
          end
   endgenerate    

  generate if(p_pcie_hip_type == "2")
     begin
          assign hip_type = 1'b1;   // Cycone 4
     end
        else
          begin
           assign hip_type = 1'b0;
          end
   endgenerate    


  assign rxdata_hip[7 : 0] = pipe_mode_int ? rxdata0_ext : rxdata_pcs[7 : 0];
  assign phystatus_hip[0] = pipe_mode_int ? phystatus_ext : phystatus_pcs[0];
  assign rxelecidle_hip[0] = pipe_mode_int ? rxelecidle0_ext : rxelecidle_pcs[0];
  assign rxvalid_hip[0] = pipe_mode_int ? rxvalid0_ext : rxvalid_pcs[0];
  assign txdata_pcs[7 : 0] = txdata0_hip;
  assign rxdatak_hip[0] = pipe_mode_int ? rxdatak0_ext : rxdatak_pcs[0];
  assign rxstatus_hip[2 : 0] = pipe_mode_int ? rxstatus0_ext : rxstatus_pcs[2 : 0];
  assign powerdown_pcs[1 : 0] = powerdown0_hip;
  assign rxpolarity_pcs[0] = rxpolarity0_hip;
  assign txcompl_pcs[0] = txcompl0_hip;
  assign txdatak_pcs[0] = txdatak0_hip;
  assign txdetectrx_pcs[0] = txdetectrx0_hip;
  assign txelecidle_pcs[0] = txelecidle0_hip;
  assign txdata0_ext = pipe_mode_int ? txdata0_hip : 0;
  assign txdatak0_ext = pipe_mode_int ? txdatak0_hip : 0;
  assign txdetectrx_ext = pipe_mode_int ? txdetectrx0_hip : 0;
  assign txelecidle0_ext = pipe_mode_int ? txelecidle0_hip : 0;
  assign txcompl0_ext = pipe_mode_int ? txcompl0_hip : 0;
  assign rxpolarity0_ext = pipe_mode_int ? rxpolarity0_hip : 0;
  assign powerdown_ext = pipe_mode_int ? powerdown0_hip : 0;
  
  
  generate if (max_link_width >= 2) 
   begin
     assign rxdata_hip[15 : 8] = pipe_mode_int ? rxdata1_ext : rxdata_pcs[15 : 8];
     assign phystatus_hip[1] = pipe_mode_int ? phystatus_ext : phystatus_pcs[1];
     assign rxelecidle_hip[1] = pipe_mode_int ? rxelecidle1_ext : rxelecidle_pcs[1];
     assign rxvalid_hip[1] = pipe_mode_int ? rxvalid1_ext : rxvalid_pcs[1];
     assign txdata_pcs[15 : 8] = txdata1_hip;
     assign rxdatak_hip[1] = pipe_mode_int ? rxdatak1_ext : rxdatak_pcs[1];
     assign rxstatus_hip[5 : 3] = pipe_mode_int ? rxstatus1_ext : rxstatus_pcs[5 : 3];
     assign powerdown_pcs[3 : 2] = powerdown1_hip;
     assign rxpolarity_pcs[1] = rxpolarity1_hip;
     assign txcompl_pcs[1] = txcompl1_hip;
     assign txdatak_pcs[1] = txdatak1_hip;
     assign txdetectrx_pcs[1] = txdetectrx1_hip;
     assign txelecidle_pcs[1] = txelecidle1_hip;
     assign txdata1_ext = pipe_mode_int ? txdata1_hip : 0;
     assign txdatak1_ext = pipe_mode_int ? txdatak1_hip : 0;
     assign txelecidle1_ext = pipe_mode_int ? txelecidle1_hip : 0;
     assign txcompl1_ext = pipe_mode_int ? txcompl1_hip : 0;
     assign rxpolarity1_ext = pipe_mode_int ? rxpolarity1_hip : 0;
   end
  endgenerate
  
  generate if(max_link_width >= 4)
   begin
    assign rxdata_hip[23 : 16] = pipe_mode_int ? rxdata2_ext : rxdata_pcs[23 : 16];
    assign phystatus_hip[2] = pipe_mode_int ? phystatus_ext : phystatus_pcs[2];
    assign rxelecidle_hip[2] = pipe_mode_int ? rxelecidle2_ext : rxelecidle_pcs[2];
    assign rxvalid_hip[2] = pipe_mode_int ? rxvalid2_ext : rxvalid_pcs[2];
    assign txdata_pcs[23 : 16] = txdata2_hip;
    assign rxdatak_hip[2] = pipe_mode_int ? rxdatak2_ext : rxdatak_pcs[2];
    assign rxstatus_hip[8 : 6] = pipe_mode_int ? rxstatus2_ext : rxstatus_pcs[8 : 6];
    assign powerdown_pcs[5 : 4] = powerdown2_hip;
    assign rxpolarity_pcs[2] = rxpolarity2_hip;
    assign txcompl_pcs[2] = txcompl2_hip;
    assign txdatak_pcs[2] = txdatak2_hip;
    assign txdetectrx_pcs[2] = txdetectrx2_hip;
    assign txelecidle_pcs[2] = txelecidle2_hip;
    assign txdata2_ext = pipe_mode_int ? txdata2_hip : 0;
    assign txdatak2_ext = pipe_mode_int ? txdatak2_hip : 0;
    assign txelecidle2_ext = pipe_mode_int ? txelecidle2_hip : 0;
    assign txcompl2_ext = pipe_mode_int ? txcompl2_hip : 0;
    assign rxpolarity2_ext = pipe_mode_int ? rxpolarity2_hip : 0;
  
    assign rxdata_hip[31 : 24] = pipe_mode_int ? rxdata3_ext : rxdata_pcs[31 : 24];
    assign phystatus_hip[3] = pipe_mode_int ? phystatus_ext : phystatus_pcs[3];
    assign rxelecidle_hip[3] = pipe_mode_int ? rxelecidle3_ext : rxelecidle_pcs[3];
    assign rxvalid_hip[3] = pipe_mode_int ? rxvalid3_ext : rxvalid_pcs[3];
    assign txdata_pcs[31 : 24] = txdata3_hip;
    assign rxdatak_hip[3] = pipe_mode_int ? rxdatak3_ext : rxdatak_pcs[3];
    assign rxstatus_hip[11 : 9] = pipe_mode_int ? rxstatus3_ext : rxstatus_pcs[11 : 9];
    assign powerdown_pcs[7 : 6] = powerdown3_hip;
    assign rxpolarity_pcs[3] = rxpolarity3_hip;
    assign txcompl_pcs[3] = txcompl3_hip;
    assign txdatak_pcs[3] = txdatak3_hip;
    assign txelecidle3_ext = pipe_mode_int ? txelecidle3_hip : 0;
    assign txdetectrx_pcs[3] = txdetectrx3_hip;
    assign txelecidle_pcs[3] = txelecidle3_hip;
    assign txdata3_ext = pipe_mode_int ? txdata3_hip : 0;
    assign txdatak3_ext = pipe_mode_int ? txdatak3_hip : 0;
    assign txcompl3_ext = pipe_mode_int ? txcompl3_hip : 0;
    assign rxpolarity3_ext = pipe_mode_int ? rxpolarity3_hip : 0;
  end
endgenerate


  generate if(max_link_width == 8 )
   begin
    assign rxdata_hip[39 : 32] = pipe_mode_int ? rxdata4_ext : rxdata_pcs[39 : 32];
    assign phystatus_hip[4] = pipe_mode_int ? phystatus_ext : phystatus_pcs[4];
    assign rxelecidle_hip[4] = pipe_mode_int ? rxelecidle4_ext : rxelecidle_pcs[4];
    assign rxvalid_hip[4] = pipe_mode_int ? rxvalid4_ext : rxvalid_pcs[4];
    assign txdata_pcs[39 : 32] = txdata4_hip;
    assign rxdatak_hip[4] = pipe_mode_int ? rxdatak4_ext : rxdatak_pcs[4];
    assign rxstatus_hip[14 : 12] = pipe_mode_int ? rxstatus4_ext : rxstatus_pcs[14 : 12];
    assign powerdown_pcs[9 : 8] = powerdown4_hip;
    assign rxpolarity_pcs[4] = rxpolarity4_hip;
    assign txcompl_pcs[4] = txcompl4_hip;
    assign txdatak_pcs[4] = txdatak4_hip;
    assign txdetectrx_pcs[4] = txdetectrx4_hip;
    assign txelecidle_pcs[4] = txelecidle4_hip;
    assign txdata4_ext = pipe_mode_int ? txdata4_hip : 0;
    assign txdatak4_ext = pipe_mode_int ? txdatak4_hip : 0;
    assign txelecidle4_ext = pipe_mode_int ? txelecidle4_hip : 0;
    assign txcompl4_ext = pipe_mode_int ? txcompl4_hip : 0;
    assign rxpolarity4_ext = pipe_mode_int ? rxpolarity4_hip : 0;
  
    assign rxdata_hip[47 : 40] = pipe_mode_int ? rxdata5_ext : rxdata_pcs[47 : 40];
    assign phystatus_hip[5] = pipe_mode_int ? phystatus_ext : phystatus_pcs[5];
    assign rxelecidle_hip[5] = pipe_mode_int ? rxelecidle5_ext : rxelecidle_pcs[5];
    assign rxvalid_hip[5] = pipe_mode_int ? rxvalid5_ext : rxvalid_pcs[5];
    assign txdata_pcs[47 : 40] = txdata5_hip;
    assign rxdatak_hip[5] = pipe_mode_int ? rxdatak5_ext : rxdatak_pcs[5];
    assign rxstatus_hip[17 : 15] = pipe_mode_int ? rxstatus5_ext : rxstatus_pcs[17 : 15];
    assign powerdown_pcs[11 : 10] = powerdown5_hip;
    assign rxpolarity_pcs[5] = rxpolarity5_hip;
    assign txcompl_pcs[5] = txcompl5_hip;
    assign txdatak_pcs[5] = txdatak5_hip;
    assign txelecidle5_ext = pipe_mode_int ? txelecidle5_hip : 0;
    assign txdetectrx_pcs[5] = txdetectrx5_hip;
    assign txelecidle_pcs[5] = txelecidle5_hip;
    assign txdata5_ext = pipe_mode_int ? txdata5_hip : 0;
    assign txdatak5_ext = pipe_mode_int ? txdatak5_hip : 0;
    assign txcompl5_ext = pipe_mode_int ? txcompl5_hip : 0;
    assign rxpolarity5_ext = pipe_mode_int ? rxpolarity5_hip : 0;
    
    assign rxdata_hip[55 : 48] = pipe_mode_int ? rxdata6_ext : rxdata_pcs[55 : 48];
    assign phystatus_hip[6] = pipe_mode_int ? phystatus_ext : phystatus_pcs[6];
    assign rxelecidle_hip[6] = pipe_mode_int ? rxelecidle6_ext : rxelecidle_pcs[6];
    assign rxvalid_hip[6] = pipe_mode_int ? rxvalid6_ext : rxvalid_pcs[6];
    assign txdata_pcs[55 : 48] = txdata6_hip;
    assign rxdatak_hip[6] = pipe_mode_int ? rxdatak6_ext : rxdatak_pcs[6];
    assign rxstatus_hip[20 : 18] = pipe_mode_int ? rxstatus6_ext : rxstatus_pcs[20 : 18];
    assign powerdown_pcs[13 : 12] = powerdown6_hip;
    assign rxpolarity_pcs[6] = rxpolarity6_hip;
    assign txcompl_pcs[6] = txcompl6_hip;
    assign txdatak_pcs[6] = txdatak6_hip;
    assign txelecidle6_ext = pipe_mode_int ? txelecidle6_hip : 0;
    assign txdetectrx_pcs[6] = txdetectrx6_hip;
    assign txelecidle_pcs[6] = txelecidle6_hip;
    assign txdata6_ext = pipe_mode_int ? txdata6_hip : 0;
    assign txdatak6_ext = pipe_mode_int ? txdatak6_hip : 0;
    assign txcompl6_ext = pipe_mode_int ? txcompl6_hip : 0;
    assign rxpolarity6_ext = pipe_mode_int ? rxpolarity6_hip : 0;
    
    assign rxdata_hip[63 : 56] = pipe_mode_int ? rxdata7_ext : rxdata_pcs[63 : 56];
    assign phystatus_hip[7] = pipe_mode_int ? phystatus_ext : phystatus_pcs[7];
    assign rxelecidle_hip[7] = pipe_mode_int ? rxelecidle7_ext : rxelecidle_pcs[7];
    assign rxvalid_hip[7] = pipe_mode_int ? rxvalid7_ext : rxvalid_pcs[7];
    assign txdata_pcs[63 : 56] = txdata7_hip;
    assign rxdatak_hip[7] = pipe_mode_int ? rxdatak7_ext : rxdatak_pcs[7];
    assign rxstatus_hip[23 : 21] = pipe_mode_int ? rxstatus7_ext : rxstatus_pcs[23 : 21];
    assign powerdown_pcs[15 : 14] = powerdown7_hip;
    assign rxpolarity_pcs[7] = rxpolarity7_hip;
    assign txcompl_pcs[7] = txcompl7_hip;
    assign txdatak_pcs[7] = txdatak7_hip;
    assign txelecidle7_ext = pipe_mode_int ? txelecidle7_hip : 0;
    assign txdetectrx_pcs[7] = txdetectrx7_hip;
    assign txelecidle_pcs[7] = txelecidle7_hip;
    assign txdata7_ext = pipe_mode_int ? txdata7_hip : 0;
    assign txdatak7_ext = pipe_mode_int ? txdatak7_hip : 0;
    assign txcompl7_ext = pipe_mode_int ? txcompl7_hip : 0;
    assign rxpolarity7_ext = pipe_mode_int ? rxpolarity7_hip : 0;
    
  end
endgenerate

  
generate if (max_link_width > 1)
  begin
    assign pclk_central_hip = (pipe_mode_int == 1'b1) ? pclk_in : hip_tx_clkout_pcs;
    
  end
else
 begin
   assign pclk_central_hip = (pipe_mode_int == 1'b1) ? pclk_in : 1'b0;
 end
endgenerate  

  assign rc_pll_locked = (pipe_mode_int == 1'b1) ? 1'b1 : pll_locked_pcs;
  assign gxb_powerdown_pcs = (pipe_mode_int == 1'b1) ? 1'b1 : gxb_powerdown;
  assign pll_powerdown_pcs = (pipe_mode_int == 1'b1) ? 1'b1 : pll_powerdown;
  
  assign pclk_in = (rate_ext == 1'b1) ? clk500_out : clk250_out;
  assign pclk_ch0_hip = (pipe_mode_int == 1'b1) ? pclk_in : hip_tx_clkout_pcs;  // C4 use this pclk_ch0
  assign rateswitch_pcs = rate_hip;
  assign rate_ext = pipe_mode_int ? rate_hip : 0;
  
  assign pll_fixed_clk_hip = (pipe_mode_int == 1'b0) ? hip_type? hip_tx_clkout_pcs : rateswitchbaseclock_pcs : gen2_core? clk500_out : clk250_out;

 //assign pll_fixed_clk_hip = (pipe_mode_int == 1'b0)?  rateswitchbaseclock_pcs : gen2_core? clk500_out : clk250_out; // S4 use fixed_clk, C4 use pclk_ch0
  assign rc_areset = pipe_mode_int | ~pcie_rstn;
  
  
  
  endmodule
