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


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on
module altpciexpav_stif_tx_cntrl
#(
parameter  ADDRESS_32BIT = 1,
parameter  CB_PCIE_MODE = 0,
parameter  CG_COMMON_CLOCK_MODE = 0,
parameter  AST_WIDTH = 64,
parameter  CB_PCIE_RX_LITE = 0,
parameter  deviceFamily = "Arria V"

)

( input                                Clk_i,     // Avalon clock
  input                                Rstn_i,    // Avalon reset    
  
  // PCIe core Tx interface
   input                  TxStReady_i  ,
   output   [63:0]         TxStData_o   ,
   output   [31:0]          TxStParity_o ,
   output                   TxStErr_o    ,
   output                   TxStSop_o    ,
   output                   TxStEop_o    ,
   output   [1:0]           TxStEmpty_o  ,
   output                   TxStValid_o  ,
   input                    TxAdapterFifoEmpty_i,
   
      /// Tx Credit interface                     
   input   [5 : 0]          TxCredHipCons_i,      
   input   [5 : 0]          TxCredInfinit_i,      
   input   [7 : 0]          TxCredNpHdrLimit_i,   
   input   [7:0]            ko_cpl_spc_header,
   input   [11:0]           ko_cpl_spc_data,
   
     input    [35:0]                        TxCredit_i,
     input                                  TxNpCredOne_i,
   
  // Command Fifo interface     
  input [97:0]  CmdFifoDat_i,   
  input          CmdFifoEmpty_i,
  output         CmdFifoRdReq_o,
  
  // Read bypass buffer interface
  input          RdBypassFifoEmpty_i,
  input          RdBypassFifoFull_i,
  input [6:0]    RdBypassFifoUsedw_i,
  input [97:0]  RdBypassFifoDat_i,
  output         RdBypassFifoWrReq_o,
  output         RdBypassFifoRdReq_o,
  
  // Completion buffer interface
  output  [8:0]  CplBuffRdAddr_o,
  input   [63:0] TxCplDat_i,
  
  // write data fifo interface
  output         WrDatFifoRdReq_o,
  input [63:0]   TxWrDat_i,
  
  
   // Rx Completion interface for buffer credit keeping
  input           RxCplBuffFree_i,
  input [10:0]    RxCplDwFree_i,
  output          TxCplSent_o,
  output  [9:0]   TxCplDwSent_o,
  
  output           CplPending_o,

 // RP interface
  output            TxRpFifoRdReq_o,  
  input   [130 :0]  TxRpFifoData_i,   
  input             RpTLPReady_i,      
  
  
  
  // Rx Completion interface for buffer credit keeping
  
  // cfg register
  input [12:0]  BusDev_i,
  
   input  [15:0] MsiCsr_i,
   input  [15:0] MsiData_i,
   input  [63:0] MsiAddr_i,
   output         MsiReq_o, 
   input          MsiAck_i,
   output         IntxReq_o,
   input          IntxAck_i,
   input          pld_clk_inuse,
   output         tx_cons_cred_sel
  
  
);

localparam      TX_IDLE            = 19'h00000;
localparam      TX_POP_CMDFIFO     = 19'h00003;
localparam      TX_CHECK_CMDFIFO   = 19'h00005;
localparam      TX_RD_HDR1         = 19'h00009;
localparam      TX_RD_HDR2         = 19'h00011;
localparam      TX_WR_HDR1         = 19'h00021;
localparam      TX_WR_HDR2         = 19'h00041;
localparam      TX_WR_DATA         = 19'h00081;
localparam      TX_CPL_HDR1        = 19'h00101;
localparam      TX_CPL_HDR2        = 19'h00201;
localparam      TX_CPL_DATA        = 19'h00401;
localparam      TX_MSI_REQ         = 19'h00801;
localparam      TX_POP_BPFIFO      = 19'h01001;
localparam      TX_RBP_HDR1        = 19'h02001;
localparam      TX_RBP_HDR2        = 19'h04001;
localparam      TX_STORE_RD        = 19'h08001;
localparam      TX_WAIT            = 19'h10001;
localparam      TX_CHECK_BPFIFO    = 19'h20001;
localparam      TX_WAIT_ADPT_EMPTY = 19'h40001;


localparam      TXRP_IDLE            = 4'h0; 
localparam      TXRP_RD_FIFO         = 4'h3;
localparam      TXRP_STREAM_0        = 4'h5;
localparam      TXRP_STREAM_1        = 4'h9;




wire         rx_only;
wire         is_rd;
wire         is_wr;
wire         is_cpl;



wire [9:0]  dw_len;
wire        addr_bit2;
wire        cpl_dat_clken;

wire        sm_pop_bpfifo ;
wire        sm_bp_rddesc; 
wire        sm_pop_cmdfifo; 
wire        sm_check_cmdfifo; 
wire        sm_rddesc; 
wire        sm_store_rd;
wire        sm_rbp_hdr1; 
wire        sm_rbp_hdr2;
wire        sm_wrdata; 
wire        sm_cpl_data;
wire        sm_wait_bpfifo; 
wire        sm_cpldata_fall;
wire        sm_idle;
reg         sm_cpldata_reg;
reg         sm_cpl_hdr2_reg;
wire        up_cpl_cnt;
wire        tx_dfr_rise;
reg         tx_dfr_sreg2;
reg         rxcplbuff_free_reg;
reg  [10:0] rxcpl_dw_freed_cntr /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL =D101" */ ;
wire        rxcpl_cntr_unloaded;
wire         tag_available;
wire [63:0] req_header1;    
wire [63:0] req_header2;
wire [63:0] cpl_header1;  
wire [63:0] cpl_header2;    
wire [127:0] cmd_header;           
reg [63:0]  cmd_header1_reg;
reg  [63:0]  cmd_header2_reg;
wire [63:0]  cmd_header1;     
wire  [63:0]  cmd_header2;    
wire  [63:0]  tx_completion_data;
                                 
