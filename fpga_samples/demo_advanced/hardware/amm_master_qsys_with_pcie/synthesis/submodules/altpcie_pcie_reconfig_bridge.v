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


//Legal Notice: (C)2007 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.


//
// Avalon-MM slave bridge to the DPRIO HIP serial input
//
// Address Translation
//
// ----------------------------------------------------------
//  Addr[15:8] |
// -----------------------------------------------------------
//  0x00       |  Control register
//  0x01       |  HIP DPRIO PCIe config register
//  0x00       |  HIP DPRIO Extended register
//  Other      |  Reserved
//             |
//
// Control Register
// ----------------------------------------------------------
//  Addr[7:0]  |  Data
// -----------------------------------------------------------
//  0x00       |  Data[0]    (R/W): 0 enable dprio
//             |                    1 Disable dprio use csr
//             |                     (--> original configuration)
//             |
//             |  Data[1]    (R/W): RESERVED
//             |  Data[2]    (R/W): Indicate error : Unsupported write address
//             |  Data[3]    (R/W): Indicate error : Unsupported read address
//             |  Data[4]    (R/W): Enable extended dprio access
//             |                    in addition to PCIe address
//             |  Data[15:1] (R/W): RESERVED
//  0x01       |  Data[4:0]  (R/W): Device address
//             |  Data[9:5]  (R/W): port address
//  0x02       |  Data[8:0]  (R/W): bases address
//  0x03       |  Data[15:0] (R/W): when 16'hED10  enable dprio accross all register

// HIP DPRIO Register
// -----------------------------------------------------------
//  Addr[7:0]  |  Data
// -----------------------------------------------------------
//  0x00  0x08 | reserved
//  0x09  0x20 | k_conf
//  0x21  0x2F | k_bar
//  0x30  0x37 | k_cnt
//  0x38  0x3B | k_vc0
//  0x3C  0x3F | k_vc1
//  0x40  0x58 | reserved
//  0x59  0x5B | k_ptr0
//  0x5C  0x5E | k_ptr1
//  0x5F  0xFF | reserved

