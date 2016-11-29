// $Id: $
// File name:   user_module.sv
// Created:     02/24/2015
// Modified:    02/24/2015
// Author:      Ishaan Biswas and Fangda Li
// Version:     1.0  Initial Design Entry
// Description: Acts as an avalon slave to receive input commands from PCIE IP. This block also includes the main state machine for the operations of the entire edge detection process.

module user_module #(
	parameter MASTER_ADDRESSWIDTH = 26 ,  // ADDRESSWIDTH specifies how many addresses the Master can address 
	parameter SLAVE_ADDRESSWIDTH = 3 ,  // ADDRESSWIDTH specifies how many addresses the slave needs to be mapped to
	parameter DATAWIDTH = 32 ,    // DATAWIDTH specifies the data width. Default 32 bits
	parameter NUMREGS = 8 ,       // Number of Internal Registers for Custom Logic
	parameter REGWIDTH = 32      // Data Width for the Internal Registers. Default 32 bits
)	
(	
	input logic  clk,
        input logic  reset_n,
	
	// Interface to Top Level
	input logic rdwr_cntl,				// Control Read or Write to a slave module.
	input logic n_action,				// Trigger the Read or Write. Additional control to avoid continuous transactions. Not a required signal. Can and should be removed for actual application.
	output logic[15:0] debug_flag,
	input logic add_data_sel,			// Interfaced to switch. Selects either Data or Address to be displayed on the Seven Segment Displays.
	input logic [MASTER_ADDRESSWIDTH-1:0] rdwr_address,	// read_address if required to be sent from another block. Can be unused if consecutive reads are required.
	output logic [DATAWIDTH-1:0] display_data,	

	// Bus Slave Interface
        input logic [SLAVE_ADDRESSWIDTH-1:0] slave_address,
        input logic [DATAWIDTH-1:0] slave_writedata,
        input logic  slave_write,
        input logic  slave_read,
        input logic  slave_chipselect,
//        output logic  slave_readdatavalid, // These signals are for variable latency reads. 
//	output logic slave_waitrequest,   // See the Avalon Specifications on how to use them.
        output logic [DATAWIDTH-1:0] slave_readdata,

	// Bus Master Interface
        output logic [MASTER_ADDRESSWIDTH-1:0] master_address,
        output logic [DATAWIDTH-1:0] master_writedata,
        output logic  master_write,
        output logic  master_read,
        input logic [DATAWIDTH-1:0] master_readdata,
        input logic  master_readdatavalid,
        input logic  master_waitrequest
);

// Useful Constant Parameters
parameter BYTEENABLEWIDTH = 4;  //Used to increment the address by 4
parameter START_BYTE = 32'h00000053;
parameter STOP_BYTE = 32'h00000012;
parameter INI_WRITE_ADDR = 32'h08500000;
parameter INI_READ_BOT_ADDR = 32'h08001000;
parameter INI_READ_MID_ADDR = 32'h08000800;
parameter INI_READ_TOP_ADDR = 32'h08000000;

logic [MASTER_ADDRESSWIDTH-1:0] address, nextAddress, r_address,next_r_address,mid_r_address,next_mid_r_address,bot_r_address,next_bot_r_address,i_address,next_i_address;
logic [DATAWIDTH-1:0] nextRead_data, read_data;
logic [DATAWIDTH-1:0] nextData, wr_data;
logic [NUMREGS-1:0][REGWIDTH-1:0] csr_registers;  // Command and Status Registers (CSR) for custom logic 
typedef enum {IDLE, WRITE, WRITE_WAIT, READ_REQ, READ_WAIT, READ_ACK, READ_DATA,
				  INI_READ,INI_READ1,INI_READ2,INI_READ3,INI_READ4,ADDR_LOAD,BOT_READ_REQ,BOT_READ_DATA,MID_READ_REQ,MID_READ_DATA,TOP_READ_REQ,TOP_READ_DATA,PIXEL_WAIT,PIXEL_WAIT1,PIXEL_WRITE,ADDR_INC} state_t;
state_t state, nextState;

//assign wr_data = 32'hdeadbeef;

logic [2:0] w_address_select;
logic w_data_select;
logic w_buffer_load,w_buffer_clear;
logic w_addr_load;

logic w_flag_clear;
logic w_load_size;
logic w_count_enable;
logic [31:0] w_mid_addr,w_bot_addr;
logic [15:0] row_count_out,col_count_out;
logic w_output_load;

assign display_data = (add_data_sel && rdwr_cntl) ? bot_r_address : (add_data_sel && ~rdwr_cntl) ? address : r_address; // Use SW[16] and SW[17] to select what address to be shown on HEX displays for debugging purpose