reg [18:0]                         tx_state;
reg [18:0]                         tx_nxt_state;  
reg [9:0]                          cpl_dat_cntr;
reg [9:0]                          wr_dat_cntr;
reg                                tx_dfr_sreg;
reg                                tx_dv_sreg;
reg                                down_rddwlen2_reg; 
reg                                down_rddwlen1_reg; 
reg                                down_rddwlen_reg; 
reg [9:0]                          desc_rdlen_reg;
reg [8:0]                          cpl_addr_reg;
reg [11:0]                         cpl_buff_cntr;
reg [10:0]                         rxcpl_wr_ptr;
reg [10:0]                         cpl_dwsent_reg;
reg [11:0]                         rxcpl_avail_size;
reg                                sm_bp_rddesc_reg;
reg                                sm_rddesc_reg;
reg [9:0]                           rd_dwlen_plus1_reg;
reg [9:0]                          rd_dwlen_plus2_reg;
reg [5:0]                          outstanding_tag_cntr;
wire [5:0]                         max_outstanding_read;

wire is_rd_32 ;
wire is_rd_64 ;
wire is_wr_32 ;
wire is_wr_64 ;
wire is_flush_cpl;
wire is_abort_cpl;
reg  [7:0] cmd;
wire [15:0] requestor_id;      
wire [7:0] req_tag;                
wire [7:0] cpl_tag;                
wire [3:0] fbe;     
wire [3:0] lbe;                
wire [6:0] lower_adr;              
wire [15:0] cpl_req_id;             
wire [15:0] cpl_cplter_id;                  
wire [11:0] cpl_remain_bytes; 
wire [1:0] cpl_attr;             
wire [2:0] cpl_tc;           
     
reg [7:0] cmd_reg;
reg [9:0]dw_len_reg;
reg [7:0] req_tag_reg;
reg [3:0] fbe_reg;
reg [3:0] lbe_reg;
reg [63:0] cmdfifo_addr_reg;
reg [2:0] cpl_tc_reg;
reg [1:0] cpl_attr_reg;
reg [11:0] cpl_remain_bytes_reg;
reg [15:0] cpl_req_id_reg;
reg [6:0] lower_adr_reg;      
reg [7:0] cpl_tag_reg;
wire [31:0] adr_hi;
wire [31:0] adr_low;

wire [9:0] pb_dw_len; 
wire [7:0] pb_req_tag ;
wire [3:0] pb_fbe;
wire [3:0] pb_lbe;
wire pb_rd64;
wire [31:0] bp_adr_hi;
wire [31:0] bp_adr_low;
wire [127:0] pb_rd_header;
wire [31:0]  tlp_dw3;           
wire [31:0]  tlp_dw2;
wire         tlp_dw2_sel;
wire         tlp_dw3_sel;
wire         output_fifo_ok;
wire [3:0]        output_fifo_wrusedw;
wire              output_fifo_rdempty;
reg  [63:0]             tlp_data;
wire [2:0]              tlp_data_sel;
wire              tlp_sop;
wire              tlp_eop;
wire              output_fifo_wrreq;  
reg                output_fifo_wrreq_reg; 
wire              output_fifo_rdreq;
wire  [65:0]      output_fifo_data_in;
reg   [65:0]      output_fifo_data_in_reg;
wire  [65:0]      output_fifo_data_out;
reg   [63:0]      tx_tlp_out_reg;
reg               tx_sop_out_reg;
reg               tx_eop_out_reg;
reg               output_valid_reg;
reg               fifo_valid_reg;
wire              output_transmit;
wire              fifo_transmit;
reg               output_fifo_ok_reg;
reg               tag_available_reg;
reg               irq_ack_reg;
wire              to_pop_bpfifo;      
reg               np_header_avail_reg;
wire              np_header_avail;
wire  [97:0]        cmd_fifo_dat;
wire  [31:0]      addr_low;
wire  [31:0]      addr_hi;
wire             rdbp_fifo_sel;
wire             sm_check_bpfifo;
wire             rdbypass_fifo_full;
wire 		 msi_req;
wire 		 sm_rd_hdr1;
wire 		 sm_rd_hdr2;
wire 		 sm_wr_hdr1;
wire 		 sm_wr_hdr2;
wire 		 sm_wr_data;
wire 		 sm_cpl_hdr1;
wire 		 sm_cpl_hdr2;
wire 		 sm_msi_req;
wire 		 sm_wait;
reg              tx_st_ready_reg;
reg  [4:0]       adapter_fifo_write_cntr; 
reg  [7:0]       nph_cred_cons_reg;
wire             np_tlp_sent;
reg  [7:0]       nph_cred_limit_reg;
wire [7:0]       nph_cred_sub;
wire [63:0]      wr_data;
reg              msi_req_reg;
wire             s5_device;
reg  [3:0]       txrp_state;
reg  [3:0]       txrp_nxt_state;   
wire             txrp_sm_idle;
wire             txrp_sm_stream0;
wire             txrp_sm_stream1;    
reg              txrp_sm_stream_reg;
wire             txrp_sm_stream_rise;
wire             txrp_sm_wait;
wire             txrp_sm_rdfifo;
wire             txrp_eop;           
wire             txrp_sop;
wire             txrp_empty;      
wire             is_rp_rd;      
wire             is_rp_wr;      
wire             rp_4dw_header; 
wire             rp_odd_address;
wire             rp_span_2cydle;           
wire             txrp_low_dat_sel;                           
wire [63:0]      rp_tlp_data; 
wire             rp_tlp_sop;                                                
wire             rp_tlp_eop;         
wire             is_rp_cfg;
wire             is_rp_io;
wire             txrp_np;          
reg              pld_clk_inuse_reg;
wire             pld_clk_inuse_rise;
reg [3:0]        pulse_width_cntr;
wire             cons_load_pulse_clear;
reg              reload_nph_cons_from_hip_reg;
wire             txrp_hi_dat_sel;


// RP TLP Decode
assign txrp_eop = TxRpFifoData_i[129];   
assign txrp_empty = TxRpFifoData_i[130];    

