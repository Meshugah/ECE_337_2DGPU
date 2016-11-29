//---------------------------------------------------
// Macro definition
//---------------------------------------------------
`define NUM_MASTERS  1
`define NUM_SLAVES   1

`define TB       $root.tb.dut
//`define SLAVE    $root.tb.dut.amm_master_inst.mm_slave_bfm_0
`define MASTER    $root.tb.dut.amm_master_inst.mm_master_bfm_0


module test_program ();

	import verbosity_pkg::*;
	import avalon_mm_pkg::*;


//------------------------------------------------------------------
// Constants 
//-----------------------------------------------------------------
	localparam ADDR_W                   = 26;
        localparam MEMORY_DEPTH		    = 1000;    
	localparam SYMBOL_W                 = 8;
	localparam NUM_SYMBOLS              = 4;
	localparam DATA_W                   = NUM_SYMBOLS * SYMBOL_W;
            
	localparam BURST_W                  = 4;
	localparam MAX_BURST                = 1;
   
	localparam SLAVE_SPAN               = 32'h1000;
   
	localparam MAX_COMMAND_IDLE         = 5;
	localparam MAX_COMMAND_BACKPRESSURE = 2;
	localparam MAX_DATA_IDLE            = 3;
	
//------------------------------------------------------------------
// Data Structures 
//-----------------------------------------------------------------
	typedef logic [BURST_W-1:0]	Burstcount;
	typedef enum bit
	{
		WRITE = 0,
		READ = 1
	} Transaction;

	typedef enum bit
	{
		NOBURST = 0,
		BURST = 1
	} Burstmode;

	typedef struct 
	{
       		Transaction                  trans;
       		Burstcount                   burstcount;
		logic [ADDR_W-1: 0]          addr;
		logic [DATA_W-1:0][MAX_BURST-1:0]           data  ;
		logic [NUM_SYMBOLS-1:0]      byteenable [MAX_BURST-1:0];
		bit [31:0]                   cmd_delay;
		bit [31:0]                   data_idles [MAX_BURST-1:0];
	} Command;

	logic [MEMORY_DEPTH-1:0][31:0] memory;
	typedef struct
	{
		Burstcount                    burstcount;
		logic [DATA_W-1:0]            data     [MAX_BURST-1:0];
		bit [31:0]                    latency  [MAX_BURST-1:0];
	} Response;	Response rsp;
	

	Command cmd;
	always @ (`SLAVE.signal_command_received) begin
		$display("command received signalled");
		//get command data
		`SLAVE.pop_command();
		cmd.burstcount = `SLAVE.get_command_burst_count();
		cmd.addr = `SLAVE.get_command_address();
	        cmd.data = `SLAVE.get_command_data(0);
		if (`SLAVE.get_command_request() == REQ_WRITE) begin
			cmd.trans = WRITE;
		end else begin
			cmd.trans = READ;
		end
		// create response for read---

		if (cmd.trans == READ) begin
			$display("slave cmd was a read: (burscount, address, data) => (%x, %x, %x)", cmd.burstcount, cmd.addr, memory[cmd.addr]);
			//Configure response
			`SLAVE.set_interface_wait_time(2,0);
			`SLAVE.set_response_request(REQ_READ);
			`SLAVE.set_response_burst_size(1);
			`SLAVE.set_response_data(memory[cmd.addr], 0);
			`SLAVE.set_response_latency(3, 0);
			//Push response
			`SLAVE.push_response();
		end else begin
			$display("slave cmd was a write: (burstcount, address, data) => (%x, %x, %x)", cmd.burstcount, cmd.addr, cmd.data);
			`SLAVE.set_interface_wait_time(2,0);
			`SLAVE.set_response_request(REQ_WRITE);
			`SLAVE.set_response_burst_size(1);
			memory[cmd.addr] = cmd.data;
		end
	end

endmodule