`timescale 1ns / 1ps

module altpcie_pcie_reconfig_bridge (

  input [  7: 0]     avs_pcie_reconfig_address,
  input              avs_pcie_reconfig_chipselect,
  input              avs_pcie_reconfig_write,
  input [ 15: 0]     avs_pcie_reconfig_writedata,
  output reg         avs_pcie_reconfig_waitrequest,
  input              avs_pcie_reconfig_read,
  output reg [15: 0] avs_pcie_reconfig_readdata,
  output reg         avs_pcie_reconfig_readdatavalid,
  input              avs_pcie_reconfig_clk, // 50 MHz
  input              avs_pcie_reconfig_rstn,

  // DPRIO Interface
   output   reg dpriodisable,
   output   reg dprioin,
   output   reg dprioload,
   output   dpclk,
   input    dprioout

   );

parameter device_address=0;
parameter port_address  =0;
parameter base_address  =0;
parameter implement_address_checking  =1;

localparam IDLE_ST            =0,
           CHECK_ADDR_ST      =1,
           MDIO_START_ST      =2,
           CTRL_WR_ST         =3,
           CTRL_RD_ST         =4,
           ERR_ST             =5,
           MDIO_CLR_ST        =6,
           MDIO_PRE_ST        =7,
           MDIO_FRAME_ST      =8,
           CLEAR_WAITREQ_ST   =9;

localparam  MDIO_ADDR   =2'b00,
            MDIO_WRITE  =2'b01,
            MDIO_READ   =2'b10,
            MDIO_END    =2'b11;

reg [3:0] cstate;
reg [3:0] nstate;
reg [1:0] error_status;

reg  [4:0] hip_dev_addr;
reg  [4:0] hip_port_addr;
reg  [7:0] hip_base_addr;

reg [31:0] shift_dprioin;
reg [15:0] shift_dprioout;
reg [6:0]  count_mdio_st;
reg [1:0]  mdio_cycle;
reg        read_cycle;
reg        write_cycle;
wire       valid_address;
reg        valid_addrreg;
reg        extended_dprio_access;

   assign dpclk         = avs_pcie_reconfig_clk;

   // state machine
   always @*
   case (cstate)
   //TODO : Confirm that Avalon-MM read and write at the same time is illegal
   //TODO : Confirm that read or write, chipselect can not be de-asserted until
   //       waitrequest is de-asserted
      IDLE_ST: begin
         if ((avs_pcie_reconfig_readdatavalid==1'b0)&&(avs_pcie_reconfig_chipselect==1'b1))
            nstate <= CHECK_ADDR_ST;
         else
            nstate <= IDLE_ST;
      end
      CHECK_ADDR_ST:
      begin
         if (valid_address==1'b0)
            nstate <= ERR_ST;
         else if (avs_pcie_reconfig_address[7] == 1'b1)
            nstate <= MDIO_START_ST;
         else if (write_cycle==1'b1)
            nstate <= CTRL_WR_ST;
         else if (read_cycle==1'b1)
            nstate <= CTRL_RD_ST;
         else
            nstate <= IDLE_ST;
      end
      MDIO_START_ST:
         nstate <= MDIO_CLR_ST;
      CTRL_WR_ST:
         nstate <= CLEAR_WAITREQ_ST;
      CTRL_RD_ST:
         nstate <= CLEAR_WAITREQ_ST;
      ERR_ST:
         nstate <= CLEAR_WAITREQ_ST;
      MDIO_CLR_ST:
      //send 16 zero's to clear the MDIO state machine
      //TODO : Check if it's necessary for every read/write transaction or if it's only
      // necessary after the first reset
         if (count_mdio_st==0)  begin
            if (mdio_cycle==MDIO_END)
               nstate <= CLEAR_WAITREQ_ST;
            else
               nstate <= MDIO_PRE_ST;
         end
         else
            nstate <= MDIO_CLR_ST;
      MDIO_PRE_ST:
      // Preamble 32-bit 1's
         if (count_mdio_st==0)
            nstate <= MDIO_FRAME_ST;
         else
            nstate <= MDIO_PRE_ST;
      MDIO_FRAME_ST:
         if (count_mdio_st==0) begin
            if (mdio_cycle==MDIO_END)
               nstate <= MDIO_CLR_ST;
            else
               nstate <= MDIO_PRE_ST;
         end
         else
            nstate <= MDIO_FRAME_ST;
      CLEAR_WAITREQ_ST:
         nstate <= IDLE_ST;
      default:
         nstate <= IDLE_ST;
   endcase

   always @ (negedge avs_pcie_reconfig_rstn or posedge avs_pcie_reconfig_clk) begin
      if (avs_pcie_reconfig_rstn==1'b0)
         cstate <= IDLE_ST;
      else
         cstate <= nstate;
   end

   always @ (negedge avs_pcie_reconfig_rstn or posedge avs_pcie_reconfig_clk) begin
      if (avs_pcie_reconfig_rstn==1'b0)
         mdio_cycle <= MDIO_ADDR;
      else if (cstate==MDIO_START_ST)
         mdio_cycle <= MDIO_ADDR;
      else if ((cstate==MDIO_FRAME_ST) && (count_mdio_st==6'h1F)) begin
         if ((mdio_cycle==MDIO_ADDR) && (write_cycle==1'b1))
            mdio_cycle <= MDIO_WRITE;
         else if ((mdio_cycle==MDIO_ADDR) && (read_cycle==1'b1))
            mdio_cycle <= MDIO_READ;
         else if ((mdio_cycle==MDIO_WRITE) || (mdio_cycle==MDIO_READ))
            mdio_cycle <= MDIO_END;
      end
   end

   always @ (negedge avs_pcie_reconfig_rstn or posedge avs_pcie_reconfig_clk) begin
   //TODO Use multiple counter if speed is an issue
      if (avs_pcie_reconfig_rstn==1'b0)
         count_mdio_st <= 0;
      else if (cstate==MDIO_START_ST)
         count_mdio_st <= 6'hF;
      else if (cstate==MDIO_CLR_ST) begin
         if (count_mdio_st>0)
            count_mdio_st<=count_mdio_st-1;
         else
            count_mdio_st<=6'h1F;
      end
      else if ((cstate==MDIO_PRE_ST)||(cstate==MDIO_FRAME_ST)) begin
         if (count_mdio_st>0)
            count_mdio_st<=count_mdio_st-1;
         else if (mdio_cycle==MDIO_END)
            count_mdio_st <= 6'hF;
         else
            count_mdio_st<=6'h1F;
      end
      else
         count_mdio_st <= 0;
   end

   // MDIO dprioin, dprioload
   always @ (negedge avs_pcie_reconfig_rstn or posedge avs_pcie_reconfig_clk) begin
      if (avs_pcie_reconfig_rstn==1'b0)
         shift_dprioin <= 32'h0;
      else if (cstate==MDIO_PRE_ST) begin
         // ST bits - Start of frame
         shift_dprioin[31:30]<=2'b00;
         // OP bits - Op Codes
         if (mdio_cycle==MDIO_ADDR)
            shift_dprioin[29:28]<=2'b00;
         else if (mdio_cycle == MDIO_WRITE)
            shift_dprioin[29:28]<=2'b01;
         else  // READ
            shift_dprioin[29:28]=2'b11;
         // Port, Device address
         shift_dprioin[27:18] <= {port_address[4:0], device_address[4:0]};
         // TA Bits Turnaround
         // TODO : Check TA bit 0 which supposed to be Z for read?
         shift_dprioin[17:16] <= 2'b10;
         if (mdio_cycle==MDIO_ADDR)
         // 0x80 is the range for vendor specific (altera) registers according to XAUI spec
            shift_dprioin[15:0] = {8'h80,1'b0,avs_pcie_reconfig_address[6:0]};
         else if (mdio_cycle==MDIO_WRITE)
            shift_dprioin[15:0] = avs_pcie_reconfig_writedata[15:0];
         else if (mdio_cycle==MDIO_READ)
            shift_dprioin[15:0] = avs_pcie_reconfig_writedata[15:0];
      end
      else if (cstate==MDIO_FRAME_ST)
         shift_dprioin[31:0] <= {shift_dprioin[30:0],1'b0};
   end

   always @ (negedge avs_pcie_reconfig_rstn or posedge avs_pcie_reconfig_clk) begin
      if (avs_pcie_reconfig_rstn==1'b0) begin
         dprioin     <= 1'b0;
      end
      else if (cstate==MDIO_CLR_ST) begin
         if (count_mdio_st>0)
            dprioin     <= 1'b0;
         else if (mdio_cycle==MDIO_END)
            dprioin     <= 1'b0;
         else
            dprioin     <= 1'b1;
      end
      else if (cstate==MDIO_PRE_ST) begin
         if (count_mdio_st>0)
            dprioin     <= 1'b1;
         else
            dprioin     <= shift_dprioin[31];
      end
      else if (cstate==MDIO_FRAME_ST) begin
      // MDIO : MSB first
         if (count_mdio_st>0)
            dprioin     <= shift_dprioin[30];
         else if (mdio_cycle==MDIO_END)
            dprioin <=1'b0;
         else
            dprioin <=1'b1;
      end
      else
         dprioin     <= 1'b0;
   end

   always @ (negedge avs_pcie_reconfig_rstn or posedge avs_pcie_reconfig_clk) begin
      if (avs_pcie_reconfig_rstn==1'b0)
         shift_dprioout <= 16'h0;
      else
         shift_dprioout[15:0] <= {shift_dprioout[14:0],dprioout};
   end

   // MDIO and status registers  dpriodisable , dprioload
   always @ (negedge avs_pcie_reconfig_rstn or posedge avs_pcie_reconfig_clk) begin
      if (avs_pcie_reconfig_rstn==1'b0) begin
         dpriodisable <= 1'b1;
         dprioload    <= 1'b0;
         extended_dprio_access <=1'b0;
      end
      else if ((cstate==CTRL_WR_ST) &&
               (avs_pcie_reconfig_address[6:0] == 7'h00 )) begin
         dpriodisable <= avs_pcie_reconfig_writedata[0];
         dprioload    <= ~avs_pcie_reconfig_writedata[0];
      end
      else if ((cstate==CTRL_WR_ST) &&
               (avs_pcie_reconfig_address[6:0] == 7'h03 )) begin
         extended_dprio_access <= (avs_pcie_reconfig_writedata==16'hED10)?1'b1:1'b0;
      end
   end

   // Avalon-MM Wait request
   always @ (negedge avs_pcie_reconfig_rstn or posedge avs_pcie_reconfig_clk) begin
      if (avs_pcie_reconfig_rstn==1'b0)
         avs_pcie_reconfig_waitrequest <= 1'b1;
      else if (nstate == CLEAR_WAITREQ_ST)
         avs_pcie_reconfig_waitrequest <= 1'b0;
      else
         avs_pcie_reconfig_waitrequest <= 1'b1;
   end

   // Error Status registers
   always @ (negedge avs_pcie_reconfig_rstn or posedge avs_pcie_reconfig_clk) begin
      if (avs_pcie_reconfig_rstn==1'b0)
         error_status[1:0] <= 2'b00;
      else if (cstate==ERR_ST) begin
         if (write_cycle==1'b1)
            error_status[0] <= 1'b1;
         if (read_cycle==1'b1)
            error_status[1] <= 1'b1;
      end
      else if ((cstate == CTRL_WR_ST) &&
                  (avs_pcie_reconfig_address[6:0] == 7'h00))
         // Clear error status registers
         error_status[1:0] <= avs_pcie_reconfig_writedata[3:2];
      end

   always @ (negedge avs_pcie_reconfig_rstn or posedge avs_pcie_reconfig_clk) begin
      if (avs_pcie_reconfig_rstn==1'b0) begin
         // Default parameter
         hip_dev_addr   <= device_address;
         hip_port_addr  <= port_address;
      end
      else if ((cstate==CTRL_WR_ST) &&
               (avs_pcie_reconfig_address[6:0] == 7'h01 )) begin
         hip_dev_addr   <= avs_pcie_reconfig_writedata[4:0];
         hip_port_addr  <= avs_pcie_reconfig_writedata[9:5];
      end
   end

   always @ (negedge avs_pcie_reconfig_rstn or posedge avs_pcie_reconfig_clk) begin
      if (avs_pcie_reconfig_rstn==1'b0)
         // Default parameter
         hip_base_addr  <= base_address;
      else if ((cstate==CTRL_WR_ST) &&
               (avs_pcie_reconfig_address[6:0] == 7'h02 ))
         hip_base_addr   <= avs_pcie_reconfig_writedata[7:0];
   end

   always @ (posedge avs_pcie_reconfig_clk) begin
      if (cstate==IDLE_ST)
         avs_pcie_reconfig_readdata      <= 16'hFFFF;
      else if (cstate==CTRL_RD_ST)
         case (avs_pcie_reconfig_address[6:0])
            7'h0     : avs_pcie_reconfig_readdata <= {12'h0,error_status[1:0], 1'b0, dpriodisable};
            7'h1     : avs_pcie_reconfig_readdata <= {6'h0,hip_dev_addr[4:0], hip_port_addr[4:0]};
            7'h2     : avs_pcie_reconfig_readdata <= {8'h0,hip_base_addr[7:0]};
            7'h3     : avs_pcie_reconfig_readdata <= 16'hFADE;
            default  : avs_pcie_reconfig_readdata <= 16'hFFFF;
         endcase
      else if ((cstate==MDIO_CLR_ST)&&(count_mdio_st==6'hF))
         avs_pcie_reconfig_readdata  <= shift_dprioout;
   end

   always @ (posedge avs_pcie_reconfig_clk) begin
      if ((cstate==CLEAR_WAITREQ_ST)&&(read_cycle==1'b1))
         avs_pcie_reconfig_readdatavalid <=1'b1;
      else
         avs_pcie_reconfig_readdatavalid <=1'b0;
   end

   always @ (negedge avs_pcie_reconfig_rstn or posedge avs_pcie_reconfig_clk) begin
      if (avs_pcie_reconfig_rstn==1'b0) begin
         read_cycle  <= 1'b0;
         write_cycle <= 1'b0;
      end
      else if ((cstate==IDLE_ST) && (avs_pcie_reconfig_chipselect==1'b1)) begin
         read_cycle  <= avs_pcie_reconfig_read;
         write_cycle <= avs_pcie_reconfig_write;
      end
   end

   assign valid_address = (implement_address_checking==0)?1'b1:valid_addrreg;

   always @ (negedge avs_pcie_reconfig_rstn or posedge avs_pcie_reconfig_clk) begin
      if (avs_pcie_reconfig_rstn==1'b0)
         valid_addrreg  <= 1'b1;
      else if (cstate==IDLE_ST) begin
         if (avs_pcie_reconfig_address[7]==1'b0) begin
         // Control register address space
            if (avs_pcie_reconfig_address[6:0] > 7'h4)
               valid_addrreg <=1'b0;
            else
               valid_addrreg <=1'b1;
         end
         else begin
         // MDIO register HIP address space
            if ((avs_pcie_reconfig_address[6:0] < 7'h9) && (extended_dprio_access==1'b0))
               valid_addrreg <=1'b0;
            else if ((avs_pcie_reconfig_address[6:0] > 7'h5E) && (extended_dprio_access==1'b0))
               valid_addrreg <=1'b0;
            else if ((avs_pcie_reconfig_address[6:0]>7'h40)&&(avs_pcie_reconfig_address[6:0]<7'h59) && (extended_dprio_access==1'b0))
               valid_addrreg <=1'b0;
            else
               valid_addrreg <=1'b1;
         end
      end
   end
endmodule
