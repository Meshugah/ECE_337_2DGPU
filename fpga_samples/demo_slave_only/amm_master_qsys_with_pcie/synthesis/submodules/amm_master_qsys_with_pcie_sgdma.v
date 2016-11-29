//Legal Notice: (C)2015 Altera Corporation. All rights reserved.  Your
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

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module control_status_slave_which_resides_within_amm_master_qsys_with_pcie_sgdma (
                                                                                   // inputs:
                                                                                    atlantic_error,
                                                                                    chain_run,
                                                                                    clk,
                                                                                    command_fifo_empty,
                                                                                    csr_address,
                                                                                    csr_chipselect,
                                                                                    csr_read,
                                                                                    csr_write,
                                                                                    csr_writedata,
                                                                                    desc_address_fifo_empty,
                                                                                    descriptor_read_address,
                                                                                    descriptor_read_read,
                                                                                    descriptor_write_busy,
                                                                                    descriptor_write_write,
                                                                                    owned_by_hw,
                                                                                    read_go,
                                                                                    reset_n,
                                                                                    status_token_fifo_empty,
                                                                                    status_token_fifo_rdreq,
                                                                                    write_go,

                                                                                   // outputs:
                                                                                    csr_irq,
                                                                                    csr_readdata,
                                                                                    descriptor_pointer_lower_reg_out,
                                                                                    descriptor_pointer_upper_reg_out,
                                                                                    park,
                                                                                    pollen_clear_run,
                                                                                    run,
                                                                                    sw_reset
                                                                                 )
