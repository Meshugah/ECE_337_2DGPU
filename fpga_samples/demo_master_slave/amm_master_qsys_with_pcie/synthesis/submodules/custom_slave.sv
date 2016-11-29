// custom_slave module : Acts as an avalon slave to receive input commands from PCIE IP

module custom_slave #(
	parameter MASTER_ADDRESSWIDTH = 26 ,  	// ADDRESSWIDTH specifies how many addresses the Master can address 
	parameter SLAVE_ADDRESSWIDTH = 3 ,  	// ADDRESSWIDTH specifies how many addresses the slave needs to be mapped to. log(NUMREGS)
	parameter DATAWIDTH = 32 ,    		// DATAWIDTH specifies the data width. Default 32 bits
	parameter NUMREGS = 8 ,       		// Number of Internal Registers for Custom Logic
	parameter REGWIDTH = 32       		// Data Width for the Internal Registers. Default 32 bits
)	
(	
	input logic  clk,
        input logic  reset_n,
	
	// Interface to Top Level
	input logic rdwr_cntl,					// Control Read or Write to a slave module.
	input logic n_action,					// Trigger the Read or Write. Additional control to avoid continuous transactions. Not a required signal. Can and should be removed for actual application.
	input logic add_data_sel,				// Interfaced to switch. Selects either Data or Address to be displayed on the Seven Segment Displays.
	input logic [MASTER_ADDRESSWIDTH-1:0] rdwr_address,	// read_address if required to be sent from another block. Can be unused if consecutive reads are required.
	output logic [DATAWIDTH-1:0] display_data,

	// Bus Slave Interface
        input logic [SLAVE_ADDRESSWIDTH-1:0] slave_address,
        input logic [DATAWIDTH-1:0] slave_writedata,
        input logic  slave_write,
        input logic  slave_read,
        input logic  slave_chipselect,
//      input logic  slave_readdatavalid, 			// These signals are for variable latency reads. 
//	output logic slave_waitrequest,   			// See the Avalon Specifications for details  on how to use them.
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


parameter START_BYTE = 32'hF00BF00B;
parameter STOP_BYTE = 32'hDEADF00B;
parameter SDRAM_ADDR = 32'h08000000;

logic [MASTER_ADDRESSWIDTH-1:0] address, nextAddress;
logic [DATAWIDTH-1:0] nextRead_data, read_data;
logic [DATAWIDTH-1:0] nextData, wr_data;
logic [NUMREGS-1:0][REGWIDTH-1:0] csr_registers;  		// Command and Status Registers (CSR) for custom logic 
logic [NUMREGS-1:0] reg_index, nextRegIndex;
logic [NUMREGS-1:0][REGWIDTH-1:0] read_data_registers;  //Store SDRAM read data for display
logic new_data_flag;
typedef enum {IDLE, WRITE, WRITE_WAIT, READ_REQ, READ_WAIT, READ_ACK, READ_DATA} state_t;
state_t state, nextState;

//assign wr_data = 32'hdeadbeef;
assign display_data = add_data_sel? read_data_registers[rdwr_address[3:0]] : address;

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
       		// If the computation is small you may compute directly and send it out to the master directly from here.
  	    	   slave_readdata <= csr_registers[slave_address];
  	    	end
  	 end
end




// Master Side t

always_ff @ ( posedge clk ) begin 
	if (!reset_n) begin 
		address <= SDRAM_ADDR;
		reg_index <= 0;
		state <= IDLE;
		wr_data <= 0 ;
		read_data <= 32'hFEEDFEED; 
		read_data_registers <= '0;
	end else begin 
		state <= nextState;
		address <= nextAddress;
		reg_index <= nextRegIndex;
		wr_data <= nextData;
		//read_data <= nextRead_data;
		if(new_data_flag)
		read_data_registers[reg_index] <= nextRead_data;
	end
end

// Next State Logic 
// If user wants to input data and addresses using a state machine instead of signals/conditions,
// the following code has commented lines for how this could be done.
always_comb begin 
	nextState = state;
	nextAddress = address;
	nextRegIndex = reg_index;
	//nextData = wr_data;
	nextRead_data = master_readdata;
	new_data_flag = 0;
	case( state ) 
		IDLE : begin 
			if ( csr_registers[0] == START_BYTE && reg_index < NUMREGS) begin 
				nextState = WRITE;
				//nextData = wr_data;
			end else if ( csr_registers[0] == STOP_BYTE && address >= SDRAM_ADDR) begin 
				nextState = READ_REQ; 				
			end
		end 
		WRITE: begin
			if (!master_waitrequest) begin 
				nextRegIndex = reg_index + 1;
				nextAddress = address + 4;
				nextState = IDLE;
			end
		end 
		READ_REQ : begin 
			if (!master_waitrequest) begin
				nextState = READ_DATA;
				nextAddress = address - 4 ;	
				nextRegIndex = reg_index - 1;
			end
		end
		READ_DATA : begin
			if ( master_readdatavalid) begin
				nextRead_data = master_readdata;
				nextState = IDLE;
				new_data_flag =1;
			end
		end
	endcase
end

// Output Logic 

always_comb begin 
	master_write = 1'b0;
	master_read = 1'b0;
	master_writedata = 32'h0;
	master_address = 32'hbad1bad1;
	case(state) 
		WRITE : begin 
			master_write = 1;
			master_address =  address;
			master_writedata = csr_registers[reg_index];
		end 
		READ_REQ : begin 
			master_address = address;
			master_read = 1;	
		end
	endcase
end

endmodule