assign is_rp_rd       =  ~TxRpFifoData_i[30] & (TxRpFifoData_i[28:26]== 3'b000) & ~TxRpFifoData_i[24];
assign is_rp_cfg       = ~TxRpFifoData_i[29] & (TxRpFifoData_i[28:24]==5'b00101); // type 1    
assign is_rp_io        = ~TxRpFifoData_i[29] & (TxRpFifoData_i[28:24]==5'b00010); // read/write 
assign is_rp_wr       = TxRpFifoData_i[30]; // & (TxRpFifoData_i[28:24]==5'b00000);
assign rp_4dw_header  = TxRpFifoData_i[29];
assign rp_odd_address = TxRpFifoData_i[29]? TxRpFifoData_i[98] : TxRpFifoData_i[66]; // 
assign rp_span_2cydle = (is_rp_wr & (rp_4dw_header | ~rp_4dw_header & ~rp_odd_address)); // two 128-bit

assign txrp_np         =  is_rp_rd | is_rp_cfg | is_rp_io;


generate if (deviceFamily == "Stratix IV" ||  deviceFamily == "Cyclone IV GX" || deviceFamily == "HardCopy IV" || deviceFamily == "Arria II GZ" || deviceFamily == "Arria II GX" )
    begin
    	assign s5_device = 1'b0;
    end
 else
    begin
        assign s5_device = 1'b1; 
    end
endgenerate

// decode the command


generate if(CB_PCIE_MODE == 1)
  assign rx_only = 1'b1;
else
  assign rx_only = 1'b0;
endgenerate

// Deriving number of supporting tag based on the Knock-out signals
/// only issue one read if low RX CPL buffer allocated
generate if (deviceFamily == "Arria V" ||  deviceFamily == "Cyclone V")
    assign max_outstanding_read = (ko_cpl_spc_data[11:0] > 32)? 8 : 1; 
 else
   assign max_outstanding_read = 8;  
endgenerate

assign 	 TxStErr_o = 1'b0;
assign rdbypass_fifo_full = (RdBypassFifoUsedw_i >= 60);
// Output FIFO
//  altpciexpav_fifo 
//  #(
//    .COMMON_CLOCK(CG_COMMON_CLOCK_MODE),
//    .ADDR_WIDTH(5) ,
//    .DATA_WIDTH(AST_WIDTH+2),  // data+sop+eop
//    .USE_RAM_OUTPUT_REGISTER(0)
//    )
//    
// tx_output_fifo
//    (
//     .rdclk (Clk_i),
//     .rdclk_clr(~Rstn_i),
//     .wrclk (Clk_i),
//     .aclr (~Rstn_i),
//     .wrreq (output_fifo_wrreq),
//     .rdreq (output_fifo_rdreq),
//     .data (output_fifo_data_in),
//     .rdempty (output_fifo_rdempty),
//     .wrfull (),
//     .rdvalid (),
//     .rdusedw (output_fifo_rdusedw),
//     .wrusedw (output_fifo_wrusedw),
//     .q(output_fifo_data_out)
//     ) ;
                         
	scfifo	tx_output_fifo (
				.rdreq (output_fifo_rdreq),
				.clock (Clk_i),
				.wrreq (output_fifo_wrreq_reg),
				.data (output_fifo_data_in_reg),
				.usedw (output_fifo_wrusedw),
				.empty (output_fifo_rdempty),
				.q (output_fifo_data_out),
				.full (),
				.aclr (~Rstn_i),
				.almost_empty (),
				.almost_full (),
				.sclr ()
				);
	defparam
		tx_output_fifo.add_ram_output_register = "ON",
		tx_output_fifo.intended_device_family = "Stratix IV",
		tx_output_fifo.lpm_numwords = 16,
		tx_output_fifo.lpm_showahead = "OFF",
		tx_output_fifo.lpm_type = "scfifo",
		tx_output_fifo.lpm_width = 66,
		tx_output_fifo.lpm_widthu = 4,
		tx_output_fifo.overflow_checking = "ON",
		tx_output_fifo.underflow_checking = "ON",
		tx_output_fifo.use_eab = "ON";


assign rdbp_fifo_sel = sm_check_bpfifo | sm_rbp_hdr1 | sm_rbp_hdr2;


assign addr_low  =  rdbp_fifo_sel? RdBypassFifoDat_i[31:0]: CmdFifoDat_i[31:0];
assign addr_hi   =  rdbp_fifo_sel? RdBypassFifoDat_i[63:32]: CmdFifoDat_i[63:32];
assign is_rd_32  =  rdbp_fifo_sel? RdBypassFifoDat_i[64]: CmdFifoDat_i[64];
assign is_rd_64  =  rdbp_fifo_sel? RdBypassFifoDat_i[65]: CmdFifoDat_i[65];
assign is_wr_32  =  rdbp_fifo_sel? RdBypassFifoDat_i[66]: CmdFifoDat_i[66];
assign is_wr_64  =  rdbp_fifo_sel? RdBypassFifoDat_i[67]: CmdFifoDat_i[67];
assign is_cpl    =  rdbp_fifo_sel? 1'b0: (CmdFifoDat_i[68] | rx_only);
assign is_flush_cpl  = rdbp_fifo_sel? RdBypassFifoDat_i[69]: CmdFifoDat_i[69];
assign is_abort_cpl  = rdbp_fifo_sel? RdBypassFifoDat_i[31]: CmdFifoDat_i[31];

assign is_rd = (is_rd_64 | is_rd_32) & ~rx_only;
assign is_wr = (is_wr_64 | is_wr_32) & ~rx_only;
 

// create header

always @(is_wr_64, is_rd_64, is_wr_32, is_rd_32)
  begin
    case({is_wr_64, is_rd_64, is_wr_32, is_rd_32})
      4'b0001 : cmd = 8'h00;
      4'b0010 : cmd = 8'h40;
      4'b0100 : cmd = 8'h20;
      default : cmd = 8'h60;
    endcase
 end

assign dw_len = msi_req? 10'h1 : rdbp_fifo_sel? {1'b0, RdBypassFifoDat_i[93:85]} : {1'b0, CmdFifoDat_i[93:85]}; // for completion and write
assign requestor_id = {BusDev_i, 3'b000};

assign req_tag      = rdbp_fifo_sel? RdBypassFifoDat_i[81:74]: CmdFifoDat_i[81:74];
assign cpl_tag      = rdbp_fifo_sel? RdBypassFifoDat_i[14:7]: CmdFifoDat_i[14:7];
assign fbe          = rdbp_fifo_sel?  RdBypassFifoDat_i[73:70]: CmdFifoDat_i[73:70];
assign lbe          =  rdbp_fifo_sel? RdBypassFifoDat_i[97:94] : CmdFifoDat_i[97:94];
assign lower_adr    = rdbp_fifo_sel? RdBypassFifoDat_i[6:0]: CmdFifoDat_i[6:0];
assign cpl_req_id   = rdbp_fifo_sel? RdBypassFifoDat_i[30:15]: CmdFifoDat_i[30:15];
assign cpl_cplter_id = requestor_id;
assign cpl_remain_bytes = rdbp_fifo_sel? RdBypassFifoDat_i[81:70]: CmdFifoDat_i[81:70];
assign cpl_attr         = rdbp_fifo_sel? RdBypassFifoDat_i[97:94]: CmdFifoDat_i[97:94];
assign cpl_tc         = rdbp_fifo_sel? RdBypassFifoDat_i[84:82]: CmdFifoDat_i[84:82];
//assign  msi_req       = s5_device? (CmdFifoDat_i[81] & is_wr) : rdbp_fifo_sel? RdBypassFifoDat_i[81]: (CmdFifoDat_i[81] & ~(CmdFifoDat_i[68] | rx_only)); // bit 68 = is_cpl
assign  msi_req       = s5_device? (CmdFifoDat_i[81] & (is_wr_32 | is_wr_64)) : rdbp_fifo_sel? RdBypassFifoDat_i[81]: (CmdFifoDat_i[81] & ~(CmdFifoDat_i[68] | rx_only)); // bit 68 = is_cpl
always @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      begin
        cmd_reg <= 8'h0;
        dw_len_reg <= 10'h0;
        req_tag_reg <= 8'h0;
        fbe_reg     <= 4'h0;
        lbe_reg     <= 4'h0;
        cpl_tc_reg       <= 2'b00;
        cpl_attr_reg     <= 2'b00;
        cpl_remain_bytes_reg <= 12'h0;
        cpl_req_id_reg  <= 16'h0;
        cpl_tag_reg     <= 8'h0;
        lower_adr_reg   <= 7'h0;
      end
    else if(sm_check_cmdfifo | sm_check_bpfifo)
      begin
        cmd_reg <= cmd;
        dw_len_reg <= dw_len;
        req_tag_reg <= req_tag;
        fbe_reg     <= fbe;
        lbe_reg     <= lbe;
        cpl_tc_reg       <= cpl_tc;
        cpl_attr_reg     <= cpl_attr;
        cpl_remain_bytes_reg <= cpl_remain_bytes;
        cpl_req_id_reg  <= cpl_req_id;
        cpl_tag_reg     <= cpl_tag;
        lower_adr_reg   <= lower_adr;
      end
  end


generate if(ADDRESS_32BIT == 1)
 begin
  always @(posedge Clk_i or negedge Rstn_i)
    if(~Rstn_i)
        cmdfifo_addr_reg <= 64'h0;
    else if(sm_check_cmdfifo | sm_check_bpfifo)
        cmdfifo_addr_reg <= {32'h0, addr_low};
 end
else 
  begin
  always @(posedge Clk_i or negedge Rstn_i)
    if(~Rstn_i)
        cmdfifo_addr_reg <= 64'h0;
    else if(sm_check_cmdfifo | sm_check_bpfifo)
        cmdfifo_addr_reg <= {addr_hi, addr_low};
 end
endgenerate


generate if(ADDRESS_32BIT == 1)
  begin
    assign adr_hi       =  (is_wr_64 | is_rd_64)? 32'h0: cmdfifo_addr_reg[31:0];
    assign adr_low      =  cmdfifo_addr_reg[31:0];
  end
else
   begin
    assign adr_hi       =  cmdfifo_addr_reg[63:32];
    assign adr_low      =  cmdfifo_addr_reg[31:0];
  end
endgenerate


assign wr_data = (msi_req & ~MsiAddr_i[2])? {48'h0, MsiData_i[15:0]} : (msi_req & MsiAddr_i[2])? {16'h0, MsiData_i[15:0], 32'h0}: TxWrDat_i;

assign tlp_dw2_sel = (is_wr_32 | is_rd_32);           
assign tlp_dw2     = tlp_dw2_sel? adr_low : adr_hi;
assign tlp_dw3_sel = (is_wr_32 | is_rd_32);           
assign tlp_dw3     = tlp_dw3_sel? wr_data[63:32] : adr_low[31:0];

assign req_header1 = {requestor_id[15:0], req_tag_reg[7:0], lbe_reg, fbe_reg, cmd_reg[7:0], 8'h0, 6'h0, dw_len_reg[9:0]};
assign req_header2 = { tlp_dw3, tlp_dw2 };


generate if (CB_PCIE_RX_LITE == 0)
   assign tx_completion_data = is_flush_cpl? 64'h0 : TxCplDat_i;
else
   assign tx_completion_data = is_flush_cpl? 64'h0 : {TxCplDat_i[31:0], TxCplDat_i[31:0]};  // duplicate 32-bit low and high
endgenerate

assign cpl_header1 = {cpl_cplter_id, is_abort_cpl ,3'b000, cpl_remain_bytes_reg , 1'b0, ~is_abort_cpl, 6'b001010, 1'b0, cpl_tc_reg, 4'h0, 2'h0, cpl_attr_reg, 2'b00, dw_len_reg};
assign cpl_header2 = { tx_completion_data[63:32], cpl_req_id_reg, cpl_tag_reg, 1'b0,lower_adr_reg};

assign cmd_header1 = is_cpl? cpl_header1 : req_header1; 
assign cmd_header2 = is_cpl? cpl_header2 : req_header2; 

always @(posedge Clk_i or negedge Rstn_i)  // state machine registers
  begin
    if(~Rstn_i)
     begin
       cmd_header1_reg <= 0;
       cmd_header2_reg <= 0;
       msi_req_reg     <= 1'b0;
     end
    else
     begin
      cmd_header1_reg <= is_cpl? cpl_header1 : req_header1;
      cmd_header2_reg <= is_cpl? cpl_header2 : req_header2; 
      msi_req_reg     <= msi_req;
     end
  end

assign addr_bit2    = rdbp_fifo_sel? RdBypassFifoDat_i[2]: CmdFifoDat_i[2]; 



always @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
     begin
      output_fifo_ok_reg <= 1'b0;
      tag_available_reg <= 0;
      irq_ack_reg <= 1'b0;
      np_header_avail_reg <= 1'b0;
     end
    else
     begin
      np_header_avail_reg <= np_header_avail;
      output_fifo_ok_reg <= output_fifo_wrusedw[3:0] <= 4;
      tag_available_reg <= (outstanding_tag_cntr != 0);
      irq_ack_reg <= MsiAck_i;
     end
  end

always @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      adapter_fifo_write_cntr <= 5'b0;
    else if (sm_check_cmdfifo & msi_req)
      adapter_fifo_write_cntr <= 5'b0;
    else if(fifo_transmit)
      adapter_fifo_write_cntr <= adapter_fifo_write_cntr + 1;
  end

/// Credit available logic

always @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      pld_clk_inuse_reg <= 1'b0;
    else
      pld_clk_inuse_reg <= pld_clk_inuse;
  end 
  
assign pld_clk_inuse_rise = pld_clk_inuse & ~pld_clk_inuse_reg;

always @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      pulse_width_cntr <= 4'b0;
    else if(pld_clk_inuse_rise)
      pulse_width_cntr <= 4'b0;
    else if(pulse_width_cntr < 4'b1111)
      pulse_width_cntr <= pulse_width_cntr + 1;
  end 

assign cons_load_pulse_clear = (pulse_width_cntr == 4'b1111);

/// extend the load signal to 16 clocks
always @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      reload_nph_cons_from_hip_reg <= 1'b0;
    else if(pld_clk_inuse_rise)
      reload_nph_cons_from_hip_reg <= 1'b1;
    else if (cons_load_pulse_clear)
      reload_nph_cons_from_hip_reg <= 1'b0;
  end 
assign tx_cons_cred_sel = reload_nph_cons_from_hip_reg;

assign np_tlp_sent = sm_rd_hdr1 | sm_rbp_hdr1 | (rp_tlp_sop & txrp_np);

always @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
       nph_cred_cons_reg <= 8'h0;
    else if(reload_nph_cons_from_hip_reg)
       nph_cred_cons_reg <= TxCredNpHdrLimit_i; // this is consumed value from Hip based on mux select
    else if (np_tlp_sent ^ TxCredHipCons_i[3])   
       nph_cred_cons_reg <= nph_cred_cons_reg + 1;
    else if (np_tlp_sent & TxCredHipCons_i[3])
       nph_cred_cons_reg <= nph_cred_cons_reg + 2;
  end
  
always @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
       nph_cred_limit_reg <= 8'h0;
    else
       nph_cred_limit_reg <= TxCredNpHdrLimit_i;
  end

assign nph_cred_sub = nph_cred_limit_reg - nph_cred_cons_reg;


generate if (deviceFamily == "Stratix IV" ||  deviceFamily == "Cyclone IV GX" || deviceFamily == "HardCopy IV" || deviceFamily == "Arria II GZ" || deviceFamily == "Arria II GX" )
    begin
    	assign np_header_avail = (TxCredit_i[17:15] != 3'b000) | TxNpCredOne_i;
    end
 else
    begin
        assign np_header_avail = nph_cred_sub <= 128 | TxCredInfinit_i[3]; 
    end
endgenerate


always @(posedge Clk_i or negedge Rstn_i)  // state machine registers
  begin
    if(~Rstn_i)
      tx_state <= TX_IDLE;
    else
      tx_state <= tx_nxt_state;
  end

// state machine next state gen

always @*
     
  begin
    case(tx_state)
      TX_IDLE :
        if(np_header_avail_reg & ~RdBypassFifoEmpty_i & tag_available_reg & output_fifo_ok_reg & ~rx_only & txrp_sm_idle & ~RpTLPReady_i )
           tx_nxt_state <= TX_POP_BPFIFO;
        else if(~CmdFifoEmpty_i & txrp_sm_idle & ~RpTLPReady_i)
          tx_nxt_state <= TX_CHECK_CMDFIFO; // read the command fifo
        else
          tx_nxt_state <= TX_IDLE; // read the command fifo
         
     TX_POP_BPFIFO:
       tx_nxt_state <= TX_CHECK_BPFIFO;
       
     TX_CHECK_BPFIFO:
        tx_nxt_state <= TX_RBP_HDR1;
     
     TX_RBP_HDR1:
        
        tx_nxt_state <= TX_RBP_HDR2;
     
     TX_RBP_HDR2:
       tx_nxt_state <= TX_IDLE;
      
      TX_CHECK_CMDFIFO:
        if((msi_req & ~MsiCsr_i[0] & s5_device) | (msi_req & ~s5_device)) // s5 forms MWR TLP for MSI, s4 use side band MSI
          tx_nxt_state <= TX_MSI_REQ;
        else if(is_rd & (~np_header_avail_reg | ~tag_available_reg) | (is_rd & ~RdBypassFifoEmpty_i) )
          tx_nxt_state <= TX_STORE_RD;
        else if(is_rd & tag_available_reg & output_fifo_ok_reg & np_header_avail_reg)
          tx_nxt_state <= TX_RD_HDR1;
        else if(is_wr & output_fifo_ok_reg)
           tx_nxt_state <= TX_WR_HDR1; 
        else if(is_cpl & output_fifo_ok_reg)
          tx_nxt_state <= TX_CPL_HDR1;
        else
           tx_nxt_state <= TX_CHECK_CMDFIFO;
           
     TX_STORE_RD: 
        tx_nxt_state <= TX_IDLE;
       
     TX_RD_HDR1:
         tx_nxt_state <= TX_RD_HDR2;
      
     TX_RD_HDR2:
        tx_nxt_state <= TX_IDLE;
        
     TX_WR_HDR1:
         tx_nxt_state <= TX_WR_HDR2;
      
      TX_WR_HDR2:
        if(is_wr_32 &  wr_dat_cntr == 2 & addr_bit2)
          tx_nxt_state <= TX_IDLE;
        else
          tx_nxt_state <= TX_WR_DATA;
      
     TX_WR_DATA:
       if(output_fifo_ok_reg & wr_dat_cntr == 2 & (CmdFifoEmpty_i | ~RdBypassFifoEmpty_i | RpTLPReady_i))
         tx_nxt_state <= TX_IDLE;
       else if(output_fifo_ok_reg & wr_dat_cntr == 2 & ~CmdFifoEmpty_i  )
          tx_nxt_state <= TX_CHECK_CMDFIFO;
       else if(~output_fifo_ok_reg)
          tx_nxt_state <= TX_WAIT;
       else
          tx_nxt_state <= TX_WR_DATA;
     
     TX_CPL_HDR1:
         tx_nxt_state <= TX_CPL_HDR2;
         
     TX_CPL_HDR2:
         if((cpl_dat_cntr == 2 & addr_bit2) | is_abort_cpl)
          tx_nxt_state <= TX_IDLE;
        else
          tx_nxt_state <= TX_CPL_DATA;
           
     TX_CPL_DATA:
    //    if(output_fifo_ok_reg & (cpl_dat_cntr == 2 | cpl_dat_cntr == 0)) // ==0 for single DW at even address
     if(output_fifo_ok_reg & (cpl_dat_cntr == 2)) // ==0 for single DW at even address
         tx_nxt_state <= TX_IDLE;
     else if(~output_fifo_ok_reg)
         tx_nxt_state <= TX_WAIT;
     else
          tx_nxt_state <= TX_CPL_DATA;
          
      TX_WAIT_ADPT_EMPTY:
        if (TxAdapterFifoEmpty_i | adapter_fifo_write_cntr == 16)
          tx_nxt_state <= TX_MSI_REQ;
        else
          tx_nxt_state <= TX_WAIT_ADPT_EMPTY;
          
      TX_MSI_REQ:
         if(irq_ack_reg)
          tx_nxt_state <= TX_IDLE;
         else
          tx_nxt_state <= TX_MSI_REQ;
      TX_WAIT:
          if(output_fifo_ok_reg & is_cpl)
             tx_nxt_state <= TX_CPL_DATA;
          else if(output_fifo_ok_reg & is_wr)
             tx_nxt_state <= TX_WR_DATA;
          else
             tx_nxt_state <= TX_WAIT;
        
     default:
          tx_nxt_state <= TX_IDLE;
          
    endcase
 end  
    
/// assign the state machine outputs

assign sm_idle          = ~tx_state[0];
assign sm_pop_cmdfifo   = tx_state[1];
assign sm_check_cmdfifo = tx_state[2];
assign sm_rd_hdr1       = tx_state[3];
assign sm_rd_hdr2       = tx_state[4];
assign sm_wr_hdr1       = tx_state[5];
assign sm_wr_hdr2       = tx_state[6];
assign sm_wr_data       = tx_state[7];
assign sm_cpl_hdr1      = tx_state[8];
assign sm_cpl_hdr2      = tx_state[9];
assign sm_cpl_data      = tx_state[10];       
assign sm_msi_req       = tx_state[11];
assign sm_pop_bpfifo    = tx_state[12];
assign sm_rbp_hdr1      = tx_state[13];
assign sm_rbp_hdr2      = tx_state[14];
assign sm_store_rd      = tx_state[15];
assign sm_wait          = tx_state[16];
assign sm_check_bpfifo  = tx_state[17];



/// Command FIFo Interface
assign to_pop_bpfifo  = (np_header_avail_reg & ~RdBypassFifoEmpty_i & tag_available_reg & output_fifo_ok_reg);  // will read bypass fifo on the next clock
assign CmdFifoRdReq_o = (sm_idle & ~CmdFifoEmpty_i & ~to_pop_bpfifo & txrp_sm_idle & ~RpTLPReady_i) | (sm_wr_data & RdBypassFifoEmpty_i &  ~RpTLPReady_i &  (output_fifo_ok_reg & wr_dat_cntr == 2 & ~CmdFifoEmpty_i));


// Write Data FIFO Interface
//assign WrDatFifoRdReq_o = (sm_wr_hdr1) | (sm_wr_hdr2 & addr_bit2 & is_wr_32 & wr_dat_cntr > 2)  |(sm_wr_data & output_fifo_ok_reg & wr_dat_cntr > 2); 
 assign WrDatFifoRdReq_o = msi_req_reg? 1'b0: sm_wr_hdr1 & is_wr_32 & addr_bit2 | (sm_wr_hdr2 & ~(is_wr_32 & addr_bit2 & wr_dat_cntr==2 ))  |(sm_wr_data & output_fifo_ok_reg & wr_dat_cntr > 2); 
// Output FIFO interface
assign output_fifo_wrreq =  output_fifo_ok_reg &  (sm_wr_data | sm_cpl_data) | (sm_rd_hdr1 | sm_rbp_hdr1 | sm_rd_hdr2 | sm_rbp_hdr2 | sm_wr_hdr1 | sm_wr_hdr2 | sm_cpl_hdr1 | sm_cpl_hdr2 ) |  (txrp_sm_stream0 |  txrp_sm_stream1) ;
                                             
assign tlp_data_sel[0] = (sm_wr_hdr1 | sm_rd_hdr1 | sm_rbp_hdr1 | sm_cpl_hdr1);
assign tlp_data_sel[1] = (sm_wr_hdr2 | sm_rd_hdr2 | sm_rbp_hdr2 | sm_cpl_hdr2);
assign tlp_data_sel[2] = sm_wr_data;                                             

                                             
always @*
 begin
case(tlp_data_sel[2:0])
    3'b001 :  tlp_data = cmd_header1;
    3'b010 :  tlp_data = cmd_header2;
    3'b100 :  tlp_data = wr_data;
    default:  tlp_data = tx_completion_data;
  endcase
end
//assign tlp_data =  (sm_wr_hdr1 | sm_rd_hdr1 | sm_cpl_hdr1)? cmd_header1 : (sm_wr_hdr2 | sm_rd_hdr2 | sm_cpl_hdr2)? cmd_header2 : sm_wr_data? TxWrDat_i : TxCplDat_i;
assign tlp_sop =   (sm_wr_hdr1 | sm_rd_hdr1 | sm_rbp_hdr1 | sm_cpl_hdr1);
assign tlp_eop = (sm_cpl_data & (cpl_dat_cntr == 2) & output_fifo_ok_reg) |
                 (sm_wr_data  & (wr_dat_cntr == 2) & output_fifo_ok_reg) |
                 (sm_rd_hdr2 | sm_rbp_hdr2) |
                 (sm_wr_hdr2 & is_wr_32 &  wr_dat_cntr == 2 & addr_bit2) |
                  (sm_cpl_hdr2 & ((cpl_dat_cntr ==2 & addr_bit2) | is_abort_cpl    ));

assign txrp_hi_dat_sel = txrp_sm_stream1;
assign rp_tlp_data = txrp_hi_dat_sel? TxRpFifoData_i[127:64] : TxRpFifoData_i[63:0];
assign rp_tlp_sop  = txrp_sm_stream0;
assign rp_tlp_eop  = txrp_sm_stream1 & txrp_eop;



assign output_fifo_data_in[65:0]  =  txrp_sm_idle? {tlp_eop, tlp_sop, tlp_data}  : {rp_tlp_eop, rp_tlp_sop, rp_tlp_data}; 



 always @(posedge Clk_i or negedge Rstn_i)  // state machine registers
  begin
    if(~Rstn_i)
     begin
      output_fifo_wrreq_reg <= 0;
      output_fifo_data_in_reg <= 0;
    end
    else
      begin
      output_fifo_wrreq_reg <= output_fifo_wrreq;    
      output_fifo_data_in_reg <= output_fifo_data_in;
      end
  end

// Completion DPRAM read address counter            
assign cpl_dat_clken = (sm_cpl_data & output_fifo_ok_reg) | (sm_cpl_hdr2 & addr_bit2 & ~is_abort_cpl);   
assign CplBuffRdAddr_o = cpl_dat_clken & ~is_flush_cpl? (cpl_addr_reg + 1) : cpl_addr_reg;

always @(posedge Clk_i or negedge Rstn_i)
  begin
     if(~Rstn_i)
       cpl_addr_reg <= 9'h0;
     else
       cpl_addr_reg <= CplBuffRdAddr_o;
  end

  
/// completion data counter
always @(posedge Clk_i or negedge Rstn_i)
  begin
     if(~Rstn_i)
       cpl_dat_cntr <= 10'h0;
     else if(is_cpl & sm_check_cmdfifo & addr_bit2 & ~dw_len[0]) // compensate for 2 dw overread
       cpl_dat_cntr <= dw_len + 2;
     else if(is_cpl & sm_check_cmdfifo & dw_len[0])  // compensate for 1 dw over read
       cpl_dat_cntr <= dw_len + 1;
     else if(is_cpl & sm_check_cmdfifo & ~dw_len[0] & ~addr_bit2) // no over read
       cpl_dat_cntr <= dw_len;
     else if(sm_cpl_data & cpl_dat_clken | sm_cpl_hdr2 & addr_bit2 )
       cpl_dat_cntr <= cpl_dat_cntr - 2;
  end
  
//// write data counter
/// completion data counter
always @(posedge Clk_i or negedge Rstn_i)
  begin
     if(~Rstn_i)
       wr_dat_cntr <= 10'h0;
     else if(is_wr & sm_check_cmdfifo & addr_bit2 & ~dw_len[0]) // compensate for 2 dw overread
       wr_dat_cntr <= dw_len + 2;
     else if(is_wr & sm_check_cmdfifo & dw_len[0])  // compensate for 1 dw over read
       wr_dat_cntr <= dw_len + 1;
     else if(is_wr & sm_check_cmdfifo & ~dw_len[0] & ~addr_bit2) // no over read
       wr_dat_cntr <= dw_len;   
     else if(sm_wr_data & output_fifo_ok_reg| sm_wr_hdr2 & addr_bit2 & is_wr_32)               
       wr_dat_cntr <= wr_dat_cntr - 2; 
  end

//// Completion buffer space logic to keep track of completion buffer size available
// this is checked before sending a read request to the root port

always @(posedge Clk_i or negedge Rstn_i)
  begin
    if (~Rstn_i)
      rxcplbuff_free_reg <= 1'b0;
    else
      rxcplbuff_free_reg <= RxCplBuffFree_i;
  end



assign up_cpl_cnt    = ~rxcplbuff_free_reg & RxCplBuffFree_i;   

// register the count enable and the read dw len for better fmax for better fmax
always @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      begin
       down_rddwlen2_reg <= 0;
       down_rddwlen1_reg <= 0;
       down_rddwlen_reg  <= 0; 
     end
   else
     begin
       down_rddwlen2_reg <= sm_rd_hdr1 & addr_bit2 & ~dw_len[0];
       down_rddwlen1_reg <= sm_rd_hdr1 & dw_len[0];      
       down_rddwlen_reg  <= sm_rd_hdr1& ~dw_len[0] & ~addr_bit2; 
     end  
  end


// register the desc_rdlen to lign up with the registered count enable


always @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
       desc_rdlen_reg  <= 0; 
   else
       desc_rdlen_reg  <= dw_len; 
  end


always @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
       rd_dwlen_plus1_reg  <= 0; 
   else
       rd_dwlen_plus1_reg  <= dw_len + 1; 
  end


always @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
       rd_dwlen_plus2_reg  <= 0; 
   else
       rd_dwlen_plus2_reg  <= dw_len + 2; 
  end

// note that the counter below has a high level of logic and could be pipelined
// further to register the additon/subtraction one clock before the register
// to balance the level of logic

// pipeline the counter for better fmax
// Use an accumulator to hold the number of Rx completion data freed after
// the Rx completion data has been returned to external Avalon master

assign rxcpl_cntr_unloaded =  ~( up_cpl_cnt);

always @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
     outstanding_tag_cntr <= max_outstanding_read;
    else if((sm_rd_hdr1 | sm_rbp_hdr1)  & ~up_cpl_cnt) 
      outstanding_tag_cntr <= outstanding_tag_cntr - 1;
    else if(up_cpl_cnt & ~(sm_rd_hdr1 | sm_rbp_hdr1))
      outstanding_tag_cntr <= outstanding_tag_cntr + 1;
  end

assign tag_available = (outstanding_tag_cntr != 0);
assign CplPending_o = (outstanding_tag_cntr != max_outstanding_read);

//// Tx interface to PCIe core


  
/// Write data fifo read request

// read request to cmd fifo



/// Tag ram to store read request that was sent out
//  for Rx Completion processing

// [0]   : dirty bit, has been written with data
// [1]   : all data written
// [2]   : invalid completion due to unsupported read request
// [12:3] : DW count, all 0's is 4KB
// [22:13] : Current write pointer

// Rx Completion write pointer
always @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      rxcpl_wr_ptr <= 0;
    else if((sm_rd_hdr1 | sm_rbp_hdr1)& dw_len[0])
      rxcpl_wr_ptr <= rxcpl_wr_ptr + dw_len + 1;
    else if(( sm_rd_hdr1 | sm_rbp_hdr1)& addr_bit2 & ~dw_len[0])
      rxcpl_wr_ptr <= rxcpl_wr_ptr + dw_len + 2;
    else if(sm_rd_hdr1 | sm_rbp_hdr1)
       rxcpl_wr_ptr <= rxcpl_wr_ptr + dw_len;
      
  end

//assign TxRdTagRamDat_o = {rxcpl_wr_ptr[10:1], dw_len, 1'b0, 1'b0, 1'b0};
//assign TxRdTagRamWrEna_o = sm_rd_hdr1 | sm_rbp_hdr1;
//assign TxRdTagRamWrAddr_o = req_tag[4:0];

always @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
     begin
      sm_cpldata_reg <= 1'b0;
      sm_cpl_hdr2_reg <= 1'b0;
    end
    else
     begin
      sm_cpldata_reg <= sm_cpl_data;
      sm_cpl_hdr2_reg <= sm_cpl_hdr2;
     end
  end

assign sm_cpldata_fall = (sm_idle & sm_cpldata_reg) | (sm_idle & sm_cpl_hdr2_reg);

assign TxCplSent_o = sm_cpldata_fall;  // end of CPL data phases
// number of completion qw sent register
always @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      cpl_dwsent_reg <= 0;
    else if(is_cpl & sm_check_cmdfifo & addr_bit2 & ~dw_len[0])
      cpl_dwsent_reg <= dw_len + 2;
    else if(is_cpl & sm_check_cmdfifo & dw_len[0])
      cpl_dwsent_reg <= dw_len + 1;
    else if(is_cpl & sm_check_cmdfifo)
      cpl_dwsent_reg <= dw_len;
  end
  
assign TxCplDwSent_o =  is_abort_cpl ? 0 : cpl_dwsent_reg[9:0];

/// Streaming interface to the HIP

// output registers
always @ (posedge Clk_i or negedge Rstn_i)
  begin
     if (~Rstn_i)
       tx_tlp_out_reg <= 64'h0;
     else if(fifo_transmit)
       tx_tlp_out_reg <= output_fifo_data_out[63:0];
  end

always @ (posedge Clk_i or negedge Rstn_i)
  begin
     if (~Rstn_i)
      begin
       tx_sop_out_reg <= 1'b0;
       tx_eop_out_reg <= 1'b0;
      end
     else if(fifo_transmit)
      begin
       tx_sop_out_reg <= output_fifo_data_out[64];
       tx_eop_out_reg <= output_fifo_data_out[65];
      end
     else if(output_transmit)
      begin
       tx_sop_out_reg <= 1'b0;
       tx_eop_out_reg <= 1'b0;
      end
  end
  
always @ (posedge Clk_i or negedge Rstn_i)
  begin
     if (~Rstn_i)
       output_valid_reg <= 1'b0;
     else if(fifo_transmit)
       output_valid_reg <= 1'b1;
     else if (output_transmit)
       output_valid_reg <= 1'b0;
  end
  
always @ (posedge Clk_i or negedge Rstn_i)
  begin
     if (~Rstn_i)
       fifo_valid_reg <= 1'b0;
     else if(output_fifo_rdreq)
       fifo_valid_reg <= 1'b1;
     else if (fifo_transmit)
       fifo_valid_reg <= 1'b0;
  end
  
always @ (posedge Clk_i or negedge Rstn_i)
  begin
     if (~Rstn_i)
       tx_st_ready_reg <= 1'b0;
     else
       tx_st_ready_reg <= TxStReady_i;
  end
  
  
assign output_transmit = output_valid_reg & tx_st_ready_reg;
assign fifo_transmit   = fifo_valid_reg & (~output_valid_reg | output_valid_reg & output_transmit);
assign output_fifo_rdreq = ~output_fifo_rdempty & (~fifo_valid_reg | fifo_valid_reg & fifo_transmit);

assign TxStData_o =tx_tlp_out_reg;
assign TxStSop_o  = tx_sop_out_reg;
assign TxStEop_o  = tx_eop_out_reg;
assign TxStValid_o = output_transmit;


// MSI REQUEST                
 //assign MsiReq_o = sm_msi_req & MsiCsr_i[0];
 //assign MsiReq_o = 1'b0;
 
 generate if (deviceFamily == "Stratix IV" ||  deviceFamily == "Cyclone IV GX" || deviceFamily == "HardCopy IV" || deviceFamily == "Arria II GZ" || deviceFamily == "Arria II GX" )
    begin
    	assign  MsiReq_o = sm_msi_req & MsiCsr_i[0];
    end
 else
    begin
      assign MsiReq_o = 1'b0;
    end
endgenerate

 
 // INTx Request
 
 assign IntxReq_o = 1'b0;
 
 
 /// By pass buffer control
assign RdBypassFifoWrReq_o =  sm_store_rd;             
assign RdBypassFifoRdReq_o = sm_pop_bpfifo;

/// ROOT PORT INTERFACE 

always @(posedge Clk_i or negedge Rstn_i)  // state machine registers
  begin
    if(~Rstn_i)
      txrp_state <= TXRP_IDLE;
    else
      txrp_state <= txrp_nxt_state;
  end
  
always @*
   begin
      case(txrp_state)
         TXRP_IDLE :
            if(sm_idle & output_fifo_ok_reg & RpTLPReady_i) 
               txrp_nxt_state <= TXRP_RD_FIFO;  // read fifo and start to stream
            else
               txrp_nxt_state <= TXRP_IDLE; 
         
         TXRP_RD_FIFO :
            txrp_nxt_state <= TXRP_STREAM_0; 
            
         TXRP_STREAM_0 :
             txrp_nxt_state <= TXRP_STREAM_1;
         
         TXRP_STREAM_1 :                         
              if(txrp_eop)                        
                 txrp_nxt_state <= TXRP_IDLE;     
              else                                      
                txrp_nxt_state <= TXRP_STREAM_1;          
              
        default:
          txrp_nxt_state <= TXRP_IDLE; 
      endcase
   end

assign txrp_sm_idle    = ~txrp_state[0];    
assign txrp_sm_rdfifo  = txrp_state[1];
assign txrp_sm_stream0 = txrp_state[2];
assign txrp_sm_stream1 = txrp_state[3];

assign TxRpFifoRdReq_o = txrp_sm_rdfifo | (txrp_sm_stream1 & rp_span_2cydle & ~txrp_eop);


endmodule