;

  output           csr_irq;
  output  [ 31: 0] csr_readdata;
  output  [ 31: 0] descriptor_pointer_lower_reg_out;
  output  [ 31: 0] descriptor_pointer_upper_reg_out;
  output           park;
  output           pollen_clear_run;
  output           run;
  output           sw_reset;
  input            atlantic_error;
  input            chain_run;
  input            clk;
  input            command_fifo_empty;
  input   [  3: 0] csr_address;
  input            csr_chipselect;
  input            csr_read;
  input            csr_write;
  input   [ 31: 0] csr_writedata;
  input            desc_address_fifo_empty;
  input   [ 31: 0] descriptor_read_address;
  input            descriptor_read_read;
  input            descriptor_write_busy;
  input            descriptor_write_write;
  input            owned_by_hw;
  input            read_go;
  input            reset_n;
  input            status_token_fifo_empty;
  input            status_token_fifo_rdreq;
  input            write_go;

  reg              busy;
  reg              can_have_new_chain_complete;
  reg              chain_completed;
  reg              chain_completed_int;
  wire             chain_completed_int_rise;
  wire             clear_chain_completed;
  wire             clear_descriptor_completed;
  wire             clear_error;
  reg              clear_interrupt;
  wire             clear_run;
  reg     [ 31: 0] control_reg;
  wire             control_reg_en;
  wire             csr_control;
  reg              csr_irq;
  reg     [ 31: 0] csr_readdata;
  wire             csr_status;
  reg              delayed_chain_completed_int;
  reg              delayed_csr_write;
  reg     [  7: 0] delayed_descriptor_counter;
  reg              delayed_descriptor_write_write;
  reg              delayed_eop_encountered;
  wire    [  7: 0] delayed_max_desc_processed;
  reg              delayed_run;
  reg              descriptor_completed;
  reg     [  7: 0] descriptor_counter;
  wire    [ 31: 0] descriptor_pointer_data;
  reg     [ 31: 0] descriptor_pointer_lower_reg;
  wire             descriptor_pointer_lower_reg_en;
  wire    [ 31: 0] descriptor_pointer_lower_reg_out;
  reg     [ 31: 0] descriptor_pointer_upper_reg;
  wire             descriptor_pointer_upper_reg_en;
  wire    [ 31: 0] descriptor_pointer_upper_reg_out;
  reg              descriptor_read_read_r;
  wire             descriptor_read_read_rising;
  wire             descriptor_write_write_fall;
  reg              do_restart;
  reg              do_restart_compare;
  wire             eop_encountered;
  wire             eop_encountered_rise;
  reg              error;
  wire    [  3: 0] hw_version;
  wire             ie_chain_completed;
  wire             ie_descriptor_completed;
  wire             ie_eop_encountered;
  wire             ie_error;
  wire             ie_global;
  wire             ie_max_desc_processed;
  wire    [  7: 0] max_desc_processed;
  wire             park;
  wire             poll_en;
  wire             pollen_clear_run;
  wire             run;
  wire    [ 31: 0] status_reg;
  wire             stop_dma_error;
  wire             sw_reset;
  reg     [ 15: 0] timeout_counter;
  wire    [ 10: 0] timeout_reg;
  wire             version_reg;
  //csr, which is an e_avalon_slave
  //Control Status Register (Readdata)
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          csr_readdata <= 0;
      else if (csr_read)
          case (csr_address) // synthesis parallel_case
          
              {4'b0000}: begin
                  csr_readdata <= status_reg;
              end // {4'b0000} 
          
              {4'b0001}: begin
                  csr_readdata <= version_reg;
              end // {4'b0001} 
          
              {4'b0100}: begin
                  csr_readdata <= control_reg;
              end // {4'b0100} 
          
              {4'b1000}: begin
                  csr_readdata <= descriptor_pointer_lower_reg;
              end // {4'b1000} 
          
              {4'b1100}: begin
                  csr_readdata <= descriptor_pointer_upper_reg;
              end // {4'b1100} 
          
              default: begin
                  csr_readdata <= 32'b0;
              end // default
          
          endcase // csr_address
    end


  //register outs
  assign descriptor_pointer_upper_reg_out = descriptor_pointer_upper_reg;
  assign descriptor_pointer_lower_reg_out = descriptor_pointer_lower_reg;
  //control register bits
  assign ie_error = control_reg[0];
  assign ie_eop_encountered = control_reg[1];
  assign ie_descriptor_completed = control_reg[2];
  assign ie_chain_completed = control_reg[3];
  assign ie_global = control_reg[4];
  assign run = control_reg[5] && (!(stop_dma_error && error) && ((!chain_completed_int ) ||( do_restart && poll_en && chain_completed_int)));
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_run <= 0;
      else 
        delayed_run <= run;
    end


  assign stop_dma_error = control_reg[6];
  assign ie_max_desc_processed = control_reg[7];
  assign max_desc_processed = control_reg[15 : 8];
  assign sw_reset = control_reg[16];
  assign park = control_reg[17];
  assign poll_en = control_reg[18];
  assign timeout_reg = control_reg[30 : 20];
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          timeout_counter <= 0;
      else if ((control_reg[5] && !busy && poll_en )|| do_restart)
          timeout_counter <= do_restart ? 0:(timeout_counter + 1'b1);
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          do_restart_compare <= 0;
      else 
        do_restart_compare <= timeout_counter == {timeout_reg,5'b11111};
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          do_restart <= 0;
      else 
        do_restart <= poll_en && do_restart_compare;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          clear_interrupt <= 0;
      else 
        clear_interrupt <= control_reg_en ? csr_writedata[31] : 0;
    end


  //control register
  assign control_reg_en = (csr_address == { 4'b0100}) && csr_write && csr_chipselect;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          control_reg <= 0;
      else if (control_reg_en)
          control_reg <= {1'b0, csr_writedata[30 : 0]};
    end


  //descriptor_pointer_upper_reg
  assign descriptor_pointer_upper_reg_en = (csr_address == { 4'b1100}) && csr_write && csr_chipselect;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_pointer_upper_reg <= 0;
      else if (descriptor_pointer_upper_reg_en)
          descriptor_pointer_upper_reg <= csr_writedata;
    end


  //section to update the descriptor pointer
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_read_read_r <= 0;
      else 
        descriptor_read_read_r <= descriptor_read_read;
    end


  assign descriptor_read_read_rising = descriptor_read_read && !descriptor_read_read_r;
  assign descriptor_pointer_data = descriptor_read_read_rising ? descriptor_read_address:csr_writedata;
  //descriptor_pointer_lower_reg
  assign descriptor_pointer_lower_reg_en = ((csr_address == { 4'b1000}) && csr_write && csr_chipselect) || (poll_en && descriptor_read_read_rising);
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_pointer_lower_reg <= 0;
      else if (descriptor_pointer_lower_reg_en)
          descriptor_pointer_lower_reg <= descriptor_pointer_data;
    end


  //Hardware Version Register
  assign hw_version = 4'b0001;
  assign version_reg = {24'h000000, hw_version};
  //status register
  assign status_reg = {27'b0, busy, chain_completed, descriptor_completed, eop_encountered, error};
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          busy <= 0;
      else 
        busy <= ~command_fifo_empty || ~status_token_fifo_empty || ~desc_address_fifo_empty || chain_run || descriptor_write_busy || delayed_csr_write || owned_by_hw || write_go || read_go;
    end


  //Chain Completed Status Register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          chain_completed <= 0;
      else if ((run && ~owned_by_hw && ~busy) || clear_chain_completed || do_restart)
          chain_completed <= (clear_chain_completed || do_restart)? 1'b0 : ~delayed_csr_write;
    end


  //chain_completed_int is the internal chain completed state for SGDMA.
  //Will not be affected with clearing of chain_completed Status Register,to prevent SGDMA being restarted when the status bit is cleared
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          chain_completed_int <= 0;
      else if ((run && ~owned_by_hw && ~busy) || clear_run || do_restart)
          chain_completed_int <= (clear_run || do_restart) ? 1'b0 : ~delayed_csr_write;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_csr_write <= 0;
      else 
        delayed_csr_write <= csr_write;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_completed <= 0;
      else if (descriptor_write_write_fall || clear_descriptor_completed)
          descriptor_completed <= ~clear_descriptor_completed;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          error <= 0;
      else if (atlantic_error || clear_error)
          error <= ~clear_error;
    end


  assign csr_status = csr_write && csr_chipselect && (csr_address == 4'b0);
  assign clear_chain_completed = csr_writedata[3] && csr_status;
  assign clear_descriptor_completed = csr_writedata[2] && csr_status;
  assign clear_error = csr_writedata[0] && csr_status;
  assign csr_control = csr_write && csr_chipselect && (csr_address == 4'h4);
  assign clear_run = !csr_writedata[5] && csr_control;
  assign pollen_clear_run = poll_en & clear_run;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_eop_encountered <= 0;
      else 
        delayed_eop_encountered <= eop_encountered;
    end


  assign eop_encountered_rise = ~delayed_eop_encountered && eop_encountered;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_descriptor_write_write <= 0;
      else 
        delayed_descriptor_write_write <= descriptor_write_write;
    end


  assign descriptor_write_write_fall = delayed_descriptor_write_write && ~descriptor_write_write;
  assign eop_encountered = 1'b0;
  //chain_completed rising edge detector
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_chain_completed_int <= 0;
      else 
        delayed_chain_completed_int <= chain_completed_int;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          can_have_new_chain_complete <= 0;
      else if (descriptor_write_write || (~delayed_chain_completed_int && chain_completed_int))
          can_have_new_chain_complete <= descriptor_write_write;
    end


  assign chain_completed_int_rise = ~delayed_chain_completed_int && chain_completed_int && can_have_new_chain_complete;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_counter <= 0;
      else if (status_token_fifo_rdreq)
          descriptor_counter <= descriptor_counter + 1'b1;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_descriptor_counter <= 0;
      else 
        delayed_descriptor_counter <= descriptor_counter;
    end


  assign delayed_max_desc_processed = max_desc_processed - 1;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          csr_irq <= 0;
      else 
        csr_irq <= csr_irq ? ~clear_interrupt : (delayed_run && ie_global && ((ie_error && error) || (ie_eop_encountered && eop_encountered_rise) || (ie_descriptor_completed && descriptor_write_write_fall) || (ie_chain_completed && chain_completed_int_rise) || (ie_max_desc_processed && (descriptor_counter == max_desc_processed) && (delayed_descriptor_counter == delayed_max_desc_processed) )));
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module descriptor_read_which_resides_within_amm_master_qsys_with_pcie_sgdma_control_bits_fifo (
                                                                                                // inputs:
                                                                                                 clk,
                                                                                                 controlbitsfifo_data,
                                                                                                 controlbitsfifo_rdreq,
                                                                                                 controlbitsfifo_wrreq,
                                                                                                 reset,

                                                                                                // outputs:
                                                                                                 controlbitsfifo_empty,
                                                                                                 controlbitsfifo_full,
                                                                                                 controlbitsfifo_q
                                                                                              )
;

  output           controlbitsfifo_empty;
  output           controlbitsfifo_full;
  output  [  6: 0] controlbitsfifo_q;
  input            clk;
  input   [  6: 0] controlbitsfifo_data;
  input            controlbitsfifo_rdreq;
  input            controlbitsfifo_wrreq;
  input            reset;

  wire             controlbitsfifo_empty;
  wire             controlbitsfifo_full;
  wire    [  6: 0] controlbitsfifo_q;
  scfifo descriptor_read_which_resides_within_amm_master_qsys_with_pcie_sgdma_control_bits_fifo_controlbitsfifo
    (
      .aclr (reset),
      .clock (clk),
      .data (controlbitsfifo_data),
      .empty (controlbitsfifo_empty),
      .full (controlbitsfifo_full),
      .q (controlbitsfifo_q),
      .rdreq (controlbitsfifo_rdreq),
      .wrreq (controlbitsfifo_wrreq)
    );

  defparam descriptor_read_which_resides_within_amm_master_qsys_with_pcie_sgdma_control_bits_fifo_controlbitsfifo.add_ram_output_register = "ON",
           descriptor_read_which_resides_within_amm_master_qsys_with_pcie_sgdma_control_bits_fifo_controlbitsfifo.intended_device_family = "CYCLONEIVGX",
           descriptor_read_which_resides_within_amm_master_qsys_with_pcie_sgdma_control_bits_fifo_controlbitsfifo.lpm_numwords = 2,
           descriptor_read_which_resides_within_amm_master_qsys_with_pcie_sgdma_control_bits_fifo_controlbitsfifo.lpm_showahead = "OFF",
           descriptor_read_which_resides_within_amm_master_qsys_with_pcie_sgdma_control_bits_fifo_controlbitsfifo.lpm_type = "scfifo",
           descriptor_read_which_resides_within_amm_master_qsys_with_pcie_sgdma_control_bits_fifo_controlbitsfifo.lpm_width = 7,
           descriptor_read_which_resides_within_amm_master_qsys_with_pcie_sgdma_control_bits_fifo_controlbitsfifo.lpm_widthu = 1,
           descriptor_read_which_resides_within_amm_master_qsys_with_pcie_sgdma_control_bits_fifo_controlbitsfifo.overflow_checking = "ON",
           descriptor_read_which_resides_within_amm_master_qsys_with_pcie_sgdma_control_bits_fifo_controlbitsfifo.underflow_checking = "ON",
           descriptor_read_which_resides_within_amm_master_qsys_with_pcie_sgdma_control_bits_fifo_controlbitsfifo.use_eab = "OFF";


endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module descriptor_read_which_resides_within_amm_master_qsys_with_pcie_sgdma (
                                                                              // inputs:
                                                                               clk,
                                                                               command_fifo_full,
                                                                               controlbitsfifo_rdreq,
                                                                               desc_address_fifo_full,
                                                                               descriptor_pointer_lower_reg_out,
                                                                               descriptor_pointer_upper_reg_out,
                                                                               descriptor_read_readdata,
                                                                               descriptor_read_readdatavalid,
                                                                               descriptor_read_waitrequest,
                                                                               pollen_clear_run,
                                                                               reset,
                                                                               reset_n,
                                                                               run,

                                                                              // outputs:
                                                                               atlantic_channel,
                                                                               chain_run,
                                                                               command_fifo_data,
                                                                               command_fifo_wrreq,
                                                                               control,
                                                                               controlbitsfifo_q,
                                                                               desc_address_fifo_data,
                                                                               desc_address_fifo_wrreq,
                                                                               descriptor_read_address,
                                                                               descriptor_read_read,
                                                                               generate_eop,
                                                                               next_desc,
                                                                               owned_by_hw,
                                                                               read_fixed_address,
                                                                               write_fixed_address
                                                                            )
;

  output  [  3: 0] atlantic_channel;
  output           chain_run;
  output  [103: 0] command_fifo_data;
  output           command_fifo_wrreq;
  output  [  7: 0] control;
  output  [  6: 0] controlbitsfifo_q;
  output  [ 31: 0] desc_address_fifo_data;
  output           desc_address_fifo_wrreq;
  output  [ 31: 0] descriptor_read_address;
  output           descriptor_read_read;
  output           generate_eop;
  output  [ 31: 0] next_desc;
  output           owned_by_hw;
  output           read_fixed_address;
  output           write_fixed_address;
  input            clk;
  input            command_fifo_full;
  input            controlbitsfifo_rdreq;
  input            desc_address_fifo_full;
  input   [ 31: 0] descriptor_pointer_lower_reg_out;
  input   [ 31: 0] descriptor_pointer_upper_reg_out;
  input   [ 31: 0] descriptor_read_readdata;
  input            descriptor_read_readdatavalid;
  input            descriptor_read_waitrequest;
  input            pollen_clear_run;
  input            reset;
  input            reset_n;
  input            run;

  wire    [  3: 0] atlantic_channel;
  wire    [ 15: 0] bytes_to_transfer;
  reg              chain_run;
  wire    [103: 0] command_fifo_data;
  reg              command_fifo_wrreq;
  wire             command_fifo_wrreq_in;
  wire    [  7: 0] control;
  wire    [  6: 0] controlbitsfifo_data;
  wire             controlbitsfifo_empty;
  wire             controlbitsfifo_full;
  wire    [  6: 0] controlbitsfifo_q;
  wire             controlbitsfifo_wrreq;
  reg              delayed_desc_reg_en;
  reg              delayed_run;
  reg     [ 31: 0] desc_address_fifo_data;
  wire             desc_address_fifo_wrreq;
  reg     [255: 0] desc_assembler;
  reg              desc_read_start;
  reg     [255: 0] desc_reg;
  wire             desc_reg_en;
  reg     [ 31: 0] descriptor_read_address;
  reg              descriptor_read_completed;
  wire             descriptor_read_completed_in;
  reg              descriptor_read_read;
  wire             fifos_not_full;
  wire             generate_eop;
  wire             got_one_descriptor;
  wire    [255: 0] init_descriptor;
  wire    [ 31: 0] next_desc;
  wire             owned_by_hw;
  wire    [255: 0] pollen_clear_run_desc;
  reg     [  3: 0] posted_desc_counter;
  reg              posted_read_queued;
  wire    [ 31: 0] read_address;
  wire    [  7: 0] read_burst;
  wire             read_fixed_address;
  reg     [  3: 0] received_desc_counter;
  reg              run_rising_edge;
  wire             run_rising_edge_in;
  reg              started;
  wire             started_in;
  wire    [ 31: 0] write_address;
  wire    [  7: 0] write_burst;
  wire             write_fixed_address;
  //descriptor_read, which is an e_avalon_master
  //Control assignments
  assign command_fifo_wrreq_in = chain_run && fifos_not_full && delayed_desc_reg_en && owned_by_hw;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          command_fifo_wrreq <= 0;
      else 
        command_fifo_wrreq <= command_fifo_wrreq_in;
    end


  assign desc_address_fifo_wrreq = command_fifo_wrreq;
  assign fifos_not_full = ~command_fifo_full && ~desc_address_fifo_full;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_desc_reg_en <= 0;
      else 
        delayed_desc_reg_en <= desc_reg_en;
    end


  assign read_address = desc_reg[31 : 0];
  assign write_address = desc_reg[95 : 64];
  assign next_desc = desc_reg[159 : 128];
  assign bytes_to_transfer = desc_reg[207 : 192];
  assign read_burst = desc_reg[215 : 208];
  assign write_burst = desc_reg[223 : 216];
  assign control = desc_reg[255 : 248];
  assign command_fifo_data = {control, write_burst, read_burst, bytes_to_transfer, write_address, read_address};
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          desc_address_fifo_data <= 0;
      else if (desc_reg_en)
          desc_address_fifo_data <= next_desc;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          received_desc_counter <= 0;
      else 
        received_desc_counter <= (received_desc_counter == 8)? 0 : (descriptor_read_readdatavalid ? (received_desc_counter + 1) : received_desc_counter);
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          posted_desc_counter <= 0;
      else 
        posted_desc_counter <= (desc_read_start & owned_by_hw & (posted_desc_counter != 8)) ? 8 : ((|posted_desc_counter & ~descriptor_read_waitrequest & fifos_not_full) ? (posted_desc_counter - 1) : posted_desc_counter);
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          desc_read_start <= 0;
      else if (~descriptor_read_waitrequest)
          desc_read_start <= desc_read_start ? 0 : ((~(desc_reg_en | delayed_desc_reg_en | command_fifo_wrreq | |received_desc_counter)) ? (chain_run & fifos_not_full & ~|posted_desc_counter & ~posted_read_queued) : 0);
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          chain_run <= 0;
      else 
        chain_run <= (run && owned_by_hw | (delayed_desc_reg_en | desc_reg_en) | |posted_desc_counter | |received_desc_counter) || run_rising_edge_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_read_read <= 0;
      else if (~descriptor_read_waitrequest)
          descriptor_read_read <= |posted_desc_counter & fifos_not_full;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_read_address <= 0;
      else if (~descriptor_read_waitrequest)
          descriptor_read_address <= (descriptor_read_read)? (descriptor_read_address + 4) : next_desc;
    end


  assign descriptor_read_completed_in = started ? (run && ~owned_by_hw && ~|posted_desc_counter) : descriptor_read_completed;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          posted_read_queued <= 0;
      else 
        posted_read_queued <= posted_read_queued ? ~(got_one_descriptor) : (descriptor_read_read);
    end


  //control bits
  assign generate_eop = control[0];
  assign read_fixed_address = control[1];
  assign write_fixed_address = control[2];
  assign atlantic_channel = control[6 : 3];
  assign owned_by_hw = control[7];
  assign got_one_descriptor = received_desc_counter == 8;
  //read descriptor
  assign desc_reg_en = chain_run && got_one_descriptor;
  assign init_descriptor = {1'b1, 31'b0, 32'b0, descriptor_pointer_upper_reg_out, descriptor_pointer_lower_reg_out, 128'b0};
  //Clear owned_by_hw bit when run is clear in Descriptor Polling Mode
  assign pollen_clear_run_desc = {1'b0, 31'b0, 32'b0, descriptor_pointer_upper_reg_out, descriptor_pointer_lower_reg_out, 128'b0};
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          desc_reg <= 0;
      else if (desc_reg_en || run_rising_edge_in || pollen_clear_run)
          desc_reg <= run_rising_edge_in ? init_descriptor : pollen_clear_run ? pollen_clear_run_desc: desc_assembler;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          desc_assembler <= 0;
      else if (descriptor_read_readdatavalid)
          desc_assembler <= desc_assembler >> 32 | {descriptor_read_readdata, 224'b0};
    end


  //descriptor_read_completed register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_read_completed <= 0;
      else 
        descriptor_read_completed <= descriptor_read_completed_in;
    end


  //started register
  assign started_in = (run_rising_edge || run_rising_edge_in) ? 1'b1 : (descriptor_read_completed ? 1'b0 : started);
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          started <= 0;
      else 
        started <= started_in;
    end


  //delayed_run signal for the rising edge detector
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_run <= 0;
      else 
        delayed_run <= run;
    end


  //Run rising edge detector
  assign run_rising_edge_in = run & ~delayed_run;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          run_rising_edge <= 0;
      else if (run_rising_edge_in || desc_reg_en)
          run_rising_edge <= run_rising_edge_in;
    end


  //the_descriptor_read_which_resides_within_amm_master_qsys_with_pcie_sgdma_control_bits_fifo, which is an e_instance
  descriptor_read_which_resides_within_amm_master_qsys_with_pcie_sgdma_control_bits_fifo the_descriptor_read_which_resides_within_amm_master_qsys_with_pcie_sgdma_control_bits_fifo
    (
      .clk                   (clk),
      .controlbitsfifo_data  (controlbitsfifo_data),
      .controlbitsfifo_empty (controlbitsfifo_empty),
      .controlbitsfifo_full  (controlbitsfifo_full),
      .controlbitsfifo_q     (controlbitsfifo_q),
      .controlbitsfifo_rdreq (controlbitsfifo_rdreq),
      .controlbitsfifo_wrreq (controlbitsfifo_wrreq),
      .reset                 (reset)
    );

  assign controlbitsfifo_data = control[6 : 0];
  assign controlbitsfifo_wrreq = command_fifo_wrreq;

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module descriptor_write_which_resides_within_amm_master_qsys_with_pcie_sgdma (
                                                                               // inputs:
                                                                                clk,
                                                                                controlbitsfifo_q,
                                                                                desc_address_fifo_empty,
                                                                                desc_address_fifo_q,
                                                                                descriptor_write_waitrequest,
                                                                                park,
                                                                                reset_n,
                                                                                status_token_fifo_data,
                                                                                status_token_fifo_empty,
                                                                                status_token_fifo_q,

                                                                               // outputs:
                                                                                atlantic_error,
                                                                                controlbitsfifo_rdreq,
                                                                                desc_address_fifo_rdreq,
                                                                                descriptor_write_address,
                                                                                descriptor_write_busy,
                                                                                descriptor_write_write,
                                                                                descriptor_write_writedata,
                                                                                status_token_fifo_rdreq,
                                                                                t_eop
                                                                             )
;

  output           atlantic_error;
  output           controlbitsfifo_rdreq;
  output           desc_address_fifo_rdreq;
  output  [ 31: 0] descriptor_write_address;
  output           descriptor_write_busy;
  output           descriptor_write_write;
  output  [ 31: 0] descriptor_write_writedata;
  output           status_token_fifo_rdreq;
  output           t_eop;
  input            clk;
  input   [  6: 0] controlbitsfifo_q;
  input            desc_address_fifo_empty;
  input   [ 31: 0] desc_address_fifo_q;
  input            descriptor_write_waitrequest;
  input            park;
  input            reset_n;
  input   [ 23: 0] status_token_fifo_data;
  input            status_token_fifo_empty;
  input   [ 23: 0] status_token_fifo_q;

  wire             atlantic_error;
  wire             can_write;
  wire             controlbitsfifo_rdreq;
  wire             desc_address_fifo_rdreq;
  reg     [ 31: 0] descriptor_write_address;
  wire             descriptor_write_busy;
  reg              descriptor_write_write;
  reg              descriptor_write_write0;
  reg     [ 31: 0] descriptor_write_writedata;
  wire             fifos_not_empty;
  wire    [  7: 0] status_reg;
  reg              status_token_fifo_rdreq;
  wire             status_token_fifo_rdreq_in;
  wire             t_eop;
  //descriptor_write, which is an e_avalon_master
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_write_writedata <= 0;
      else if (~descriptor_write_waitrequest)
          descriptor_write_writedata <= {park, controlbitsfifo_q, status_token_fifo_q};
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_write_address <= 0;
      else if (~descriptor_write_waitrequest)
          descriptor_write_address <= desc_address_fifo_q + 28;
    end


  assign fifos_not_empty = ~status_token_fifo_empty && ~desc_address_fifo_empty;
  assign can_write = ~descriptor_write_waitrequest && fifos_not_empty;
  //write register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_write_write0 <= 0;
      else if (~descriptor_write_waitrequest)
          descriptor_write_write0 <= status_token_fifo_rdreq;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          descriptor_write_write <= 0;
      else if (~descriptor_write_waitrequest)
          descriptor_write_write <= descriptor_write_write0;
    end


  //status_token_fifo_rdreq register
  assign status_token_fifo_rdreq_in = status_token_fifo_rdreq ? 1'b0 : can_write;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          status_token_fifo_rdreq <= 0;
      else 
        status_token_fifo_rdreq <= status_token_fifo_rdreq_in;
    end


  assign desc_address_fifo_rdreq = status_token_fifo_rdreq;
  assign descriptor_write_busy = descriptor_write_write0 | descriptor_write_write;
  assign status_reg = status_token_fifo_data[23 : 16];
  assign t_eop = status_reg[7];
  assign atlantic_error = status_reg[6] | status_reg[5] | status_reg[4] | status_reg[3] | status_reg[2] | status_reg[1] | status_reg[0];
  assign controlbitsfifo_rdreq = status_token_fifo_rdreq;

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module amm_master_qsys_with_pcie_sgdma_chain (
                                               // inputs:
                                                clk,
                                                command_fifo_empty,
                                                command_fifo_full,
                                                csr_address,
                                                csr_chipselect,
                                                csr_read,
                                                csr_write,
                                                csr_writedata,
                                                desc_address_fifo_empty,
                                                desc_address_fifo_full,
                                                desc_address_fifo_q,
                                                descriptor_read_readdata,
                                                descriptor_read_readdatavalid,
                                                descriptor_read_waitrequest,
                                                descriptor_write_waitrequest,
                                                read_go,
                                                reset,
                                                reset_n,
                                                status_token_fifo_data,
                                                status_token_fifo_empty,
                                                status_token_fifo_q,
                                                write_go,

                                               // outputs:
                                                command_fifo_data,
                                                command_fifo_wrreq,
                                                csr_irq,
                                                csr_readdata,
                                                desc_address_fifo_data,
                                                desc_address_fifo_rdreq,
                                                desc_address_fifo_wrreq,
                                                descriptor_read_address,
                                                descriptor_read_read,
                                                descriptor_write_address,
                                                descriptor_write_write,
                                                descriptor_write_writedata,
                                                status_token_fifo_rdreq,
                                                sw_reset
                                             )
;

  output  [103: 0] command_fifo_data;
  output           command_fifo_wrreq;
  output           csr_irq;
  output  [ 31: 0] csr_readdata;
  output  [ 31: 0] desc_address_fifo_data;
  output           desc_address_fifo_rdreq;
  output           desc_address_fifo_wrreq;
  output  [ 31: 0] descriptor_read_address;
  output           descriptor_read_read;
  output  [ 31: 0] descriptor_write_address;
  output           descriptor_write_write;
  output  [ 31: 0] descriptor_write_writedata;
  output           status_token_fifo_rdreq;
  output           sw_reset;
  input            clk;
  input            command_fifo_empty;
  input            command_fifo_full;
  input   [  3: 0] csr_address;
  input            csr_chipselect;
  input            csr_read;
  input            csr_write;
  input   [ 31: 0] csr_writedata;
  input            desc_address_fifo_empty;
  input            desc_address_fifo_full;
  input   [ 31: 0] desc_address_fifo_q;
  input   [ 31: 0] descriptor_read_readdata;
  input            descriptor_read_readdatavalid;
  input            descriptor_read_waitrequest;
  input            descriptor_write_waitrequest;
  input            read_go;
  input            reset;
  input            reset_n;
  input   [ 23: 0] status_token_fifo_data;
  input            status_token_fifo_empty;
  input   [ 23: 0] status_token_fifo_q;
  input            write_go;

  wire    [  3: 0] atlantic_channel;
  wire             atlantic_error;
  wire             chain_run;
  wire    [103: 0] command_fifo_data;
  wire             command_fifo_wrreq;
  wire    [  7: 0] control;
  wire    [  6: 0] controlbitsfifo_q;
  wire             controlbitsfifo_rdreq;
  wire             csr_irq;
  wire    [ 31: 0] csr_readdata;
  wire    [ 31: 0] desc_address_fifo_data;
  wire             desc_address_fifo_rdreq;
  wire             desc_address_fifo_wrreq;
  wire    [ 31: 0] descriptor_pointer_lower_reg_out;
  wire    [ 31: 0] descriptor_pointer_upper_reg_out;
  wire    [ 31: 0] descriptor_read_address;
  wire             descriptor_read_read;
  wire    [ 31: 0] descriptor_write_address;
  wire             descriptor_write_busy;
  wire             descriptor_write_write;
  wire    [ 31: 0] descriptor_write_writedata;
  wire             generate_eop;
  wire    [ 31: 0] next_desc;
  wire             owned_by_hw;
  wire             park;
  wire             pollen_clear_run;
  wire             read_fixed_address;
  wire             run;
  wire             status_token_fifo_rdreq;
  wire             sw_reset;
  wire             t_eop;
  wire             write_fixed_address;
  control_status_slave_which_resides_within_amm_master_qsys_with_pcie_sgdma the_control_status_slave_which_resides_within_amm_master_qsys_with_pcie_sgdma
    (
      .atlantic_error                   (atlantic_error),
      .chain_run                        (chain_run),
      .clk                              (clk),
      .command_fifo_empty               (command_fifo_empty),
      .csr_address                      (csr_address),
      .csr_chipselect                   (csr_chipselect),
      .csr_irq                          (csr_irq),
      .csr_read                         (csr_read),
      .csr_readdata                     (csr_readdata),
      .csr_write                        (csr_write),
      .csr_writedata                    (csr_writedata),
      .desc_address_fifo_empty          (desc_address_fifo_empty),
      .descriptor_pointer_lower_reg_out (descriptor_pointer_lower_reg_out),
      .descriptor_pointer_upper_reg_out (descriptor_pointer_upper_reg_out),
      .descriptor_read_address          (descriptor_read_address),
      .descriptor_read_read             (descriptor_read_read),
      .descriptor_write_busy            (descriptor_write_busy),
      .descriptor_write_write           (descriptor_write_write),
      .owned_by_hw                      (owned_by_hw),
      .park                             (park),
      .pollen_clear_run                 (pollen_clear_run),
      .read_go                          (read_go),
      .reset_n                          (reset_n),
      .run                              (run),
      .status_token_fifo_empty          (status_token_fifo_empty),
      .status_token_fifo_rdreq          (status_token_fifo_rdreq),
      .sw_reset                         (sw_reset),
      .write_go                         (write_go)
    );

  descriptor_read_which_resides_within_amm_master_qsys_with_pcie_sgdma the_descriptor_read_which_resides_within_amm_master_qsys_with_pcie_sgdma
    (
      .atlantic_channel                 (atlantic_channel),
      .chain_run                        (chain_run),
      .clk                              (clk),
      .command_fifo_data                (command_fifo_data),
      .command_fifo_full                (command_fifo_full),
      .command_fifo_wrreq               (command_fifo_wrreq),
      .control                          (control),
      .controlbitsfifo_q                (controlbitsfifo_q),
      .controlbitsfifo_rdreq            (controlbitsfifo_rdreq),
      .desc_address_fifo_data           (desc_address_fifo_data),
      .desc_address_fifo_full           (desc_address_fifo_full),
      .desc_address_fifo_wrreq          (desc_address_fifo_wrreq),
      .descriptor_pointer_lower_reg_out (descriptor_pointer_lower_reg_out),
      .descriptor_pointer_upper_reg_out (descriptor_pointer_upper_reg_out),
      .descriptor_read_address          (descriptor_read_address),
      .descriptor_read_read             (descriptor_read_read),
      .descriptor_read_readdata         (descriptor_read_readdata),
      .descriptor_read_readdatavalid    (descriptor_read_readdatavalid),
      .descriptor_read_waitrequest      (descriptor_read_waitrequest),
      .generate_eop                     (generate_eop),
      .next_desc                        (next_desc),
      .owned_by_hw                      (owned_by_hw),
      .pollen_clear_run                 (pollen_clear_run),
      .read_fixed_address               (read_fixed_address),
      .reset                            (reset),
      .reset_n                          (reset_n),
      .run                              (run),
      .write_fixed_address              (write_fixed_address)
    );

  descriptor_write_which_resides_within_amm_master_qsys_with_pcie_sgdma the_descriptor_write_which_resides_within_amm_master_qsys_with_pcie_sgdma
    (
      .atlantic_error               (atlantic_error),
      .clk                          (clk),
      .controlbitsfifo_q            (controlbitsfifo_q),
      .controlbitsfifo_rdreq        (controlbitsfifo_rdreq),
      .desc_address_fifo_empty      (desc_address_fifo_empty),
      .desc_address_fifo_q          (desc_address_fifo_q),
      .desc_address_fifo_rdreq      (desc_address_fifo_rdreq),
      .descriptor_write_address     (descriptor_write_address),
      .descriptor_write_busy        (descriptor_write_busy),
      .descriptor_write_waitrequest (descriptor_write_waitrequest),
      .descriptor_write_write       (descriptor_write_write),
      .descriptor_write_writedata   (descriptor_write_writedata),
      .park                         (park),
      .reset_n                      (reset_n),
      .status_token_fifo_data       (status_token_fifo_data),
      .status_token_fifo_empty      (status_token_fifo_empty),
      .status_token_fifo_q          (status_token_fifo_q),
      .status_token_fifo_rdreq      (status_token_fifo_rdreq),
      .t_eop                        (t_eop)
    );


endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module amm_master_qsys_with_pcie_sgdma_command_grabber (
                                                         // inputs:
                                                          clk,
                                                          command_fifo_empty,
                                                          command_fifo_q,
                                                          m_read_waitrequest,
                                                          m_write_waitrequest,
                                                          read_go,
                                                          reset_n,
                                                          write_go,

                                                         // outputs:
                                                          command_fifo_rdreq,
                                                          read_command_data,
                                                          read_command_valid,
                                                          write_command_data,
                                                          write_command_valid
                                                       )
;

  output           command_fifo_rdreq;
  output  [ 58: 0] read_command_data;
  output           read_command_valid;
  output  [ 56: 0] write_command_data;
  output           write_command_valid;
  input            clk;
  input            command_fifo_empty;
  input   [103: 0] command_fifo_q;
  input            m_read_waitrequest;
  input            m_write_waitrequest;
  input            read_go;
  input            reset_n;
  input            write_go;

  wire    [  3: 0] atlantic_channel;
  wire    [ 15: 0] bytes_to_transfer;
  wire             command_fifo_rdreq;
  wire             command_fifo_rdreq_in;
  reg              command_fifo_rdreq_reg;
  reg              command_valid;
  wire    [  7: 0] control;
  reg              delay1_command_valid;
  wire             generate_eop;
  wire    [ 31: 0] read_address;
  wire    [  7: 0] read_burst;
  reg     [ 58: 0] read_command_data;
  wire             read_command_valid;
  wire             read_fixed_address;
  wire    [ 31: 0] write_address;
  wire    [  7: 0] write_burst;
  reg     [ 56: 0] write_command_data;
  wire             write_command_valid;
  wire             write_fixed_address;
  //Descriptor components
  assign read_address = command_fifo_q[31 : 0];
  assign write_address = command_fifo_q[63 : 32];
  assign bytes_to_transfer = command_fifo_q[79 : 64];
  assign read_burst = command_fifo_q[87 : 80];
  assign write_burst = command_fifo_q[95 : 88];
  assign control = command_fifo_q[103 : 96];
  //control bits
  assign generate_eop = control[0];
  assign read_fixed_address = control[1];
  assign write_fixed_address = control[2];
  assign atlantic_channel = control[6 : 3];
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          read_command_data <= 0;
      else 
        read_command_data <= {write_fixed_address, generate_eop, ~read_fixed_address, read_burst, bytes_to_transfer, read_address};
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          write_command_data <= 0;
      else 
        write_command_data <= {~write_fixed_address, write_burst, bytes_to_transfer, write_address};
    end


  assign read_command_valid = command_valid;
  assign write_command_valid = command_valid;
  //command_fifo_rdreq register
  assign command_fifo_rdreq_in = (command_fifo_rdreq_reg || command_valid) ? 1'b0 : (~read_go && ~write_go && ~m_read_waitrequest && ~m_write_waitrequest);
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          command_fifo_rdreq_reg <= 0;
      else if (~command_fifo_empty)
          command_fifo_rdreq_reg <= command_fifo_rdreq_in;
    end


  assign command_fifo_rdreq = command_fifo_rdreq_reg;
  //command_valid register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delay1_command_valid <= 0;
      else 
        delay1_command_valid <= command_fifo_rdreq_reg;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          command_valid <= 0;
      else 
        command_valid <= delay1_command_valid;
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module amm_master_qsys_with_pcie_sgdma_m_read (
                                                // inputs:
                                                 clk,
                                                 m_read_readdata,
                                                 m_read_readdatavalid,
                                                 m_read_waitrequest,
                                                 m_readfifo_usedw,
                                                 read_command_data,
                                                 read_command_valid,
                                                 reset_n,
                                                 source_stream_ready,

                                                // outputs:
                                                 m_read_address,
                                                 m_read_burstcount,
                                                 m_read_read,
                                                 read_go,
                                                 source_stream_data,
                                                 source_stream_empty,
                                                 source_stream_endofpacket,
                                                 source_stream_startofpacket,
                                                 source_stream_valid
                                              )
;

  output  [ 31: 0] m_read_address;
  output  [  3: 0] m_read_burstcount;
  output           m_read_read;
  output           read_go;
  output  [ 63: 0] source_stream_data;
  output  [  2: 0] source_stream_empty;
  output           source_stream_endofpacket;
  output           source_stream_startofpacket;
  output           source_stream_valid;
  input            clk;
  input   [ 63: 0] m_read_readdata;
  input            m_read_readdatavalid;
  input            m_read_waitrequest;
  input   [  4: 0] m_readfifo_usedw;
  input   [ 58: 0] read_command_data;
  input            read_command_valid;
  input            reset_n;
  input            source_stream_ready;

  wire    [  3: 0] burst_size;
  wire    [  6: 0] burst_size_right_shifted;
  wire    [  3: 0] burst_value;
  wire    [ 15: 0] bytes_to_transfer;
  wire    [  3: 0] empty_operand;
  reg     [  3: 0] empty_value;
  wire             endofpacket;
  wire             generate_eop;
  wire             generate_sop;
  wire             has_transactions_to_post;
  wire             increment_address;
  reg     [ 31: 0] m_read_address;
  wire    [ 31: 0] m_read_address_inc;
  reg     [  3: 0] m_read_burstcount;
  reg              m_read_read;
  reg     [  6: 0] m_read_state;
  wire             maximum_transactions_in_queue;
  reg     [ 58: 0] read_command_data_reg;
  wire             read_go;
  wire             read_posted;
  wire    [  5: 0] readfifo_remaining_space;
  reg     [ 15: 0] received_data_counter;
  wire             received_enough_data;
  reg     [ 15: 0] remaining_transactions;
  wire             single_transfer;
  wire    [ 63: 0] source_stream_data;
  wire    [  2: 0] source_stream_empty;
  wire             source_stream_endofpacket;
  reg              source_stream_startofpacket;
  wire             source_stream_valid;
  wire    [ 31: 0] start_address;
  wire             still_got_full_burst;
  reg     [  5: 0] transactions_in_queue;
  reg     [ 15: 0] transactions_left_to_post;
  wire             tx_shift;
  //m_read, which is an e_avalon_master
  //read_command_data_reg
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          read_command_data_reg <= 0;
      else if (read_command_valid)
          read_command_data_reg <= read_command_data;
    end


  //command input
  assign start_address = read_command_data_reg[31 : 0];
  assign bytes_to_transfer = read_command_data_reg[47 : 32];
  assign increment_address = read_command_data_reg[56];
  assign generate_eop = read_command_data_reg[57];
  assign generate_sop = read_command_data_reg[58];
  assign burst_size = 8;
  assign burst_size_right_shifted = {burst_size, 3'b0};
  //Request Path
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          transactions_left_to_post <= 0;
      else if (m_read_state == 7'b0000100)
          transactions_left_to_post <= (bytes_to_transfer >> 3) + |bytes_to_transfer[2 : 0];
      else if (~m_read_waitrequest)
        begin
          if (m_read_state == 7'b0001000 & m_read_read)
              transactions_left_to_post <= transactions_left_to_post - burst_value;
        end
      else if (m_read_state == 7'b1000000)
          transactions_left_to_post <= 0;
    end


  assign still_got_full_burst = transactions_left_to_post >= burst_size;
  assign burst_value = still_got_full_burst ? burst_size : transactions_left_to_post;
  assign has_transactions_to_post = |transactions_left_to_post;
  assign read_posted = m_read_read & ~m_read_waitrequest;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          transactions_in_queue <= 0;
      else 
        transactions_in_queue <= (read_posted & ~m_read_readdatavalid) ? (transactions_in_queue + m_read_burstcount) : ((~read_posted & m_read_readdatavalid) ? (transactions_in_queue - 1) : ((read_posted & m_read_readdatavalid) ? (transactions_in_queue -1 + m_read_burstcount) : (transactions_in_queue)));
    end


  assign readfifo_remaining_space = 32-m_readfifo_usedw-transactions_in_queue-1;
  assign maximum_transactions_in_queue = burst_value >= readfifo_remaining_space;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_read_read <= 0;
      else if (~m_read_waitrequest)
          m_read_read <= m_read_read? 0: read_go & (m_read_state == 7'b0001000) & has_transactions_to_post & ~maximum_transactions_in_queue;
    end


  assign m_read_address_inc = increment_address ? (m_read_address + burst_size_right_shifted) : m_read_address;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_read_address <= 0;
      else if (m_read_state == 7'b0000100)
          m_read_address <= {start_address[31 : 3], 3'b0};
      else if (~m_read_waitrequest)
          if (read_go & m_read_read)
              m_read_address <= m_read_address_inc;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_read_burstcount <= 0;
      else if (~m_read_waitrequest)
          m_read_burstcount <= burst_value;
    end


  //Unaligned transfer not supported, tx_shift is always 0.
  assign tx_shift = 0;
  //Response Path
  assign single_transfer = source_stream_startofpacket & source_stream_endofpacket;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          received_data_counter <= 0;
      else if (m_read_readdatavalid)
        begin
          if (single_transfer)
              received_data_counter <= received_data_counter + 8 - tx_shift - source_stream_empty;
          else if (endofpacket)
              received_data_counter <= received_data_counter + (|bytes_to_transfer[2 : 0] ? bytes_to_transfer[2 : 0] : 8);
          else if (~|received_data_counter)
              received_data_counter <= received_data_counter + 8 - tx_shift;
          else 
            received_data_counter <= received_data_counter + 8;
        end
      else if (m_read_state == 7'b0000010)
          received_data_counter <= 0;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          remaining_transactions <= 0;
      else if (m_read_state == 7'b0000100)
          remaining_transactions <= (bytes_to_transfer >> 3) + |bytes_to_transfer[2 : 0];
      else if (read_go & m_read_readdatavalid)
          remaining_transactions <= remaining_transactions -1;
    end


  assign endofpacket = remaining_transactions == 1;
  //FSM
  assign received_enough_data = received_data_counter >= bytes_to_transfer;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_read_state <= 7'b0000001;
      else if (1)
          case (m_read_state) // synthesis parallel_case
          
              7'b0000001: begin
                  if (read_command_valid)
                      m_read_state <= 7'b0000010;
              end // 7'b0000001 
          
              7'b0000010: begin
                  m_read_state <= 7'b0000100;
              end // 7'b0000010 
          
              7'b0000100: begin
                  if (maximum_transactions_in_queue)
                      m_read_state <= 7'b0010000;
                  else 
                    m_read_state <= 7'b0001000;
              end // 7'b0000100 
          
              7'b0001000: begin
                  if (~m_read_waitrequest & maximum_transactions_in_queue)
                      m_read_state <= 7'b0010000;
                  else if (~has_transactions_to_post)
                      m_read_state <= 7'b0100000;
                  else if (received_enough_data)
                      m_read_state <= 7'b1000000;
              end // 7'b0001000 
          
              7'b0010000: begin
                  if (received_enough_data)
                      m_read_state <= 7'b1000000;
                  else if (~has_transactions_to_post)
                      m_read_state <= 7'b0100000;
                  else if (~m_read_waitrequest & ~maximum_transactions_in_queue)
                      m_read_state <= 7'b0001000;
              end // 7'b0010000 
          
              7'b0100000: begin
                  if (received_enough_data)
                      m_read_state <= 7'b1000000;
              end // 7'b0100000 
          
              7'b1000000: begin
                  m_read_state <= 7'b0000001;
              end // 7'b1000000 
          
              default: begin
                  m_read_state <= 7'b0000001;
              end // default
          
          endcase // m_read_state
    end


  assign read_go = |(m_read_state & (7'b0001000 | 7'b0010000 | 7'b0100000 | 7'b1000000));
  //Output on the Av-ST Source
  assign source_stream_data = m_read_readdata;
  assign source_stream_valid = read_go & m_read_readdatavalid;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          source_stream_startofpacket <= 0;
      else if (~source_stream_startofpacket)
          source_stream_startofpacket <= m_read_state == 7'b0000100;
      else if (source_stream_valid)
          source_stream_startofpacket <= ~source_stream_ready;
    end


  assign source_stream_endofpacket = read_go & endofpacket & m_read_readdatavalid;
  assign source_stream_empty = (endofpacket && source_stream_valid) ? empty_value : 0;
  assign empty_operand = 4'b1000;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          empty_value <= 0;
      else 
        empty_value <= empty_operand - bytes_to_transfer[2 : 0];
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module amm_master_qsys_with_pcie_sgdma_m_readfifo_m_readfifo (
                                                               // inputs:
                                                                clk,
                                                                m_readfifo_data,
                                                                m_readfifo_rdreq,
                                                                m_readfifo_wrreq,
                                                                reset,

                                                               // outputs:
                                                                m_readfifo_empty,
                                                                m_readfifo_full,
                                                                m_readfifo_q,
                                                                m_readfifo_usedw
                                                             )
;

  output           m_readfifo_empty;
  output           m_readfifo_full;
  output  [ 68: 0] m_readfifo_q;
  output  [  4: 0] m_readfifo_usedw;
  input            clk;
  input   [ 68: 0] m_readfifo_data;
  input            m_readfifo_rdreq;
  input            m_readfifo_wrreq;
  input            reset;

  wire             m_readfifo_empty;
  wire             m_readfifo_full;
  wire    [ 68: 0] m_readfifo_q;
  wire    [  4: 0] m_readfifo_usedw;
  scfifo amm_master_qsys_with_pcie_sgdma_m_readfifo_m_readfifo_m_readfifo
    (
      .aclr (reset),
      .clock (clk),
      .data (m_readfifo_data),
      .empty (m_readfifo_empty),
      .full (m_readfifo_full),
      .q (m_readfifo_q),
      .rdreq (m_readfifo_rdreq),
      .usedw (m_readfifo_usedw),
      .wrreq (m_readfifo_wrreq)
    );

  defparam amm_master_qsys_with_pcie_sgdma_m_readfifo_m_readfifo_m_readfifo.add_ram_output_register = "ON",
           amm_master_qsys_with_pcie_sgdma_m_readfifo_m_readfifo_m_readfifo.intended_device_family = "CYCLONEIVGX",
           amm_master_qsys_with_pcie_sgdma_m_readfifo_m_readfifo_m_readfifo.lpm_numwords = 32,
           amm_master_qsys_with_pcie_sgdma_m_readfifo_m_readfifo_m_readfifo.lpm_showahead = "OFF",
           amm_master_qsys_with_pcie_sgdma_m_readfifo_m_readfifo_m_readfifo.lpm_type = "scfifo",
           amm_master_qsys_with_pcie_sgdma_m_readfifo_m_readfifo_m_readfifo.lpm_width = 69,
           amm_master_qsys_with_pcie_sgdma_m_readfifo_m_readfifo_m_readfifo.lpm_widthu = 5,
           amm_master_qsys_with_pcie_sgdma_m_readfifo_m_readfifo_m_readfifo.overflow_checking = "ON",
           amm_master_qsys_with_pcie_sgdma_m_readfifo_m_readfifo_m_readfifo.underflow_checking = "ON",
           amm_master_qsys_with_pcie_sgdma_m_readfifo_m_readfifo_m_readfifo.use_eab = "ON";


endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module amm_master_qsys_with_pcie_sgdma_m_readfifo (
                                                    // inputs:
                                                     clk,
                                                     reset,
                                                     reset_n,
                                                     sink_stream_data,
                                                     sink_stream_empty,
                                                     sink_stream_endofpacket,
                                                     sink_stream_startofpacket,
                                                     sink_stream_valid,
                                                     source_stream_ready,

                                                    // outputs:
                                                     m_readfifo_usedw,
                                                     sink_stream_ready,
                                                     source_stream_data,
                                                     source_stream_empty,
                                                     source_stream_endofpacket,
                                                     source_stream_startofpacket,
                                                     source_stream_valid
                                                  )
;

  output  [  4: 0] m_readfifo_usedw;
  output           sink_stream_ready;
  output  [ 63: 0] source_stream_data;
  output  [  2: 0] source_stream_empty;
  output           source_stream_endofpacket;
  output           source_stream_startofpacket;
  output           source_stream_valid;
  input            clk;
  input            reset;
  input            reset_n;
  input   [ 63: 0] sink_stream_data;
  input   [  2: 0] sink_stream_empty;
  input            sink_stream_endofpacket;
  input            sink_stream_startofpacket;
  input            sink_stream_valid;
  input            source_stream_ready;

  reg              delayed_m_readfifo_empty;
  wire             hold_condition;
  reg     [ 68: 0] m_readfifo_data;
  wire             m_readfifo_empty;
  wire             m_readfifo_empty_fall;
  wire             m_readfifo_full;
  wire    [ 68: 0] m_readfifo_q;
  wire             m_readfifo_rdreq;
  reg              m_readfifo_rdreq_delay;
  wire    [  4: 0] m_readfifo_usedw;
  reg              m_readfifo_wrreq;
  wire             sink_stream_ready;
  wire    [ 63: 0] source_stream_data;
  wire    [  2: 0] source_stream_empty;
  reg     [  2: 0] source_stream_empty_hold;
  wire    [  2: 0] source_stream_empty_sig;
  wire             source_stream_endofpacket;
  wire             source_stream_endofpacket_from_fifo;
  reg              source_stream_endofpacket_hold;
  wire             source_stream_endofpacket_sig;
  wire             source_stream_startofpacket;
  wire             source_stream_valid;
  reg              source_stream_valid_reg;
  reg              transmitted_eop;
  //the_amm_master_qsys_with_pcie_sgdma_m_readfifo_m_readfifo, which is an e_instance
  amm_master_qsys_with_pcie_sgdma_m_readfifo_m_readfifo the_amm_master_qsys_with_pcie_sgdma_m_readfifo_m_readfifo
    (
      .clk              (clk),
      .m_readfifo_data  (m_readfifo_data),
      .m_readfifo_empty (m_readfifo_empty),
      .m_readfifo_full  (m_readfifo_full),
      .m_readfifo_q     (m_readfifo_q),
      .m_readfifo_rdreq (m_readfifo_rdreq),
      .m_readfifo_usedw (m_readfifo_usedw),
      .m_readfifo_wrreq (m_readfifo_wrreq),
      .reset            (reset)
    );

  assign sink_stream_ready = ~m_readfifo_full;
  assign m_readfifo_rdreq = ~m_readfifo_empty & source_stream_ready | m_readfifo_empty_fall & ~hold_condition;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_m_readfifo_empty <= 0;
      else 
        delayed_m_readfifo_empty <= m_readfifo_empty;
    end


  assign m_readfifo_empty_fall = ~m_readfifo_empty & delayed_m_readfifo_empty;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          source_stream_valid_reg <= 0;
      else if (source_stream_ready | m_readfifo_rdreq)
          source_stream_valid_reg <= m_readfifo_rdreq;
    end


  assign source_stream_valid = source_stream_valid_reg;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_readfifo_wrreq <= 0;
      else 
        m_readfifo_wrreq <= sink_stream_valid;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_readfifo_rdreq_delay <= 0;
      else 
        m_readfifo_rdreq_delay <= m_readfifo_rdreq;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          transmitted_eop <= 0;
      else 
        transmitted_eop <= transmitted_eop ? ~m_readfifo_rdreq : source_stream_endofpacket & source_stream_ready & source_stream_valid;
    end


  assign source_stream_endofpacket_sig = m_readfifo_rdreq_delay? source_stream_endofpacket_from_fifo | source_stream_endofpacket_hold : (source_stream_endofpacket_from_fifo & ~transmitted_eop) | source_stream_endofpacket_hold;
  assign source_stream_endofpacket = source_stream_endofpacket_sig;
  assign hold_condition = source_stream_valid & ~source_stream_ready;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          source_stream_endofpacket_hold <= 0;
      else 
        source_stream_endofpacket_hold <= hold_condition ? source_stream_endofpacket_sig : (source_stream_ready ? 0 : source_stream_endofpacket_hold);
    end


  assign source_stream_empty_sig = m_readfifo_q[66 : 64];
  assign source_stream_empty = source_stream_empty_sig | source_stream_empty_hold;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          source_stream_empty_hold <= 0;
      else 
        source_stream_empty_hold <= hold_condition ? source_stream_empty_sig : (source_stream_ready ? 0 : source_stream_empty_hold);
    end


  assign source_stream_data = m_readfifo_q[63 : 0];
  assign source_stream_endofpacket_from_fifo = m_readfifo_q[67];
  assign source_stream_startofpacket = m_readfifo_q[68];
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_readfifo_data <= 0;
      else 
        m_readfifo_data <= {sink_stream_startofpacket, sink_stream_endofpacket, sink_stream_empty, sink_stream_data};
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module amm_master_qsys_with_pcie_sgdma_m_writefifo_m_writefifo (
                                                                 // inputs:
                                                                  clk,
                                                                  m_writefifo_data,
                                                                  m_writefifo_rdreq,
                                                                  m_writefifo_wrreq,
                                                                  reset,

                                                                 // outputs:
                                                                  m_writefifo_empty,
                                                                  m_writefifo_full,
                                                                  m_writefifo_q,
                                                                  m_writefifo_usedw
                                                               )
;

  output           m_writefifo_empty;
  output           m_writefifo_full;
  output  [ 68: 0] m_writefifo_q;
  output  [  8: 0] m_writefifo_usedw;
  input            clk;
  input   [ 68: 0] m_writefifo_data;
  input            m_writefifo_rdreq;
  input            m_writefifo_wrreq;
  input            reset;

  wire             m_writefifo_empty;
  wire             m_writefifo_full;
  wire    [ 68: 0] m_writefifo_q;
  wire    [  8: 0] m_writefifo_usedw;
  scfifo amm_master_qsys_with_pcie_sgdma_m_writefifo_m_writefifo_m_writefifo
    (
      .aclr (reset),
      .clock (clk),
      .data (m_writefifo_data),
      .empty (m_writefifo_empty),
      .full (m_writefifo_full),
      .q (m_writefifo_q),
      .rdreq (m_writefifo_rdreq),
      .usedw (m_writefifo_usedw),
      .wrreq (m_writefifo_wrreq)
    );

  defparam amm_master_qsys_with_pcie_sgdma_m_writefifo_m_writefifo_m_writefifo.add_ram_output_register = "ON",
           amm_master_qsys_with_pcie_sgdma_m_writefifo_m_writefifo_m_writefifo.intended_device_family = "CYCLONEIVGX",
           amm_master_qsys_with_pcie_sgdma_m_writefifo_m_writefifo_m_writefifo.lpm_numwords = 512,
           amm_master_qsys_with_pcie_sgdma_m_writefifo_m_writefifo_m_writefifo.lpm_showahead = "ON",
           amm_master_qsys_with_pcie_sgdma_m_writefifo_m_writefifo_m_writefifo.lpm_type = "scfifo",
           amm_master_qsys_with_pcie_sgdma_m_writefifo_m_writefifo_m_writefifo.lpm_width = 69,
           amm_master_qsys_with_pcie_sgdma_m_writefifo_m_writefifo_m_writefifo.lpm_widthu = 9,
           amm_master_qsys_with_pcie_sgdma_m_writefifo_m_writefifo_m_writefifo.overflow_checking = "ON",
           amm_master_qsys_with_pcie_sgdma_m_writefifo_m_writefifo_m_writefifo.underflow_checking = "ON",
           amm_master_qsys_with_pcie_sgdma_m_writefifo_m_writefifo_m_writefifo.use_eab = "ON";


endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module amm_master_qsys_with_pcie_sgdma_m_writefifo (
                                                     // inputs:
                                                      clk,
                                                      reset,
                                                      reset_n,
                                                      sink_stream_data,
                                                      sink_stream_empty,
                                                      sink_stream_endofpacket,
                                                      sink_stream_startofpacket,
                                                      sink_stream_valid,
                                                      source_stream_ready,

                                                     // outputs:
                                                      eop_found,
                                                      m_writefifo_fill,
                                                      sink_stream_ready,
                                                      source_stream_data,
                                                      source_stream_empty,
                                                      source_stream_endofpacket,
                                                      source_stream_startofpacket,
                                                      source_stream_valid
                                                   )
;

  output           eop_found;
  output  [  8: 0] m_writefifo_fill;
  output           sink_stream_ready;
  output  [ 63: 0] source_stream_data;
  output  [  2: 0] source_stream_empty;
  output           source_stream_endofpacket;
  output           source_stream_startofpacket;
  output           source_stream_valid;
  input            clk;
  input            reset;
  input            reset_n;
  input   [ 63: 0] sink_stream_data;
  input   [  2: 0] sink_stream_empty;
  input            sink_stream_endofpacket;
  input            sink_stream_startofpacket;
  input            sink_stream_valid;
  input            source_stream_ready;

  reg              eop_found;
  wire             hold_condition;
  wire             in_eop_found;
  reg     [ 68: 0] m_writefifo_data;
  wire             m_writefifo_empty;
  wire    [  8: 0] m_writefifo_fill;
  wire             m_writefifo_full;
  wire    [ 68: 0] m_writefifo_q;
  wire             m_writefifo_rdreq;
  wire    [  8: 0] m_writefifo_usedw;
  reg              m_writefifo_wrreq;
  reg              pause_till_eop_out;
  wire             sink_stream_ready;
  wire             sink_stream_really_valid;
  wire    [ 63: 0] source_stream_data;
  wire    [  2: 0] source_stream_empty;
  reg     [  2: 0] source_stream_empty_hold;
  wire    [  2: 0] source_stream_empty_sig;
  wire             source_stream_endofpacket;
  wire             source_stream_endofpacket_from_fifo;
  reg              source_stream_endofpacket_hold;
  wire             source_stream_endofpacket_sig;
  wire             source_stream_startofpacket;
  wire             source_stream_valid;
  reg              transmitted_eop;
  //the_amm_master_qsys_with_pcie_sgdma_m_writefifo_m_writefifo, which is an e_instance
  amm_master_qsys_with_pcie_sgdma_m_writefifo_m_writefifo the_amm_master_qsys_with_pcie_sgdma_m_writefifo_m_writefifo
    (
      .clk               (clk),
      .m_writefifo_data  (m_writefifo_data),
      .m_writefifo_empty (m_writefifo_empty),
      .m_writefifo_full  (m_writefifo_full),
      .m_writefifo_q     (m_writefifo_q),
      .m_writefifo_rdreq (m_writefifo_rdreq),
      .m_writefifo_usedw (m_writefifo_usedw),
      .m_writefifo_wrreq (m_writefifo_wrreq),
      .reset             (reset)
    );

  assign sink_stream_ready = ~m_writefifo_usedw[8] && ~m_writefifo_full && ~pause_till_eop_out;
  assign m_writefifo_rdreq = ~m_writefifo_empty & source_stream_ready;
  assign source_stream_valid = ~m_writefifo_empty;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_writefifo_wrreq <= 0;
      else 
        m_writefifo_wrreq <= sink_stream_really_valid;
    end


  assign sink_stream_really_valid = sink_stream_valid & sink_stream_ready;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          transmitted_eop <= 0;
      else 
        transmitted_eop <= source_stream_endofpacket & source_stream_ready & source_stream_valid;
    end


  assign source_stream_endofpacket_sig = (source_stream_endofpacket_from_fifo & ~transmitted_eop) | source_stream_endofpacket_hold;
  assign source_stream_endofpacket = source_stream_endofpacket_sig;
  assign hold_condition = source_stream_valid & ~source_stream_ready;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          source_stream_endofpacket_hold <= 0;
      else 
        source_stream_endofpacket_hold <= hold_condition ? source_stream_endofpacket_sig : (source_stream_ready ? 0 : source_stream_endofpacket_hold);
    end


  assign m_writefifo_fill = m_writefifo_empty ? 0 : m_writefifo_usedw;
  assign source_stream_empty_sig = m_writefifo_q[66 : 64];
  assign source_stream_empty = source_stream_empty_sig | source_stream_empty_hold;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          source_stream_empty_hold <= 0;
      else 
        source_stream_empty_hold <= hold_condition ? source_stream_empty_sig : (source_stream_ready ? 0 : source_stream_empty_hold);
    end


  assign source_stream_data = m_writefifo_q[63 : 0];
  assign source_stream_startofpacket = m_writefifo_q[68];
  assign source_stream_endofpacket_from_fifo = m_writefifo_q[67];
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_writefifo_data <= 0;
      else 
        m_writefifo_data <= {sink_stream_startofpacket, sink_stream_endofpacket, sink_stream_empty, sink_stream_data};
    end


  assign in_eop_found = sink_stream_really_valid & sink_stream_endofpacket;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eop_found <= 0;
      else 
        eop_found <= eop_found ? ~(source_stream_ready) : in_eop_found;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pause_till_eop_out <= 0;
      else 
        pause_till_eop_out <= pause_till_eop_out ? ~(source_stream_valid & source_stream_ready & source_stream_endofpacket): in_eop_found;
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module amm_master_qsys_with_pcie_sgdma_m_write (
                                                 // inputs:
                                                  clk,
                                                  e_00,
                                                  e_01,
                                                  e_02,
                                                  e_03,
                                                  e_04,
                                                  e_05,
                                                  e_06,
                                                  eop_found,
                                                  m_write_waitrequest,
                                                  m_writefifo_fill,
                                                  reset_n,
                                                  sink_stream_data,
                                                  sink_stream_empty,
                                                  sink_stream_endofpacket,
                                                  sink_stream_startofpacket,
                                                  sink_stream_valid,
                                                  status_token_fifo_full,
                                                  write_command_data,
                                                  write_command_valid,

                                                 // outputs:
                                                  m_write_address,
                                                  m_write_burstcount,
                                                  m_write_byteenable,
                                                  m_write_write,
                                                  m_write_writedata,
                                                  sink_stream_ready,
                                                  status_token_fifo_data,
                                                  status_token_fifo_wrreq,
                                                  write_go
                                               )
;

  output  [ 31: 0] m_write_address;
  output  [  7: 0] m_write_burstcount;
  output  [  7: 0] m_write_byteenable;
  output           m_write_write;
  output  [ 63: 0] m_write_writedata;
  output           sink_stream_ready;
  output  [ 23: 0] status_token_fifo_data;
  output           status_token_fifo_wrreq;
  output           write_go;
  input            clk;
  input            e_00;
  input            e_01;
  input            e_02;
  input            e_03;
  input            e_04;
  input            e_05;
  input            e_06;
  input            eop_found;
  input            m_write_waitrequest;
  input   [  8: 0] m_writefifo_fill;
  input            reset_n;
  input   [ 63: 0] sink_stream_data;
  input   [  2: 0] sink_stream_empty;
  input            sink_stream_endofpacket;
  input            sink_stream_startofpacket;
  input            sink_stream_valid;
  input            status_token_fifo_full;
  input   [ 56: 0] write_command_data;
  input            write_command_valid;

  wire    [ 15: 0] actual_bytes_transferred;
  wire    [  7: 0] all_one;
  reg     [  7: 0] burst_counter;
  wire             burst_counter_decrement;
  wire    [  7: 0] burst_counter_next;
  reg     [  7: 0] burst_counter_reg;
  reg     [  7: 0] burst_size;
  reg              byteenable_enable;
  wire    [ 15: 0] bytes_to_transfer;
  reg     [ 15: 0] counter;
  wire    [ 15: 0] counter_in;
  reg              delayed_write_command_valid;
  reg              delayed_write_go;
  wire             enough_data;
  reg              eop_found_hold;
  reg              eop_reg;
  wire             increment;
  wire             increment_address;
  reg     [ 31: 0] m_write_address;
  reg     [  7: 0] m_write_burstcount;
  wire    [ 10: 0] m_write_burstcount_right_shifted;
  wire    [  7: 0] m_write_byteenable;
  wire    [  7: 0] m_write_byteenable_in;
  reg     [  7: 0] m_write_byteenable_reg;
  wire             m_write_waitrequest_out;
  reg              m_write_write;
  reg              m_write_write_sig;
  wire    [ 63: 0] m_write_writedata;
  reg     [ 63: 0] m_write_writedata_reg;
  wire    [  7: 0] shift0;
  wire    [  7: 0] shift1;
  wire    [  7: 0] shift2;
  wire    [  7: 0] shift3;
  wire    [  7: 0] shift4;
  wire    [  7: 0] shift5;
  wire    [  7: 0] shift6;
  wire    [  7: 0] shift7;
  wire             single_transfer;
  wire    [  7: 0] sink_stream_empty_shift;
  wire             sink_stream_ready;
  wire             sink_stream_really_valid;
  wire    [ 31: 0] start_address;
  reg     [  7: 0] status_reg;
  wire    [  7: 0] status_reg_in;
  wire    [ 23: 0] status_token_fifo_data;
  wire             status_token_fifo_wrreq;
  wire    [  7: 0] status_word;
  wire             t_eop;
  reg     [ 15: 0] transfer_remaining;
  reg     [ 56: 0] write_command_data_reg;
  wire             write_go;
  reg              write_go_fall_reg;
  wire             write_go_fall_reg_in;
  reg              write_go_reg;
  wire             write_go_reg_in;
  wire             write_go_reg_in_teop;
  //m_write, which is an e_avalon_master
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          transfer_remaining <= 0;
      else 
        transfer_remaining <= (bytes_to_transfer-counter_in + 7)>>3;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          burst_size <= 0;
      else 
        burst_size <= (!(|bytes_to_transfer)) ?128:
                transfer_remaining>=128?128:transfer_remaining;

    end


  assign enough_data = m_writefifo_fill >= burst_size;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_write_write <= 0;
      else if (~m_write_waitrequest_out)
          m_write_write <= write_go_reg & ((|burst_counter & sink_stream_really_valid) | m_write_write_sig);
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_write_burstcount <= 0;
      else if (~m_write_waitrequest_out)
          if (~|burst_counter)
              if (enough_data)
                  m_write_burstcount <= burst_size;
              else if (eop_found_hold)
                  m_write_burstcount <= m_writefifo_fill;
    end


  //command input
  assign start_address = write_command_data_reg[31 : 0];
  assign bytes_to_transfer = write_command_data_reg[47 : 32];
  assign increment_address = write_command_data_reg[56];
  //increment or keep constant, the m_write_address depending on the command bit
  assign m_write_writedata = m_write_writedata_reg;
  assign increment = write_go_reg & sink_stream_really_valid;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_write_writedata_reg <= 0;
      else if (~m_write_waitrequest_out)
          m_write_writedata_reg <= sink_stream_data;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_write_write_sig <= 0;
      else if (m_write_waitrequest_out)
          m_write_write_sig <= sink_stream_really_valid & ~m_write_write;
    end


  assign m_write_burstcount_right_shifted = {m_write_burstcount, 3'b0};
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_write_address <= 0;
      else if (~m_write_waitrequest_out & ~|burst_counter)
          m_write_address <= delayed_write_command_valid ? start_address : (increment_address ? (m_write_write ? (m_write_address + m_write_burstcount_right_shifted) : m_write_address) : start_address);
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eop_found_hold <= 0;
      else if (write_go_reg)
          eop_found_hold <= eop_found_hold ? ~(sink_stream_endofpacket & sink_stream_really_valid) : eop_found;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          burst_counter_reg <= 0;
      else if (~m_write_waitrequest_out)
          burst_counter_reg <= burst_counter;
    end


  assign burst_counter_decrement = |burst_counter & write_go_reg & sink_stream_really_valid;
  assign burst_counter_next = burst_counter - 1;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          burst_counter <= 0;
      else if (~|burst_counter & ~|burst_counter_reg & write_go_reg)
        begin
          if (enough_data)
              burst_counter <= burst_size;
          else if (eop_found_hold)
              burst_counter <= m_writefifo_fill;
        end
      else if (~m_write_waitrequest_out)
          if (burst_counter_decrement)
              burst_counter <= burst_counter_next;
    end


  assign shift7 = {7'b0, all_one[0]};
  assign shift6 = {6'b0, all_one[1 : 0]};
  assign shift5 = {5'b0, all_one[2 : 0]};
  assign shift4 = {4'b0, all_one[3 : 0]};
  assign shift3 = {3'b0, all_one[4 : 0]};
  assign shift2 = {2'b0, all_one[5 : 0]};
  assign shift1 = {1'b0, all_one[6 : 0]};
  assign shift0 = all_one;
  assign sink_stream_empty_shift = ((sink_stream_empty == 7) ? shift7 : 0) | ((sink_stream_empty == 6) ? shift6 : 0) | ((sink_stream_empty == 5) ? shift5 : 0) | ((sink_stream_empty == 4) ? shift4 : 0) | ((sink_stream_empty == 3) ? shift3 : 0) | ((sink_stream_empty == 2) ? shift2 : 0) | ((sink_stream_empty == 1) ? shift1 : 0) | ((sink_stream_empty == 0) ? shift0 : 0);
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          m_write_byteenable_reg <= 0;
      else if (~m_write_waitrequest_out)
          m_write_byteenable_reg <= ((sink_stream_empty == 7) ? shift7 : 0) | ((sink_stream_empty == 6) ? shift6 : 0) | ((sink_stream_empty == 5) ? shift5 : 0) | ((sink_stream_empty == 4) ? shift4 : 0) | ((sink_stream_empty == 3) ? shift3 : 0) | ((sink_stream_empty == 2) ? shift2 : 0) | ((sink_stream_empty == 1) ? shift1 : 0) | ((sink_stream_empty == 0) ? shift0 : 0);
    end


  assign all_one = 8'b11111111;
  assign m_write_byteenable_in = byteenable_enable ? m_write_byteenable_reg : all_one;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          byteenable_enable <= 0;
      else if (~m_write_waitrequest_out)
          byteenable_enable <= sink_stream_endofpacket;
    end


  assign sink_stream_ready = write_go_reg & ~m_write_waitrequest_out & ~eop_reg & |burst_counter;
  //sink_stream_ready_sig
  //sink_stream_valid is only really valid when we're ready
  assign sink_stream_really_valid = sink_stream_valid && sink_stream_ready;
  //write_command_data_reg
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          write_command_data_reg <= 0;
      else if (write_command_valid)
          write_command_data_reg <= write_command_data;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_write_command_valid <= 0;
      else 
        delayed_write_command_valid <= write_command_valid;
    end


  //8-bits up-counter
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          counter <= 0;
      else if (~m_write_waitrequest_out)
          counter <= counter_in;
    end


  //write_go bit for all of this operation until count is up
  assign write_go_reg_in = (delayed_write_command_valid) ? 1'b1 : (counter >= bytes_to_transfer) ? 1'b0 : write_go_reg;
  assign write_go_reg_in_teop = eop_reg ? ~(m_write_write & ~m_write_waitrequest_out) : 1'b1;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          eop_reg <= 0;
      else 
        eop_reg <= eop_reg ? ~(m_write_write & ~m_write_waitrequest_out) : sink_stream_endofpacket & sink_stream_really_valid;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          write_go_reg <= 0;
      else if (~m_write_waitrequest_out)
          write_go_reg <= (write_go_reg && (bytes_to_transfer == 0)) ? write_go_reg_in_teop : write_go_reg_in;
    end


  assign write_go = write_go_reg;
  assign t_eop = (sink_stream_endofpacket && sink_stream_really_valid) && (bytes_to_transfer == 0);
  assign single_transfer = sink_stream_startofpacket & sink_stream_endofpacket;
  assign counter_in = (delayed_write_command_valid) ? 16'b0 : (increment ? (counter + 8 - (sink_stream_endofpacket ? sink_stream_empty : 0)) : counter);
  //status register
  assign status_reg_in = write_go_fall_reg ? 0 : (status_word | status_reg);
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          status_reg <= 0;
      else 
        status_reg <= status_reg_in;
    end


  //actual_bytes_transferred register
  assign actual_bytes_transferred = counter;
  //status_token consists of the status signals and actual_bytes_transferred
  assign status_token_fifo_data = {status_reg, actual_bytes_transferred};
  assign status_word = {t_eop, 7'b0};
  //delayed write go register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          delayed_write_go <= 0;
      else 
        delayed_write_go <= write_go_reg;
    end


  //write_go falling edge detector
  assign write_go_fall_reg_in = delayed_write_go && ~write_go_reg;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          write_go_fall_reg <= 0;
      else 
        write_go_fall_reg <= write_go_fall_reg_in;
    end


  assign status_token_fifo_wrreq = write_go_fall_reg && ~status_token_fifo_full;
  assign m_write_waitrequest_out = m_write_waitrequest;
  assign m_write_byteenable = m_write_byteenable_in;

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module amm_master_qsys_with_pcie_sgdma_command_fifo (
                                                      // inputs:
                                                       clk,
                                                       command_fifo_data,
                                                       command_fifo_rdreq,
                                                       command_fifo_wrreq,
                                                       reset,

                                                      // outputs:
                                                       command_fifo_empty,
                                                       command_fifo_full,
                                                       command_fifo_q
                                                    )
;

  output           command_fifo_empty;
  output           command_fifo_full;
  output  [103: 0] command_fifo_q;
  input            clk;
  input   [103: 0] command_fifo_data;
  input            command_fifo_rdreq;
  input            command_fifo_wrreq;
  input            reset;

  wire             command_fifo_empty;
  wire             command_fifo_full;
  wire    [103: 0] command_fifo_q;
  scfifo amm_master_qsys_with_pcie_sgdma_command_fifo_command_fifo
    (
      .aclr (reset),
      .clock (clk),
      .data (command_fifo_data),
      .empty (command_fifo_empty),
      .full (command_fifo_full),
      .q (command_fifo_q),
      .rdreq (command_fifo_rdreq),
      .wrreq (command_fifo_wrreq)
    );

  defparam amm_master_qsys_with_pcie_sgdma_command_fifo_command_fifo.add_ram_output_register = "ON",
           amm_master_qsys_with_pcie_sgdma_command_fifo_command_fifo.intended_device_family = "CYCLONEIVGX",
           amm_master_qsys_with_pcie_sgdma_command_fifo_command_fifo.lpm_numwords = 2,
           amm_master_qsys_with_pcie_sgdma_command_fifo_command_fifo.lpm_showahead = "OFF",
           amm_master_qsys_with_pcie_sgdma_command_fifo_command_fifo.lpm_type = "scfifo",
           amm_master_qsys_with_pcie_sgdma_command_fifo_command_fifo.lpm_width = 104,
           amm_master_qsys_with_pcie_sgdma_command_fifo_command_fifo.lpm_widthu = 1,
           amm_master_qsys_with_pcie_sgdma_command_fifo_command_fifo.overflow_checking = "ON",
           amm_master_qsys_with_pcie_sgdma_command_fifo_command_fifo.underflow_checking = "ON",
           amm_master_qsys_with_pcie_sgdma_command_fifo_command_fifo.use_eab = "ON";


endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module amm_master_qsys_with_pcie_sgdma_desc_address_fifo (
                                                           // inputs:
                                                            clk,
                                                            desc_address_fifo_data,
                                                            desc_address_fifo_rdreq,
                                                            desc_address_fifo_wrreq,
                                                            reset,

                                                           // outputs:
                                                            desc_address_fifo_empty,
                                                            desc_address_fifo_full,
                                                            desc_address_fifo_q
                                                         )
;

  output           desc_address_fifo_empty;
  output           desc_address_fifo_full;
  output  [ 31: 0] desc_address_fifo_q;
  input            clk;
  input   [ 31: 0] desc_address_fifo_data;
  input            desc_address_fifo_rdreq;
  input            desc_address_fifo_wrreq;
  input            reset;

  wire             desc_address_fifo_empty;
  wire             desc_address_fifo_full;
  wire    [ 31: 0] desc_address_fifo_q;
  scfifo amm_master_qsys_with_pcie_sgdma_desc_address_fifo_desc_address_fifo
    (
      .aclr (reset),
      .clock (clk),
      .data (desc_address_fifo_data),
      .empty (desc_address_fifo_empty),
      .full (desc_address_fifo_full),
      .q (desc_address_fifo_q),
      .rdreq (desc_address_fifo_rdreq),
      .wrreq (desc_address_fifo_wrreq)
    );

  defparam amm_master_qsys_with_pcie_sgdma_desc_address_fifo_desc_address_fifo.add_ram_output_register = "ON",
           amm_master_qsys_with_pcie_sgdma_desc_address_fifo_desc_address_fifo.intended_device_family = "CYCLONEIVGX",
           amm_master_qsys_with_pcie_sgdma_desc_address_fifo_desc_address_fifo.lpm_numwords = 2,
           amm_master_qsys_with_pcie_sgdma_desc_address_fifo_desc_address_fifo.lpm_showahead = "OFF",
           amm_master_qsys_with_pcie_sgdma_desc_address_fifo_desc_address_fifo.lpm_type = "scfifo",
           amm_master_qsys_with_pcie_sgdma_desc_address_fifo_desc_address_fifo.lpm_width = 32,
           amm_master_qsys_with_pcie_sgdma_desc_address_fifo_desc_address_fifo.lpm_widthu = 1,
           amm_master_qsys_with_pcie_sgdma_desc_address_fifo_desc_address_fifo.overflow_checking = "ON",
           amm_master_qsys_with_pcie_sgdma_desc_address_fifo_desc_address_fifo.underflow_checking = "ON",
           amm_master_qsys_with_pcie_sgdma_desc_address_fifo_desc_address_fifo.use_eab = "OFF";


endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module amm_master_qsys_with_pcie_sgdma_status_token_fifo (
                                                           // inputs:
                                                            clk,
                                                            reset,
                                                            status_token_fifo_data,
                                                            status_token_fifo_rdreq,
                                                            status_token_fifo_wrreq,

                                                           // outputs:
                                                            status_token_fifo_empty,
                                                            status_token_fifo_full,
                                                            status_token_fifo_q
                                                         )
;

  output           status_token_fifo_empty;
  output           status_token_fifo_full;
  output  [ 23: 0] status_token_fifo_q;
  input            clk;
  input            reset;
  input   [ 23: 0] status_token_fifo_data;
  input            status_token_fifo_rdreq;
  input            status_token_fifo_wrreq;

  wire             status_token_fifo_empty;
  wire             status_token_fifo_full;
  wire    [ 23: 0] status_token_fifo_q;
  scfifo amm_master_qsys_with_pcie_sgdma_status_token_fifo_status_token_fifo
    (
      .aclr (reset),
      .clock (clk),
      .data (status_token_fifo_data),
      .empty (status_token_fifo_empty),
      .full (status_token_fifo_full),
      .q (status_token_fifo_q),
      .rdreq (status_token_fifo_rdreq),
      .wrreq (status_token_fifo_wrreq)
    );

  defparam amm_master_qsys_with_pcie_sgdma_status_token_fifo_status_token_fifo.add_ram_output_register = "ON",
           amm_master_qsys_with_pcie_sgdma_status_token_fifo_status_token_fifo.intended_device_family = "CYCLONEIVGX",
           amm_master_qsys_with_pcie_sgdma_status_token_fifo_status_token_fifo.lpm_numwords = 2,
           amm_master_qsys_with_pcie_sgdma_status_token_fifo_status_token_fifo.lpm_showahead = "OFF",
           amm_master_qsys_with_pcie_sgdma_status_token_fifo_status_token_fifo.lpm_type = "scfifo",
           amm_master_qsys_with_pcie_sgdma_status_token_fifo_status_token_fifo.lpm_width = 24,
           amm_master_qsys_with_pcie_sgdma_status_token_fifo_status_token_fifo.lpm_widthu = 1,
           amm_master_qsys_with_pcie_sgdma_status_token_fifo_status_token_fifo.overflow_checking = "ON",
           amm_master_qsys_with_pcie_sgdma_status_token_fifo_status_token_fifo.underflow_checking = "ON",
           amm_master_qsys_with_pcie_sgdma_status_token_fifo_status_token_fifo.use_eab = "ON";


endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module amm_master_qsys_with_pcie_sgdma (
                                         // inputs:
                                          clk,
                                          csr_address,
                                          csr_chipselect,
                                          csr_read,
                                          csr_write,
                                          csr_writedata,
                                          descriptor_read_readdata,
                                          descriptor_read_readdatavalid,
                                          descriptor_read_waitrequest,
                                          descriptor_write_waitrequest,
                                          m_read_readdata,
                                          m_read_readdatavalid,
                                          m_read_waitrequest,
                                          m_write_waitrequest,
                                          system_reset_n,

                                         // outputs:
                                          csr_irq,
                                          csr_readdata,
                                          descriptor_read_address,
                                          descriptor_read_read,
                                          descriptor_write_address,
                                          descriptor_write_write,
                                          descriptor_write_writedata,
                                          m_read_address,
                                          m_read_burstcount,
                                          m_read_read,
                                          m_write_address,
                                          m_write_burstcount,
                                          m_write_byteenable,
                                          m_write_write,
                                          m_write_writedata
                                       )
;

  output           csr_irq;
  output  [ 31: 0] csr_readdata;
  output  [ 31: 0] descriptor_read_address;
  output           descriptor_read_read;
  output  [ 31: 0] descriptor_write_address;
  output           descriptor_write_write;
  output  [ 31: 0] descriptor_write_writedata;
  output  [ 31: 0] m_read_address;
  output  [  3: 0] m_read_burstcount;
  output           m_read_read;
  output  [ 31: 0] m_write_address;
  output  [  7: 0] m_write_burstcount;
  output  [  7: 0] m_write_byteenable;
  output           m_write_write;
  output  [ 63: 0] m_write_writedata;
  input            clk;
  input   [  3: 0] csr_address;
  input            csr_chipselect;
  input            csr_read;
  input            csr_write;
  input   [ 31: 0] csr_writedata;
  input   [ 31: 0] descriptor_read_readdata;
  input            descriptor_read_readdatavalid;
  input            descriptor_read_waitrequest;
  input            descriptor_write_waitrequest;
  input   [ 63: 0] m_read_readdata;
  input            m_read_readdatavalid;
  input            m_read_waitrequest;
  input            m_write_waitrequest;
  input            system_reset_n;

  wire    [103: 0] command_fifo_data;
  wire             command_fifo_empty;
  wire             command_fifo_full;
  wire    [103: 0] command_fifo_q;
  wire             command_fifo_rdreq;
  wire             command_fifo_wrreq;
  wire             csr_irq;
  wire    [ 31: 0] csr_readdata;
  wire    [ 63: 0] data_to_fifo;
  wire    [ 31: 0] desc_address_fifo_data;
  wire             desc_address_fifo_empty;
  wire             desc_address_fifo_full;
  wire    [ 31: 0] desc_address_fifo_q;
  wire             desc_address_fifo_rdreq;
  wire             desc_address_fifo_wrreq;
  wire    [ 31: 0] descriptor_read_address;
  wire             descriptor_read_read;
  wire    [ 31: 0] descriptor_write_address;
  wire             descriptor_write_write;
  wire    [ 31: 0] descriptor_write_writedata;
  wire             e_00;
  wire             e_01;
  wire             e_02;
  wire             e_03;
  wire             e_04;
  wire             e_05;
  wire             e_06;
  wire    [  2: 0] empty_to_fifo;
  wire             eop_found;
  wire             eop_to_fifo;
  wire    [ 31: 0] m_read_address;
  wire    [  3: 0] m_read_burstcount;
  wire             m_read_read;
  wire    [  4: 0] m_readfifo_usedw;
  wire    [ 31: 0] m_write_address;
  wire    [  7: 0] m_write_burstcount;
  wire    [  7: 0] m_write_byteenable;
  wire             m_write_write;
  wire    [ 63: 0] m_write_writedata;
  wire    [  8: 0] m_writefifo_fill;
  wire    [ 58: 0] read_command_data;
  wire             read_command_valid;
  wire             read_go;
  wire             ready_from_fifo;
  wire             reset;
  reg              reset_n;
  wire    [ 63: 0] sink_stream_data;
  wire    [  2: 0] sink_stream_empty;
  wire             sink_stream_endofpacket;
  wire             sink_stream_ready;
  wire             sink_stream_startofpacket;
  wire             sink_stream_valid;
  wire             sop_to_fifo;
  wire    [ 63: 0] source_stream_data;
  wire    [  2: 0] source_stream_empty;
  wire             source_stream_endofpacket;
  wire             source_stream_ready;
  wire             source_stream_startofpacket;
  wire             source_stream_valid;
  wire    [ 23: 0] status_token_fifo_data;
  wire             status_token_fifo_empty;
  wire             status_token_fifo_full;
  wire    [ 23: 0] status_token_fifo_q;
  wire             status_token_fifo_rdreq;
  wire             status_token_fifo_wrreq;
  wire             sw_reset;
  reg              sw_reset_d1;
  reg              sw_reset_request;
  wire             valid_to_fifo;
  wire    [ 56: 0] write_command_data;
  wire             write_command_valid;
  wire    [ 63: 0] write_fifo_out_data;
  wire    [  2: 0] write_fifo_out_empty;
  wire             write_fifo_out_endofpacket;
  wire             write_fifo_out_ready;
  wire             write_fifo_out_startofpacket;
  wire             write_fifo_out_valid;
  wire             write_go;
  always @(posedge clk or negedge system_reset_n)
    begin
      if (system_reset_n == 0)
          reset_n <= 0;
      else 
        reset_n <= ~(~system_reset_n | sw_reset_request);
    end


  always @(posedge clk or negedge system_reset_n)
    begin
      if (system_reset_n == 0)
          sw_reset_d1 <= 0;
      else if (sw_reset | sw_reset_request)
          sw_reset_d1 <= sw_reset & ~sw_reset_request;
    end


  always @(posedge clk or negedge system_reset_n)
    begin
      if (system_reset_n == 0)
          sw_reset_request <= 0;
      else if (sw_reset | sw_reset_request)
          sw_reset_request <= sw_reset_d1 & ~sw_reset_request;
    end


  assign reset = ~reset_n;
  amm_master_qsys_with_pcie_sgdma_chain the_amm_master_qsys_with_pcie_sgdma_chain
    (
      .clk                           (clk),
      .command_fifo_data             (command_fifo_data),
      .command_fifo_empty            (command_fifo_empty),
      .command_fifo_full             (command_fifo_full),
      .command_fifo_wrreq            (command_fifo_wrreq),
      .csr_address                   (csr_address),
      .csr_chipselect                (csr_chipselect),
      .csr_irq                       (csr_irq),
      .csr_read                      (csr_read),
      .csr_readdata                  (csr_readdata),
      .csr_write                     (csr_write),
      .csr_writedata                 (csr_writedata),
      .desc_address_fifo_data        (desc_address_fifo_data),
      .desc_address_fifo_empty       (desc_address_fifo_empty),
      .desc_address_fifo_full        (desc_address_fifo_full),
      .desc_address_fifo_q           (desc_address_fifo_q),
      .desc_address_fifo_rdreq       (desc_address_fifo_rdreq),
      .desc_address_fifo_wrreq       (desc_address_fifo_wrreq),
      .descriptor_read_address       (descriptor_read_address),
      .descriptor_read_read          (descriptor_read_read),
      .descriptor_read_readdata      (descriptor_read_readdata),
      .descriptor_read_readdatavalid (descriptor_read_readdatavalid),
      .descriptor_read_waitrequest   (descriptor_read_waitrequest & descriptor_read_read),
      .descriptor_write_address      (descriptor_write_address),
      .descriptor_write_waitrequest  (descriptor_write_waitrequest & descriptor_write_write),
      .descriptor_write_write        (descriptor_write_write),
      .descriptor_write_writedata    (descriptor_write_writedata),
      .read_go                       (read_go),
      .reset                         (reset),
      .reset_n                       (reset_n),
      .status_token_fifo_data        (status_token_fifo_data),
      .status_token_fifo_empty       (status_token_fifo_empty),
      .status_token_fifo_q           (status_token_fifo_q),
      .status_token_fifo_rdreq       (status_token_fifo_rdreq),
      .sw_reset                      (sw_reset),
      .write_go                      (write_go)
    );

  amm_master_qsys_with_pcie_sgdma_command_grabber the_amm_master_qsys_with_pcie_sgdma_command_grabber
    (
      .clk                 (clk),
      .command_fifo_empty  (command_fifo_empty),
      .command_fifo_q      (command_fifo_q),
      .command_fifo_rdreq  (command_fifo_rdreq),
      .m_read_waitrequest  (m_read_waitrequest & m_read_read),
      .m_write_waitrequest (m_write_waitrequest & m_write_write),
      .read_command_data   (read_command_data),
      .read_command_valid  (read_command_valid),
      .read_go             (read_go),
      .reset_n             (reset_n),
      .write_command_data  (write_command_data),
      .write_command_valid (write_command_valid),
      .write_go            (write_go)
    );

  amm_master_qsys_with_pcie_sgdma_m_read the_amm_master_qsys_with_pcie_sgdma_m_read
    (
      .clk                         (clk),
      .m_read_address              (m_read_address),
      .m_read_burstcount           (m_read_burstcount),
      .m_read_read                 (m_read_read),
      .m_read_readdata             (m_read_readdata),
      .m_read_readdatavalid        (m_read_readdatavalid),
      .m_read_waitrequest          (m_read_waitrequest & m_read_read),
      .m_readfifo_usedw            (m_readfifo_usedw),
      .read_command_data           (read_command_data),
      .read_command_valid          (read_command_valid),
      .read_go                     (read_go),
      .reset_n                     (reset_n),
      .source_stream_data          (data_to_fifo),
      .source_stream_empty         (empty_to_fifo),
      .source_stream_endofpacket   (eop_to_fifo),
      .source_stream_ready         (ready_from_fifo),
      .source_stream_startofpacket (sop_to_fifo),
      .source_stream_valid         (valid_to_fifo)
    );

  amm_master_qsys_with_pcie_sgdma_m_readfifo the_amm_master_qsys_with_pcie_sgdma_m_readfifo
    (
      .clk                         (clk),
      .m_readfifo_usedw            (m_readfifo_usedw),
      .reset                       (reset),
      .reset_n                     (reset_n),
      .sink_stream_data            (data_to_fifo),
      .sink_stream_empty           (empty_to_fifo),
      .sink_stream_endofpacket     (eop_to_fifo),
      .sink_stream_ready           (ready_from_fifo),
      .sink_stream_startofpacket   (sop_to_fifo),
      .sink_stream_valid           (valid_to_fifo),
      .source_stream_data          (source_stream_data),
      .source_stream_empty         (source_stream_empty),
      .source_stream_endofpacket   (source_stream_endofpacket),
      .source_stream_ready         (source_stream_ready),
      .source_stream_startofpacket (source_stream_startofpacket),
      .source_stream_valid         (source_stream_valid)
    );

  amm_master_qsys_with_pcie_sgdma_m_writefifo the_amm_master_qsys_with_pcie_sgdma_m_writefifo
    (
      .clk                         (clk),
      .eop_found                   (eop_found),
      .m_writefifo_fill            (m_writefifo_fill),
      .reset                       (reset),
      .reset_n                     (reset_n),
      .sink_stream_data            (sink_stream_data),
      .sink_stream_empty           (sink_stream_empty),
      .sink_stream_endofpacket     (sink_stream_endofpacket),
      .sink_stream_ready           (sink_stream_ready),
      .sink_stream_startofpacket   (sink_stream_startofpacket),
      .sink_stream_valid           (sink_stream_valid),
      .source_stream_data          (write_fifo_out_data),
      .source_stream_empty         (write_fifo_out_empty),
      .source_stream_endofpacket   (write_fifo_out_endofpacket),
      .source_stream_ready         (write_fifo_out_ready),
      .source_stream_startofpacket (write_fifo_out_startofpacket),
      .source_stream_valid         (write_fifo_out_valid)
    );

  amm_master_qsys_with_pcie_sgdma_m_write the_amm_master_qsys_with_pcie_sgdma_m_write
    (
      .clk                       (clk),
      .e_00                      (e_00),
      .e_01                      (e_01),
      .e_02                      (e_02),
      .e_03                      (e_03),
      .e_04                      (e_04),
      .e_05                      (e_05),
      .e_06                      (e_06),
      .eop_found                 (eop_found),
      .m_write_address           (m_write_address),
      .m_write_burstcount        (m_write_burstcount),
      .m_write_byteenable        (m_write_byteenable),
      .m_write_waitrequest       (m_write_waitrequest & m_write_write),
      .m_write_write             (m_write_write),
      .m_write_writedata         (m_write_writedata),
      .m_writefifo_fill          (m_writefifo_fill),
      .reset_n                   (reset_n),
      .sink_stream_data          (write_fifo_out_data),
      .sink_stream_empty         (write_fifo_out_empty),
      .sink_stream_endofpacket   (write_fifo_out_endofpacket),
      .sink_stream_ready         (write_fifo_out_ready),
      .sink_stream_startofpacket (write_fifo_out_startofpacket),
      .sink_stream_valid         (write_fifo_out_valid),
      .status_token_fifo_data    (status_token_fifo_data),
      .status_token_fifo_full    (status_token_fifo_full),
      .status_token_fifo_wrreq   (status_token_fifo_wrreq),
      .write_command_data        (write_command_data),
      .write_command_valid       (write_command_valid),
      .write_go                  (write_go)
    );

  //the_amm_master_qsys_with_pcie_sgdma_command_fifo, which is an e_instance
  amm_master_qsys_with_pcie_sgdma_command_fifo the_amm_master_qsys_with_pcie_sgdma_command_fifo
    (
      .clk                (clk),
      .command_fifo_data  (command_fifo_data),
      .command_fifo_empty (command_fifo_empty),
      .command_fifo_full  (command_fifo_full),
      .command_fifo_q     (command_fifo_q),
      .command_fifo_rdreq (command_fifo_rdreq),
      .command_fifo_wrreq (command_fifo_wrreq),
      .reset              (reset)
    );

  //the_amm_master_qsys_with_pcie_sgdma_desc_address_fifo, which is an e_instance
  amm_master_qsys_with_pcie_sgdma_desc_address_fifo the_amm_master_qsys_with_pcie_sgdma_desc_address_fifo
    (
      .clk                     (clk),
      .desc_address_fifo_data  (desc_address_fifo_data),
      .desc_address_fifo_empty (desc_address_fifo_empty),
      .desc_address_fifo_full  (desc_address_fifo_full),
      .desc_address_fifo_q     (desc_address_fifo_q),
      .desc_address_fifo_rdreq (desc_address_fifo_rdreq),
      .desc_address_fifo_wrreq (desc_address_fifo_wrreq),
      .reset                   (reset)
    );

  //the_amm_master_qsys_with_pcie_sgdma_status_token_fifo, which is an e_instance
  amm_master_qsys_with_pcie_sgdma_status_token_fifo the_amm_master_qsys_with_pcie_sgdma_status_token_fifo
    (
      .clk                     (clk),
      .reset                   (reset),
      .status_token_fifo_data  (status_token_fifo_data),
      .status_token_fifo_empty (status_token_fifo_empty),
      .status_token_fifo_full  (status_token_fifo_full),
      .status_token_fifo_q     (status_token_fifo_q),
      .status_token_fifo_rdreq (status_token_fifo_rdreq),
      .status_token_fifo_wrreq (status_token_fifo_wrreq)
    );

  //descriptor_read, which is an e_avalon_master
  //descriptor_write, which is an e_avalon_master
  //csr, which is an e_avalon_slave
  //m_read, which is an e_avalon_master
  //m_write, which is an e_avalon_master
  assign sink_stream_valid = source_stream_valid;
  assign sink_stream_data = source_stream_data;
  assign sink_stream_startofpacket = source_stream_startofpacket;
  assign sink_stream_endofpacket = source_stream_endofpacket;
  assign source_stream_ready = sink_stream_ready;
  assign sink_stream_empty = source_stream_empty;

endmodule