// Interface to our custom image processing core
top_levelu TOP(

	//input
	.clk(clk),
	.n_rst(reset_n),
	.data_in(read_data[7:0]),
	.w_data_select(w_data_select),
	.w_buffer_load(w_buffer_load),
	.w_load_size(w_load_size),
	.w_count_enable(w_count_enable),
	.w_flag_clear(w_flag_clear),
	.w_output_load(w_output_load),

	//output
	.w_image_done(w_image_done),
	.w_mid_addr(w_mid_addr),
	.w_bot_addr(w_bot_addr),
	.row_count_out(row_count_out),
	.col_count_out(col_count_out),
	.data_out(wr_data[7:0])
);

// Slave side 
always_ff @ ( posedge clk ) begin 
  if(!reset_n)
  	begin
    		slave_readdata <= 32'h0;
 	      	csr_registers <= '0;
  	end
  else 
  	begin
  	  if(slave_write && slave_chipselect && (slave_address >= 0) && (slave_address < NUMREGS))
  	  	begin
  	  	   csr_registers[slave_address] <= slave_writedata;  // Write a value to a CSR register
  	  	end
  	  else if(slave_read && slave_chipselect  && (slave_address >= 0) && (slave_address < NUMREGS)) // reading a CSR Register
  	    	begin
       		// Send a value being requested by a master. 
       		// If the computation is small you may compute directly and send it out to the master.
  	    	   slave_readdata <= csr_registers[slave_address];
  	    	end
	else if (w_image_done) // Whenever image_done flag is asserted, write STOPBYTE to signal Atom/C code.
		begin
		 	csr_registers[0]<= STOP_BYTE;
		end
  	 end
end


// Master Side
// This module serves as registers for read, write, info addresses, data and state.
always_ff @ ( posedge clk ) begin 
	if (!reset_n) begin 
		address <= INI_WRITE_ADDR;
		r_address <= INI_READ_TOP_ADDR;
		mid_r_address <= INI_READ_MID_ADDR;
		bot_r_address <= INI_READ_BOT_ADDR;
		state <= IDLE;
		read_data <= 32'hFEEDFEED;  
	end else begin 
		if(w_addr_load) begin  // Whenever w_addr_load is asserted, load all initial address settings.
			state <= nextState;
			address <= INI_WRITE_ADDR;
//			i_address <= 32'h00000004;
			r_address <= INI_READ_TOP_ADDR;
			mid_r_address <= w_mid_addr;
 			bot_r_address <= w_bot_addr;
			read_data <= nextRead_data;
		end else begin
			state <= nextState;
			address <= nextAddress;
			i_address <= next_i_address;
			r_address <= next_r_address;
			mid_r_address <= next_mid_r_address;
 			bot_r_address <= next_bot_r_address;
			read_data <= nextRead_data;
		end
	end
end

// Next State Logic 
always_comb begin 
	nextState = state;
	nextAddress = address;
	next_r_address = r_address;
	next_mid_r_address = mid_r_address;
	next_bot_r_address = bot_r_address;
	next_i_address = i_address;
	nextRead_data = read_data;
	debug_flag = 0;
	case( state ) 
		// Jump out of IDLE state whenever a STARTBYTE is detected 
		// STARTBYTE is written by C code at address 0x00000000 to slave module register[0] in this file. 
		IDLE : begin
			next_r_address = INI_READ_TOP_ADDR; 
			next_mid_r_address = INI_READ_MID_ADDR;
			next_bot_r_address = INI_READ_BOT_ADDR;
			nextAddress = INI_WRITE_ADDR;
			debug_flag = 1;
			if (csr_registers[0] == START_BYTE ) begin //slave_address = 0 for start/stop byte
				nextState = INI_READ;
			end
		end 
		// Read slave register and load image info into ImageSpecReg. Image info is also contained in slave registers
		INI_READ: begin  
			nextState = INI_READ1;
			debug_flag = 2;
			nextRead_data = csr_registers[1];
		end
		INI_READ1: begin
			nextState = INI_READ2;
			debug_flag = 3;
			nextRead_data = csr_registers[2];
		end
		INI_READ2: begin
			nextState = INI_READ3;
			debug_flag = 4;
			nextRead_data = csr_registers[3];
		end
		INI_READ3: begin
			nextState = INI_READ4;
			debug_flag = 5 ;
			nextRead_data = csr_registers[4];
		end
		INI_READ4: begin
			nextState = ADDR_LOAD;
			debug_flag = 6 ;
		end
		// Load all initial addresses
		ADDR_LOAD: begin
			nextState = BOT_READ_REQ;
			debug_flag = 7 ;
		end
		// Read image pixels from SDRAM
		BOT_READ_REQ: begin
			if (!master_waitrequest) begin
				nextState = BOT_READ_DATA;
				debug_flag = 8 ;
			end
		end
		BOT_READ_DATA: begin
			if ( master_readdatavalid) begin
				nextRead_data = master_readdata;
				debug_flag = 9 ;
				nextState = MID_READ_REQ;
			end
		end
		MID_READ_REQ: begin
			if (!master_waitrequest) begin
				debug_flag = 10 ;
				nextState = MID_READ_DATA;
			end
		end
		MID_READ_DATA: begin
			if ( master_readdatavalid) begin
				nextRead_data = master_readdata;
			 	debug_flag = 11 ;
				nextState = TOP_READ_REQ;
			end
		end
		TOP_READ_REQ: begin
			if (!master_waitrequest) begin
				nextState = TOP_READ_DATA;
			 	debug_flag = 12 ;
			end
		end
		TOP_READ_DATA: begin
			if ( master_readdatavalid) begin
				nextRead_data = master_readdata;
				nextState = PIXEL_WAIT;
			 	debug_flag = 13 ;
			end
		end
		// Give enough time for the calculation to finish and shift into outputlogic block.
		PIXEL_WAIT: begin
			 	debug_flag = 14 ;
			nextState = PIXEL_WAIT1;
		end
		
		PIXEL_WAIT1: begin
			 	debug_flag = 14 ;
			nextState = PIXEL_WRITE;
		end	
		// Write the output pixel from outputlogic block to SDRAM
		PIXEL_WRITE: begin
			if (!master_waitrequest) begin
				if (w_image_done == 1/*address == 32'h08600000*/) begin
					nextState = IDLE;  //slave module takes care of writing STOPBYTE
					nextAddress = INI_WRITE_ADDR;
				end else begin
					nextState = ADDR_INC;
			 		debug_flag = 15 ;
				end
			end			
		end
		// Increment all read and write addresses to get ready for the next round of pixel computation
		ADDR_INC: begin
			nextAddress =  address + BYTEENABLEWIDTH;
			next_r_address = r_address + BYTEENABLEWIDTH;
			next_bot_r_address = bot_r_address + BYTEENABLEWIDTH;
			next_mid_r_address = mid_r_address + BYTEENABLEWIDTH;
			nextState = BOT_READ_REQ;			
			 debug_flag = 16 ;
		end	
	endcase
end

// Output Logic 

always_comb begin 
	master_write = 1'b0;
	master_read = 1'b0;
	master_writedata = 32'h0;
	master_address = 32'hdeadbeef;
	
	w_flag_clear = 1'b0;
	w_output_load = 1'b0;

	w_address_select = 3'b100;
	w_data_select = 1;  //regular arith output
	w_buffer_load = 0;
	w_buffer_clear = 0;
	w_load_size = 0;
	w_count_enable = 0;
	w_addr_load = 0;
	
	
	case(state) 
		IDLE: begin
			w_buffer_clear = 1;
			w_flag_clear = 1;
		end
		INI_READ: begin  //read slave register and load info into ImageSpecReg
		
		end
		INI_READ1: begin
			w_load_size = 1;
		end
		INI_READ2: begin
			w_load_size = 1;
		end
		INI_READ3: begin
			w_load_size = 1;
		end
		INI_READ4: begin  //need this state to shift all info into ImageSpecReg
			w_load_size = 1;
		end		
		ADDR_LOAD: begin
			w_addr_load = 1;
		end
		
		BOT_READ_REQ: begin
			master_address = bot_r_address;
			master_read = 1;	
		end
		BOT_READ_DATA: begin
		
		end
		MID_READ_REQ: begin
			w_buffer_load = 1; //load bot data into pixel register
			master_address = mid_r_address;
			master_read = 1;	
		end
		MID_READ_DATA: begin

		end
		TOP_READ_REQ: begin
			w_buffer_load = 1; //load mid data into pixel register
			master_address = r_address;
			master_read = 1;	
		end
		TOP_READ_DATA: begin

		end
		PIXEL_WAIT: begin
			w_buffer_load = 1; //load top data into pixel register and allow arith to compute the result
			w_count_enable = 1;
		end
		
		PIXEL_WAIT1: begin
			w_output_load = 1'b1;
		end
		
		PIXEL_WRITE: begin
			master_write = 1;
			master_address =  address;
			master_writedata = wr_data;			
		end
		
		ADDR_INC: begin
		
		end
				
	endcase
end


endmodule


