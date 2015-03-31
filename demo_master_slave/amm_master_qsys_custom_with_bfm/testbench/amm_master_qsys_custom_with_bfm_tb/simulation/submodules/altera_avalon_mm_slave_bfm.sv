// (C) 2001-2013 Altera Corporation. All rights reserved.
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


// $File: //acds/rel/13.0sp1/ip/sopc/components/verification/altera_avalon_mm_slave_bfm/altera_avalon_mm_slave_bfm.sv $
// $File: //acds/rel/13.0sp1/ip/sopc/components/verification/altera_avalon_mm_slave_bfm/altera_avalon_mm_slave_bfm.sv $
// $Revision: #1 $
// $Date: 2013/03/07 $
// $Author: swbranch $
//-----------------------------------------------------------------------------
// =head1 NAME
// altera_avalon_mm_slave_bfm
// =head1 SYNOPSIS
// Memory Mapped Avalon Slave Bus Functional Model (BFM)
//-----------------------------------------------------------------------------
// =head1 DESCRIPTION
// This is a memory mapped Avalon Slave Bus Functional Model (BFM)
//
// =head1 UNSUPPORTED FEATURES
// Please note that this BFM does not support the interface parameters:
// holdTime and setupTime.
// Also, this BFM does not support the following interface ports: resetrequest
//-----------------------------------------------------------------------------

`timescale 1ns / 1ns

module altera_avalon_mm_slave_bfm(
                                  clk,   
                                  reset,
                                  
                                  avs_clken,
                                  
                                  avs_waitrequest,
                                  avs_write,
                                  avs_read,
                                  avs_address,
                                  avs_byteenable,
                                  avs_burstcount,
                                  avs_beginbursttransfer,
                                  avs_begintransfer,
                                  avs_writedata,
                                  avs_readdata,
                                  avs_readdatavalid,
                                  avs_arbiterlock,
                                  avs_lock,
                                  avs_debugaccess,

                                  avs_transactionid,
                                  avs_readresponse,
                                  avs_readid,
                                  avs_writeresponserequest,
                                  avs_writeresponsevalid,
                                  avs_writeresponse,
                                  avs_writeid
                                  );

   // =head1 PARAMETERS
   parameter AV_ADDRESS_W             = 16; // Address width
   parameter AV_SYMBOL_W              = 8;  // Symbol width (default is byte)
   parameter AV_NUMSYMBOLS            = 4;  // Number of symbols per word
   parameter AV_BURSTCOUNT_W          = 3;  // Burst port width
   parameter AV_READRESPONSE_W        = 8;  // Read response port width
   parameter AV_WRITERESPONSE_W       = 8;  // Write response port width   

   parameter USE_READ                 = 1;  // Use read interface pin
   parameter USE_WRITE                = 1;  // Use write interface pin
   parameter USE_ADDRESS              = 1;  // Use address interface pinsp
   parameter USE_BYTE_ENABLE          = 1;  // Use byte_enable interface pins
   parameter USE_BURSTCOUNT           = 1;  // Use burstcount interface pin
   parameter USE_READ_DATA            = 1;  // Use readdata interface pin
   parameter USE_READ_DATA_VALID      = 1;  // Use readdatavalid interface pin
   parameter USE_WRITE_DATA           = 1;  // Use writedata interface pin
   parameter USE_BEGIN_TRANSFER       = 1;  // Use begintransfer interface pin
   parameter USE_BEGIN_BURST_TRANSFER = 1;  // Use beginbursttransfer interface pin    
   parameter USE_WAIT_REQUEST         = 1;  // Use waitrequest interface pin
   parameter USE_ARBITERLOCK          = 0;  // Use arbiterlock interface pin
   parameter USE_LOCK                 = 0;  // Use lock interface pin
   parameter USE_DEBUGACCESS          = 0;  // Use debugaccess interface pin
   parameter USE_TRANSACTIONID        = 0;  // Use transactionid interface pin
   parameter USE_WRITERESPONSE        = 0;  // Use write response interface pins
   parameter USE_READRESPONSE         = 0;  // Use read response interface pins 
   parameter USE_CLKEN                = 0;  // Use NTCM interface pins     

   parameter AV_FIX_READ_LATENCY      = 0;  // Fixed read latency (cycles)
   parameter AV_MAX_PENDING_READS     = 1;  // Max pending pipelined reads

   parameter AV_BURST_LINEWRAP        = 0;  // Line wrap bursts (y/n)
   parameter AV_BURST_BNDR_ONLY       = 0;  // Assert Addr alignment

   parameter AV_READ_WAIT_TIME        = 0;  // Fixed wait time cycles when
   parameter AV_WRITE_WAIT_TIME       = 0;  // USE_WAIT_REQUEST is 0
   parameter REGISTER_WAITREQUEST     = 0;  ///TODO-implementation pending
   parameter AV_REGISTERINCOMINGSIGNALS = 0;// Indicate that waitrequest is come from register 
   parameter VHDL_ID                    = 0;// VHDL BFM ID number

   localparam MAX_BURST_SIZE          = USE_BURSTCOUNT ? 2**(AV_BURSTCOUNT_W-1) : 1;   
   localparam AV_DATA_W               = AV_SYMBOL_W * AV_NUMSYMBOLS;   
   localparam AV_TRANSACTIONID_W      = 8; 
   
   function int lindex;
      // returns the left index for a vector having a declared width 
      // when width is 0, then the left index is set to 0 rather than -1
      input [31:0] width;
      lindex = (width > 0) ? (width-1) : 0;
   endfunction
   
   // =head1 PINS
   // =head2 Clock Interface   
   input                                            clk;
   input                                            reset;
   // =head2 Avalon Slave Interface
   output                                           avs_waitrequest;
   output                                           avs_readdatavalid;
   output [lindex(AV_SYMBOL_W * AV_NUMSYMBOLS):0]   avs_readdata;
   input                                            avs_write;
   input                                            avs_read;
   input  [lindex(AV_ADDRESS_W):0]                  avs_address;
   input  [lindex(AV_NUMSYMBOLS):0]                 avs_byteenable;
   input  [lindex(AV_BURSTCOUNT_W):0]               avs_burstcount;
   input                                            avs_beginbursttransfer;
   input                                            avs_begintransfer;   
   input  [lindex(AV_SYMBOL_W * AV_NUMSYMBOLS):0]   avs_writedata;
   input                                            avs_arbiterlock;
   input                                            avs_lock;
   input                                            avs_debugaccess;                  

   input  [lindex(AV_TRANSACTIONID_W): 0          ] avs_transactionid;
   output [lindex(AV_READRESPONSE_W): 0           ] avs_readresponse;
   output [lindex(AV_TRANSACTIONID_W): 0          ] avs_readid;
   input                                            avs_writeresponserequest;
   output                                           avs_writeresponsevalid;      
   output [lindex(AV_WRITERESPONSE_W): 0          ] avs_writeresponse;
   output [lindex(AV_TRANSACTIONID_W): 0          ] avs_writeid;
   
   input                                            avs_clken;
   
   //--------------------------------------------------------------------------
   // Private Data Structures
   // All internal data types are packed. SystemVerilog struct or array 
   // slices can be accessed directly and can be assigned to a logic array 
   // in Verilog or a std_logic_vector in VHDL.
   // Read command transactions expect an associated Response transaction to
   // be pushed in by the test bench. Write transactions do not currently
   // require a response.
   //--------------------------------------------------------------------------

   localparam INT_W = 32;

   // synthesis translate_off
  
   import verbosity_pkg::*;
   import avalon_mm_pkg::*;
   
   logic                                            avs_waitrequest        = '1; 
   logic [lindex(AV_SYMBOL_W * AV_NUMSYMBOLS):0]    avs_readdata           = 'x;
   logic                                            avs_readdatavalid      = '0;
   logic [lindex(AV_READRESPONSE_W): 0           ]  avs_readresponse       = 'x;
   logic [lindex(AV_TRANSACTIONID_W): 0          ]  avs_readid             = 'x;
   logic                                            avs_writeresponsevalid = '0; 
   logic [lindex(AV_WRITERESPONSE_W): 0          ]  avs_writeresponse      = 'x;
   logic [lindex(AV_TRANSACTIONID_W): 0          ]  avs_writeid            = 'x;
   logic                                            clken_register         = 1'b1;

   typedef logic [lindex(AV_ADDRESS_W):0                                ] AvalonAddress_t;
   typedef logic [lindex(AV_BURSTCOUNT_W):0                             ] AvalonBurstCount_t;
   typedef logic [lindex(AV_TRANSACTIONID_W):0                          ] AvalonTransactionId_t;
   typedef logic [lindex(MAX_BURST_SIZE):0][lindex(AV_NUMSYMBOLS):0     ] AvalonByteEnable_t;
   typedef logic [lindex(MAX_BURST_SIZE):0][lindex(AV_DATA_W):0         ] AvalonData_t;
   typedef logic [lindex(MAX_BURST_SIZE):0][lindex(INT_W):0             ] AvalonIdle_t;
   typedef logic [lindex(MAX_BURST_SIZE):0][lindex(INT_W):0             ] AvalonLatency_t;
   typedef logic [lindex(MAX_BURST_SIZE):0][lindex(AV_READRESPONSE_W):0 ] AvalonReadResponse_t;
   typedef logic [lindex(MAX_BURST_SIZE):0][lindex(AV_WRITERESPONSE_W):0] AvalonWriteResponse_t;

   // command transaction descriptor - access with public API
   typedef struct packed {
                          Request_t               request;     
                          AvalonAddress_t         address;     // start address
                          AvalonBurstCount_t      burst_count; // burst length
                          AvalonData_t            data;        // write data
                          AvalonByteEnable_t      byte_enable; // hot encoded  
                          AvalonIdle_t            idle;        // interspersed
                          int                     burst_cycle;
                          logic                   arbiterlock;
                          logic                   lock;
                          logic                   debugaccess;
                          AvalonTransactionId_t   transaction_id;
                          logic                   write_response_request; 
                          } SlaveCommand_t;

   // response transaction descriptor - access with public API
   typedef struct packed {
                          Request_t               request;     
                          AvalonData_t            data;        // read data
                          AvalonAddress_t         address;     // start addr
                          AvalonBurstCount_t      burst_count; // burst length
                          AvalonLatency_t         latency;     // per cycle
                          AvalonTransactionId_t   read_id;
                          AvalonReadResponse_t    read_status;
                          AvalonTransactionId_t   write_id;
                          AvalonWriteResponse_t   write_status;
                          } SlaveResponse_t;

   // issued commands
   typedef struct packed {
                          SlaveCommand_t          command;
                          int                     time_stamp;
                          } IssuedCommand_t;
   
   //--------------------------------------------------------------------------
   // Local Signals
   //--------------------------------------------------------------------------
   string              message = "*unitialized*";   

   event               __signal_command_end;
   event               __signal_drive_response_done; // TODO - needs driver
   event               __signal_wait_cycles_set;

   semaphore           drive_read_response_semaphore;
   semaphore           drive_write_response_semaphore;   
   
   int                 clock_counter                  = 0;
   int                 request_time_stamp             = 0;

   bit                 burst_mode                     = 0;
   int                 addr_offset                    = 0;
   bit                 drive_read_response_state      = 0;
   bit                 drive_write_response_state     = 0;
   
   logic               beginbursttransfer             = 0;
   bit                 slave_is_full                  = 0;
   int                 pending_read_counter           = 0;
   int                 pending_rlc                    = 0;
   int                 temp_pending_rlc               = 0;
   int                 pending_wlc                    = 0;
   int                 temp_pending_wlc               = 0;
   int                 store_read_resp_clock_counter  = 0;
   int                 store_write_resp_clock_counter = 0;
   
   SlaveCommand_t      command_queue[$];
   SlaveResponse_t     write_response_queue[$];
   SlaveResponse_t     read_response_queue[$];   
   IssuedCommand_t     issued_read_command_queue[$];
   IssuedCommand_t     issued_write_command_queue[$];
   
   SlaveCommand_t      current_command; 
   SlaveCommand_t      client_command;
   SlaveCommand_t      internal_command;
   SlaveResponse_t     current_read_response;
   SlaveResponse_t     current_write_response;   
   SlaveResponse_t     client_response;
   IssuedCommand_t     issued_command;
   IssuedCommand_t     pending_command;   

   int                 response_timeout                     = 100;  
   
   int                 command_queue_size                   = 0;   
   int                 command_received_counter             = 0;
   int                 read_command_received_counter        = 0;
   
   int                 read_response_sequence_counter       = 1;
   int                 write_response_sequence_counter      = 1;
   int                 last_read_response_sequence_counter  = 1;
   int                 last_write_response_sequence_counter = 1;

   AvalonLatency_t     read_wait_time                       = '0;
   AvalonLatency_t     write_wait_time                      = '0;

   int                 consolidate_write_burst_transactions = 1;
   int                 max_response_queue_size              = 256;
   int                 min_response_queue_size              = 2;

   logic               avs_waitrequest_q1                   = 1'b1;
   logic               avs_waitrequest_d1                   = 1'b1;   
   
   //--------------------------------------------------------------------------
   // =head1 Public Methods API
   // =pod
   // This section describes the public methods in the application programming
   // interface (API). In this case the application program is the test bench
   // which instantiates and controls and queries state in this BFM component.
   // Test programs must only use these public access methods and events to 
   // communicate with this BFM component. The API and the module pins
   // are the only interfaces in this component that are guaranteed to be
   // stable. The API will be maintained for the life of the product. 
   // While we cannot prevent a test program from directly accessing internal
   // tasks, functions, or data private to the BFM, there is no guarantee that
   // these will be present in the future. In fact, it is best for the user
   // to assume that the underlying implementation of this component can 
   // and will change.
   // =cut
   //--------------------------------------------------------------------------

   event signal_fatal_error; // public
   // This event notifies the test bench that a fatal error has occurred
   // in this module.

   event signal_error_exceed_max_pending_reads; // public
   // This event notifies the test bench of the error condition in which
   // the Slave has more than max_pending_reads pipelined read 
   // commands queued waiting to be processed. 
   
   event signal_command_received; // public
   // This event notifies the test bench that a command has been detected
   // on the Avalon port. 
   // The testbench can respond with a set_interface_wait_time
   // call on receiving this event to dynamically back pressure the driving
   // Avalon master. Alternatively, wait_time which was previously set may
   // be used continuously for a set of transactions.

   event signal_response_issued;  // public
   // This event notifies the test bench that a response has been driven
   // out on the Avalon bus

   event signal_max_response_queue_size; // public
   // This event signals that the pending transaction queue size
   // threshold has been exceeded

   event signal_min_response_queue_size; // public
   // This event signals that the pending transaction queue size
   // is below the minimum threshold
   
   function automatic string get_version();  // public
      // Return BFM version string. For example, version 9.1 sp1 is "9.1sp1" 
      string ret_version = "13.0";
      return ret_version;            
   endfunction
   
   function automatic void init(); // public
      // Initialize the Avalon Slave Bus Interface.

      $sformat(message, "%m: method called");
      print(VERBOSITY_DEBUG, message);
      
      __drive_response_idle();
      __drive_waitrequest_idle();

      command_queue = {};
      read_response_queue = {};
      issued_read_command_queue = {};
      issued_write_command_queue = {};           
   endfunction

   function automatic void set_response_timeout( // public
    int  cycles = 100 
   );
      // Set the number of cycles that may elapse before time out
      response_timeout = cycles;
      $sformat(message, "%m: Response timeout set to %0d cycles", 
               response_timeout);
      print(VERBOSITY_INFO, message);            
   endfunction     
   
   function automatic int get_command_queue_size(); // public
      // Query the command queue to determine number of pending commands
      $sformat(message, "%m: method called");                  
      print(VERBOSITY_DEBUG, message);
      
      return command_queue.size();
   endfunction 

   function automatic int get_response_queue_size(); // public
      // Query the response queue to determine number of response descriptors
      // pending.
      $sformat(message, "%m: method called");                  
      print(VERBOSITY_DEBUG, message);
      
      return read_response_queue.size();
   endfunction 

   function automatic void set_response_latency(  // public
      bit [31:0]   latency,
      int          index
   );
      // Set the latency of the read response. The response is driven out
      // the specified number of cycles after receiving the read command.
      
      $sformat(message, "%m: method called arg0 %0d arg1 %0d", latency, index);
      print(VERBOSITY_DEBUG, message);
     
      if (USE_READ_DATA_VALID == 0) begin
         $sformat(message, 
                  "%m: Slave has fixed read latency. Ignoring this method.");
         print(VERBOSITY_WARNING, message);
      end
      if (__check_transaction_index(index))
         client_response.latency[index] = latency;
   endfunction 

   function automatic void set_response_burst_size( // public
      bit [AV_BURSTCOUNT_W-1:0] burst_size
   );
      // Set the transaction burst count in the response descriptor.
      $sformat(message, "%m: method called arg0 %0d", burst_size);
      print(VERBOSITY_DEBUG, message);

      if (burst_size > MAX_BURST_SIZE) begin
         $sformat(message, "%m: burst_count %0d > MAX_BURST_SIZE %0d ", 
             burst_size, MAX_BURST_SIZE);
         print(VERBOSITY_FAILURE, message);
      end else begin
         client_response.burst_count = burst_size;
      end
   endfunction 

   function automatic void set_response_data( // public
      bit [AV_DATA_W-1:0] data, 
      int                 index
   );
      // Set the transaction read data in the response descriptor.
      // For burst transactions, the command descriptor holds an array
      // of data, with each element individually set by this method.
      $sformat(message, "%m: method called arg0 %0d arg1 %0d", data, index);
      print(VERBOSITY_DEBUG, message);
               
      if (__check_transaction_index(index))
         client_response.data[index] = data;
   endfunction 

   function automatic void push_response(); // public
      // Push the fully populated response transaction descriptor onto
      // response queue. The BFM will pop response descriptors off the
      // queue as soon as they are available, read them and drive the
      // Avalon interface response plane.
      $sformat(message, "%m: push response");
      print(VERBOSITY_DEBUG, message);

      if (reset) begin
         $sformat(message, "%m: Illegal command while reset asserted"); 
         print(VERBOSITY_ERROR, message);
         ->signal_fatal_error;
      end
      
      if (client_response.request == REQ_WRITE)
         write_response_queue.push_front(client_response);
      else
         read_response_queue.push_front(client_response);
   endfunction 

   function automatic void pop_command(); // public
      // Pop the command descriptor from the queue so that it can be
      // queried with the get_command methods by the test bench.
      $sformat(message, "%m: method called");
      print(VERBOSITY_DEBUG, message);

      if (reset) begin
         $sformat(message, "%m: Illegal command while reset asserted"); 
         print(VERBOSITY_ERROR, message);
         ->signal_fatal_error;
      end
               
      client_command = command_queue.pop_back();

      case(client_command.request) 
         REQ_READ: $sformat(message, "%m: read addr %0x", 
                            client_command.address);
         REQ_WRITE: $sformat(message,"%m: write addr %0x",
                             client_command.address);
         REQ_IDLE: $sformat(message, "%m: idle transaction");
           default: $sformat(message, "%m: illegal transaction");
      endcase
      print(VERBOSITY_DEBUG, message);
   endfunction

   function automatic Request_t get_command_request(); // public
      // Get the received command descriptor to determine command request type.
      // A command type may be REQ_READ or REQ_WRITE. These type values
      // are defined in the enumerated type called Request_t which is
      // imported with the package named avalon_mm_pkg.
      $sformat(message, "%m: method called");
      print(VERBOSITY_DEBUG, message);
               
      return client_command.request;
   endfunction 

   function automatic logic [AV_ADDRESS_W-1:0] get_command_address(); // public
      // Query the received command descriptor for the transaction address.
      $sformat(message, "%m: method called");
      print(VERBOSITY_DEBUG, message);
               
      return client_command.address;      
   endfunction 

   function automatic [AV_BURSTCOUNT_W-1:0] get_command_burst_count();// public
      // Query the received command descriptor for the transaction burst count.
      $sformat(message, "%m: method called");
      print(VERBOSITY_DEBUG, message);
               
      return client_command.burst_count;      
   endfunction 

   function automatic logic [AV_DATA_W-1:0] get_command_data( // public
      int index
   );
      // Query the received command descriptor for the transaction write data.
      // The burst commands with burst count greater than 1, the index
      // selects the write data cycle.
      $sformat(message, "%m: method called arg0 %0d", index);
      print(VERBOSITY_DEBUG, message);
               
      if (__check_transaction_index(index))
         return client_command.data[index];
      else
         return('x);
   endfunction 

   function automatic logic [AV_NUMSYMBOLS-1:0] get_command_byte_enable(// public
      int index
   );
      // Query the received command descriptor for the transaction byte enable.
      // The burst commands with burst count greater than 1, the index
      // selects the data cycle.
      $sformat(message, "%m: method called arg0 %0d", index);
      print(VERBOSITY_DEBUG, message);
               
      if (__check_transaction_index(index))
         return client_command.byte_enable[index];
      else
         return('x); 
   endfunction 

   function automatic int get_command_burst_cycle();  // public
      // Write burst commands are received and processed by the slave BFM as
      // a sequence of discrete commands. The number of commands corresponds
      // to the burst count. A separate command descriptor is constructed for
      // each write burst cycle, corresponding to a partially completed burst.
      // Write data is incrementally added to each new descriptor in each burst
      // cycle until the command descriptor in final burst cycle contains 
      // the full burst command data array. 
      // The burst cycle field returned by this method tells the test bench
      // which burst cycle was active when this descriptor was constructed.
      // This facility enables the testbench to query partially completed 
      // write burst operations. In other words, the testbench can query 
      // the write data word on each burst cycle as it arrives and begin to 
      // process it immediately rather than waiting until the entire burst
      // has been received. This makes it possible to perform pipelined write 
      // burst processing in the test bench.
      $sformat(message, "%m: method called");
      print(VERBOSITY_DEBUG, message);
               
      return client_command.burst_cycle;
   endfunction

   function automatic void set_interface_wait_time( // public
       int wait_cycles, 
       int index
   );
      // Specify zero or more wait states to be asserted in each Avalon
      // bus burst cycle by driving waitrequest active.
      // With write burst commands, each write data cycle will be forced
      // to wait the number of cycles corresponding to the cycle index. 
      // With read burst commands, there is only one command cycle
      // corresponding to index 0 which can be forced to wait.
      $sformat(message, "%m: method called arg0 %0d arg1 %0d", wait_cycles, index);
      print(VERBOSITY_DEBUG, message);

      if (USE_WAIT_REQUEST == 0) begin
         $sformat(message, "%m: USE_WAIT_REQUEST is 0 (disabled) \
only fixed wait latencies as defined by the parameters \
AV_READ_WAIT_TIME and AV_WRITE_WAIT_TIME can be used");
         print(VERBOSITY_WARNING, message);
         return;
      end else begin
         if (__check_transaction_index(index)) begin
            if ((AV_REGISTERINCOMINGSIGNALS) == 1 && (wait_cycles == 0)) begin
               $sformat(message, "%m: AV_REGISTERINCOMINGSIGNALS is 1, \
waitrequest will come from register and the wait cycles must be at least 1. \
BFM will reset the wait cycles to 1");
               print(VERBOSITY_WARNING, message);
            end else begin
               read_wait_time[index]  = wait_cycles;
               write_wait_time[index] = wait_cycles;
               
               $sformat(message, "%m: Set wait = %0d with index = %0d", 
                        wait_cycles, index);
               print(VERBOSITY_DEBUG, message);
               ->__signal_wait_cycles_set;
            end
         end 
      end
   endfunction 

   function automatic void set_command_transaction_mode( // public
       int mode
   );
      // By default, write burst commands are consolidated into a single
      // command transaction containing the write data for all burst cycles
      // in that command. This mode is set when the mode argument equals 0.
      // When the mode argument is set to 1, the default is overridden and
      // write burst commands yield one command transaction per burst cycle.

      $sformat(message, "%m: method called arg0 %0d ", mode);
      print(VERBOSITY_DEBUG, message);
      consolidate_write_burst_transactions = (mode == 0) ? 1:0;
   endfunction 

   function automatic logic get_command_arbiterlock(); // public
      // Query the received command descriptor for the transaction arbiterlock.
      $sformat(message, "%m: method called");
      print(VERBOSITY_DEBUG, message);
      return client_command.arbiterlock;      
   endfunction 

   function automatic logic get_command_lock(); // public
      // Query the received command descriptor for the transaction lock.
      $sformat(message, "%m: method called");
      print(VERBOSITY_DEBUG, message);
      return client_command.lock;      
   endfunction 

   function automatic logic get_command_debugaccess(); // public
      // Query the received command descriptor for the transaction debugaccess.
      $sformat(message, "%m: method called");
      print(VERBOSITY_DEBUG, message);
      return client_command.debugaccess;      
   endfunction 

   function automatic void set_max_response_queue_size( // public
      int   size
   );
      // Set the maximum pending response queue size threshold. 
      // The public event signal_max_response_queue_size
      // will fire when the threshold is exceeded.
      max_response_queue_size	= size;
   endfunction 

   function automatic void set_min_response_queue_size( // public
      int   size
   );
      // Set the minimum pending response queue size threshold. 
      // The public event signal_min_response_queue_size
      // will fire when the queue level is below this threshold.
      min_response_queue_size	= size;
   endfunction 

   /// New API methods for 10.1   
     
                              
   function automatic logic [AV_TRANSACTIONID_W-1:0] get_command_transaction_id(); // public
      // Query the received command descriptor for the transaction ID.
      $sformat(message, "%m: method called");
      print(VERBOSITY_DEBUG, message);

      return client_command.transaction_id;
   endfunction 

   function automatic logic [AV_TRANSACTIONID_W-1:0] get_command_write_response_request(); // public
      // Query the received command descriptor for value of the 
      // write_response_request field. If it is one, then the master has 
      // requested a write response.
      $sformat(message, "%m: method called");
      print(VERBOSITY_DEBUG, message);

      return client_command.write_response_request;
   endfunction 

   function automatic void set_response_request( // public
      Request_t request
   );
      // Sets the transaction type to read or write in the 
      // response descriptor. The enumeration type defines
      // REQ_READ = 0 and REQ_WRITE = 1.

      client_response.request = request;

      $sformat(message, "%m: method called arg0 %0d", request);
      print(VERBOSITY_DEBUG, message);      
   endfunction 
   
   function automatic void set_read_response_status( // public
      bit [AV_READRESPONSE_W-1:0 ] status,
      int                  index    
   );
      // Set the read response status code.
      $sformat(message, "%m: method called arg0 %0d", status);
      print(VERBOSITY_DEBUG, message);

      client_response.read_status[index] = status;	
   endfunction 

   function automatic void set_write_response_status( // public
      bit [AV_WRITERESPONSE_W-1:0] status,
      int                   index
   );
      // Set the write response status code.
      $sformat(message, "%m: method called arg0 %0d", status);
      print(VERBOSITY_DEBUG, message);

      client_response.write_status[index] = status;
   endfunction 

   function automatic void set_read_response_id( // public
      bit [AV_TRANSACTIONID_W-1:0] id
   );
      // Set the transaction ID sent out on the avs_readid pin
      $sformat(message, "%m: method called arg0 %0d", id);
      print(VERBOSITY_DEBUG, message);

      client_response.read_id = id;
   endfunction 

   function automatic void set_write_response_id( // public
      bit [AV_TRANSACTIONID_W-1:0] id
   );
      // Set the transaction ID sent out on the avs_writeid pin      
      $sformat(message, "%m: method called arg0 %0d", id);
      print(VERBOSITY_DEBUG, message);

      client_response.write_id = id;
   endfunction 
   
   function automatic bit get_slave_bfm_status(); // public
      // Query the availability to accept new read transaction.
      // Return 1 when slave BFM is accumulate maximum pending reads
      // Return 0 when slave BFM not yet accumulate maximum pending reads
      $sformat(message, "%m: method called");
      print(VERBOSITY_DEBUG, message);

      return slave_is_full;
   endfunction

   function automatic int get_pending_read_latency_cycle(); // public
      // Query the pending ready latency cycles for current read response.
      $sformat(message, "%m: method called");
      print(VERBOSITY_DEBUG, message);

      return pending_rlc;
   endfunction
   
   function automatic int get_pending_write_latency_cycle(); // public
      // Query the pending write latency cycles for current write response.
      $sformat(message, "%m: method called");
      print(VERBOSITY_DEBUG, message);

      return pending_wlc;
   endfunction
   
   function automatic logic get_clken();  // public
      // Return the clken status
      $sformat(message, "%m: method called");      
      print(VERBOSITY_DEBUG, message);
      return clken_register;
   endfunction 
   
   //=cut      
   //--------------------------------------------------------------------------
   // Private Methods
   // Note that private methods and events are prefixed with '__'
   //--------------------------------------------------------------------------

   function automatic int __check_transaction_index(int index);
      if (index > lindex(MAX_BURST_SIZE)) begin
         $sformat(message,"%m: Cycle index %0d exceeds MAX_BURST_SIZE-1 %0d",
                  index, lindex(MAX_BURST_SIZE));
         print(VERBOSITY_ERROR, message);
         ->signal_fatal_error;
         return 0;
      end else begin
         return 1;
      end
   endfunction
   
   function automatic void __init_descriptors();
      command_queue_size = 0;
      pending_read_counter = 0;
      slave_is_full = 0;
      temp_pending_rlc = 0;
      slave_is_full = 0;
      pending_rlc = 0;

   endfunction   
   
   function automatic void __init_queues();
      command_queue = {};
      issued_read_command_queue = {};
      issued_write_command_queue = {};   
      read_response_queue = {};
      write_response_queue = {};
   endfunction        
   
   function automatic void __drive_read_response_idle();
      avs_readdata           = 'x;
      avs_readdatavalid      = '0;
      avs_readresponse       = 'x; 
      avs_readid             = 'x;       
   endfunction

   function automatic void __drive_write_response_idle();
      avs_writeresponsevalid = '0;
      avs_writeresponse      = 'x;
      avs_writeid            = 'x;
   endfunction

   function automatic void __drive_response_idle();
      __drive_read_response_idle();
      __drive_write_response_idle();            
   endfunction      
   
   function automatic void __drive_waitrequest_idle();
      if (AV_REGISTERINCOMINGSIGNALS)
         avs_waitrequest = 1'b1;
      else
         avs_waitrequest = '0;
   endfunction
   
   function automatic void __reset();
      __drive_response_idle();
      __init_queues();
      __init_descriptors();
      avs_waitrequest = 1'b1;
   endfunction

   function automatic logic [lindex(AV_DATA_W):0] __byte_mask_data(
      logic [lindex(AV_DATA_W):0] data,
      logic [lindex(AV_NUMSYMBOLS):0] byte_enable
    );
      bit [lindex(AV_DATA_W):0]  mask;

      for (int i=0; i < AV_NUMSYMBOLS; i++) begin
         for (int j=0; j < AV_SYMBOL_W; j++) begin
            mask[(i*AV_SYMBOL_W)+j] = byte_enable[i];
         end
      end
      return(data & mask);
   endfunction

   function automatic string __request_str(Request_t request);
      case(request)
         REQ_READ: return "Read";
         REQ_WRITE: return "Write";
         REQ_IDLE: return "Idle";
      endcase 
   endfunction
   
   function automatic void __print_command(string text, 
                                           SlaveCommand_t command);
      string message;

      print_divider(VERBOSITY_DEBUG);                      
      $sformat(message, "%m: %s", text);      
      print(VERBOSITY_DEBUG, message);      
      $sformat(message, "Request:     %s", __request_str(command.request));
      print(VERBOSITY_DEBUG, message);
      $sformat(message, "Address:     %0x", command.address);
      print(VERBOSITY_DEBUG, message);      
      $sformat(message, "Burst Count: %0x", command.burst_count);
      print(VERBOSITY_DEBUG, message);
      for (int i=0; i<command.burst_count; i++) begin
         $sformat(message, "  index: %0d data: %0x enables: %0x idles: %0d", 
                  i, command.data[i], 
                  command.byte_enable[i], command.idle[i]);
         print(VERBOSITY_DEBUG, message);
      end
   endfunction

   function automatic void __print_current_command(string text);
      string message;
      __print_command(text, current_command);
   endfunction

   function automatic void __print_client_command(string text);
      string message;
      __print_command(text, client_command);
   endfunction
   
   function automatic void __print_response(string text, SlaveResponse_t response);
      string message;
      print_divider(VERBOSITY_DEBUG);
      $sformat(message, "%m: %s", text);
      print(VERBOSITY_DEBUG, message);
      $sformat(message, "Request:     %s", __request_str(response.request));
      print(VERBOSITY_DEBUG, message);
      $sformat(message, "Burst Count: %0x", response.burst_count);
      print(VERBOSITY_DEBUG, message);
      $sformat(message, "  write id: %0d read id: %0d",
               response.write_id, response.read_id);   
      print(VERBOSITY_DEBUG, message);	       
      for (int i=0; i<response.burst_count; i++) begin
         $sformat(message, "  index: %0d data: %0x read latency: %0d",
                  i, response.data[i], response.latency[i]);
         print(VERBOSITY_DEBUG, message);
         $sformat(message, "  index: %0d write status: %0x read status: %0x",
                  i, response.write_status[i], response.read_status[i]);   
         print(VERBOSITY_DEBUG, message);	 
      end
      print_divider(VERBOSITY_DEBUG);        
   endfunction
   
   function automatic void __hello();
      // Introduction Message to console      
      $sformat(message, "%m: - Hello from altera_avalon_mm_slave_bfm");
      print(VERBOSITY_INFO, message);            
      $sformat(message, "%m: -   $Revision: #1 $");
      print(VERBOSITY_INFO, message);            
      $sformat(message, "%m: -   $Date: 2013/03/07 $");
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   AV_ADDRESS_W             = %0d", 
               AV_ADDRESS_W);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   AV_SYMBOL_W              = %0d", 
               AV_SYMBOL_W);
      print(VERBOSITY_INFO, message);      
      $sformat(message, "%m: -   AV_NUMSYMBOLS            = %0d", 
               AV_NUMSYMBOLS);
      print(VERBOSITY_INFO, message);      
      $sformat(message, "%m: -   AV_BURSTCOUNT_W          = %0d", 
               AV_BURSTCOUNT_W);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   AV_READRESPONSE_W        = %0d", 
               AV_READRESPONSE_W);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   AV_WRITERESPONSE_W       = %0d", 
               AV_WRITERESPONSE_W);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   REGISTER_WAITREQUEST     = %0d", 
               REGISTER_WAITREQUEST);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   AV_FIX_READ_LATENCY      = %0d", 
               AV_FIX_READ_LATENCY);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   AV_MAX_PENDING_READS     = %0d", 
               AV_MAX_PENDING_READS);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   AV_READ_WAIT_TIME        = %0d", 
               AV_READ_WAIT_TIME);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   AV_WRITE_WAIT_TIME       = %0d", 
               AV_WRITE_WAIT_TIME);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   USE_READ                 = %0d", 
               USE_READ);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   USE_WRITE                = %0d", 
               USE_WRITE);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   USE_ADDRESS              = %0d", 
               USE_ADDRESS);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   USE_BYTE_ENABLE          = %0d", 
               USE_BYTE_ENABLE);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   USE_BURSTCOUNT           = %0d", 
               USE_BURSTCOUNT);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   USE_READ_DATA            = %0d", 
               USE_READ_DATA);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   USE_READ_DATA_VALID      = %0d",
               USE_READ_DATA_VALID);
      print(VERBOSITY_INFO, message);      
      $sformat(message, "%m: -   USE_WRITE_DATA           = %0d", 
               USE_WRITE_DATA);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   USE_BEGIN_TRANSFER       = %0d", 
               USE_BEGIN_TRANSFER);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   USE_BEGIN_BURST_TRANSFER = %0d", 
               USE_BEGIN_BURST_TRANSFER);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   USE_WAIT_REQUEST         = %0d", 
               USE_WAIT_REQUEST);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   USE_ARBITERLOCK          = %0d", 
               USE_ARBITERLOCK);
      $sformat(message, "%m: -   USE_LOCK                 = %0d", 
               USE_LOCK);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   USE_DEBUGACCESS          = %0d", 
               USE_DEBUGACCESS);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   USE_TRANSACTIONID        = %0d", 
               USE_TRANSACTIONID);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   USE_WRITERESPONSE        = %0d", 
               USE_WRITERESPONSE);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   USE_READRESPONSE         = %0d", 
               USE_READRESPONSE);
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   USE_CLKEN                = %0d", 
               USE_CLKEN);
      print(VERBOSITY_INFO, message);      
      print_divider(VERBOSITY_INFO);      
   endfunction
   
   //--------------------------------------------------------------------------
   // Internal Machinery
   //--------------------------------------------------------------------------

   initial begin
      __hello();

      drive_read_response_semaphore = new(1); // drive_responses are forked
      drive_write_response_semaphore = new(1); 
      
      if (USE_READ_DATA_VALID == 0 && USE_BURSTCOUNT > 0 && USE_READ == 1) begin
         $sformat(message, 
         "%m: USE_READ_DATA_VALID must be enabled if USE_READ and USE_BURSTCOUNT enabled");
         print(VERBOSITY_ERROR, message);
         ->signal_fatal_error;
      end 
      if (USE_BURSTCOUNT > 0 && 
            (AV_BURSTCOUNT_W < 1 || AV_BURSTCOUNT_W > 11)) begin
         $sformat(message,
             "%m: Illegal AV_BURSTCOUNT_W specified - range must be [1..11]");
         print(VERBOSITY_WARNING, message);
      end

      if (USE_WAIT_REQUEST == 0) begin
         for (int i=0; i<MAX_BURST_SIZE; i++) begin
            read_wait_time[i] =  AV_READ_WAIT_TIME;
            write_wait_time[i] =  AV_WRITE_WAIT_TIME;	    
         end
      end else begin
         if (AV_REGISTERINCOMINGSIGNALS) begin
            for (int i=0; i<MAX_BURST_SIZE; i++) begin
               read_wait_time[i] = 1;
               write_wait_time[i] = 1;
            end
         end
      end
   end

   always @(posedge clk) begin
      if (read_response_queue.size() > max_response_queue_size) begin       
         ->signal_max_response_queue_size;
      end else if (read_response_queue.size() < min_response_queue_size) begin
         ->signal_min_response_queue_size;
      end
   end
   
   always @(signal_fatal_error) abort_simulation();            
   
   always @(posedge clk) begin
      if (!USE_CLKEN || avs_clken == 1)
         clock_counter <= clock_counter + 1;
   end
   
   //--------------------------------------------------------------------------
   // Avalon Bus Monitor
   //--------------------------------------------------------------------------

   always @(posedge clk or posedge reset) begin
      clken_register <= avs_clken;
      if (reset) begin
         __reset();
      end else begin
         if (!USE_CLKEN || avs_clken == 1)
            #1 monitor_request();  
      end
   end

   task automatic monitor_request();
      if (avs_read && avs_write) begin
         current_command.address = avs_address;
         $sformat(message, "%m: Error - both write and read active at address: %0d", 
                  current_command.address);
         print(VERBOSITY_FAILURE, message);
         ->signal_fatal_error;
      end else if (avs_write) begin
         request_time_stamp = clock_counter;  

         if (USE_BEGIN_BURST_TRANSFER) begin
            beginbursttransfer = avs_beginbursttransfer;
         end else begin
            if (USE_BURSTCOUNT) begin
               if (burst_mode)
                  beginbursttransfer = 0;
               else
                  beginbursttransfer = 1;
            end else begin
               beginbursttransfer = 0;
            end
         end
         
         if (beginbursttransfer) begin
            current_command = '0;
            addr_offset = 0;
            if (addr_offset == avs_burstcount-1) begin
               burst_mode = 0;
            end else
               burst_mode = 1;
         end else if (burst_mode) begin
            if (addr_offset == current_command.burst_count-1) begin
               beginbursttransfer = 1;
               current_command = '0;
               addr_offset = 0;
            end else begin
               addr_offset++;
               if (addr_offset == current_command.burst_count-1)
                  burst_mode = 0;
            end
         end else begin
            current_command = '0;
            burst_mode = 0;
            addr_offset = 0;
         end  

         current_command.request                  = REQ_WRITE;
         
         current_command.data[addr_offset]        = avs_writedata;
         current_command.byte_enable[addr_offset] = avs_byteenable;
         if (addr_offset == 0) begin
            current_command.burst_count            = avs_burstcount;
            current_command.address                = avs_address;
            current_command.transaction_id         = avs_transactionid;
            current_command.write_response_request = avs_writeresponserequest;
         end
         current_command.burst_cycle              = addr_offset; 
         current_command.arbiterlock              = avs_arbiterlock;
         current_command.lock                     = avs_lock;
         current_command.debugaccess              = avs_debugaccess;
         
         
         
         if ((consolidate_write_burst_transactions &&
            (addr_offset == current_command.burst_count-1)) ||
            !consolidate_write_burst_transactions) begin
             
            command_queue.push_front(current_command);
            $sformat(message, "%m: write - addr: %0x", current_command.address);
            print(VERBOSITY_DEBUG, message);

            command_received_counter++;
            ->signal_command_received;

            if (USE_WRITERESPONSE == 1) begin
               issued_command.time_stamp = clock_counter;
               issued_command.command = current_command;
               issued_write_command_queue.push_front(issued_command);
            end
         end
             
         // test program may react to the signal by calling the
         // set_interface_wait_time method
         fork: wait_set_write
            begin
               @(__signal_wait_cycles_set);
            end
            begin
               #1;
            end
         join_any: wait_set_write
         disable fork;

         avs_waitrequest = 1'b1;
         
         repeat(write_wait_time[addr_offset]) begin
            @(posedge clk);
            if (USE_CLKEN) begin
               while (!avs_clken) begin
                  @(posedge clk);
                  if (reset) begin
                     __reset();
                     return;
                  end
               end
            end
            if (reset) begin
               __reset();
               return;
            end
            beginbursttransfer = 0;
         end
         avs_waitrequest = 1'b0;
      end else if (avs_read) begin 
         request_time_stamp = clock_counter;  

         current_command = '0;
         burst_mode = 0;
         addr_offset = 0;
         pending_read_counter++;
         if ((pending_read_counter < AV_MAX_PENDING_READS) || AV_MAX_PENDING_READS == 0)
            slave_is_full = 0;
         else begin
            slave_is_full = 1;
            if (pending_read_counter > AV_MAX_PENDING_READS) begin
                $sformat(message, 
                "%m: Pipelined read commands %0d > AV_MAX_PENDING_READS %0d", 
                pending_read_counter, AV_MAX_PENDING_READS);
                print(VERBOSITY_ERROR, message);
                ->signal_error_exceed_max_pending_reads; 
            end
         end
         
         
         // according to the Avalon spec, we expect that the master does 
         // not drive writedata and byteenable during read request, but
         // this behaviour may be violated in custom components
          
         current_command.request                = REQ_READ;
         current_command.address                = avs_address;
         current_command.data                   = avs_writedata; 
         current_command.byte_enable            = avs_byteenable; 
         if (USE_BURSTCOUNT == 1)
            current_command.burst_count         = avs_burstcount;
         else
            current_command.burst_count         = 1;
         current_command.arbiterlock            = avs_arbiterlock;
         current_command.lock                   = avs_lock;
         current_command.debugaccess            = avs_debugaccess;
         current_command.transaction_id         = avs_transactionid;
         current_command.write_response_request = avs_writeresponserequest;
          
         command_queue.push_front(current_command);

         issued_command.time_stamp = clock_counter;
         issued_command.command = current_command;  // not used for now
         issued_read_command_queue.push_front(issued_command);
          
         $sformat(message, "%m: read - addr: %0x", current_command.address);
         print(VERBOSITY_DEBUG, message);

         read_command_received_counter++;
         command_received_counter++;
         ->signal_command_received;

         // Slaves with pipelined reads have a defined maximum latency.
         // Emit a warning and issue a (public) event which can be monitored
         // by the test bench if the limit is exceeded.

         // Note: We may consider asserting a waitrequest when the queued 
         // up read commands exceed this limit. This is not implemented.
         command_queue_size = get_command_queue_size();
          
         if ((USE_READ_DATA_VALID > 0) && 
            (command_queue_size > AV_MAX_PENDING_READS) &&
            (AV_MAX_PENDING_READS != 0)) begin
            $sformat(message, 
            "%m: Pipelined read commands %0d > AV_MAX_PENDING_READS %0d", 
            command_queue_size, AV_MAX_PENDING_READS);
            print(VERBOSITY_ERROR, message);
            ->signal_error_exceed_max_pending_reads; 
         end
          
         // test program may react to the signal by calling the
         // set_interface_wait_time method
         fork: wait_set_read
            begin
               @(__signal_wait_cycles_set);
            end
            begin
               #1;
            end
         join_any: wait_set_read
         disable fork;

         avs_waitrequest = 1'b1;

         repeat(read_wait_time[addr_offset]) begin
            @(posedge clk);
            if (USE_CLKEN) begin
               while (!avs_clken) begin
                  @(posedge clk);
                  if (reset) begin
                     __reset();
                     return;
                  end
               end
            end
            if (reset) begin
               __reset();
               return;
            end
         end
         avs_waitrequest = 1'b0;
      end else begin 
         if (reset)
            avs_waitrequest = 1'b1;
         else begin
            if (AV_REGISTERINCOMINGSIGNALS)
               avs_waitrequest = 1'b1;
            else
               avs_waitrequest = 1'b0;
         end
         beginbursttransfer = 0;
      end
   endtask

   //--------------------------------------------------------------------------
   // Avalon Bus Drivers
   //--------------------------------------------------------------------------
   
   always @(negedge clk or posedge reset) begin  
      // slave responses are driven mid cycle
      if (reset) begin
         read_response_queue = {};
         __drive_read_response_idle();
         drive_read_response_state = 0;
         read_response_sequence_counter = 1;
         pending_read_counter = 0;
         slave_is_full = 0;
         temp_pending_rlc = 0;
         pending_rlc = 0;
         last_read_response_sequence_counter  = 1;
      //__reset();
      end else begin
         if (!USE_CLKEN || avs_clken == 1) begin
            drive_read_response_state = 0;  

            if (read_response_queue.size() > 0 && 
               issued_read_command_queue.size() > 0) begin

               current_read_response = read_response_queue.pop_back();
               pending_command = issued_read_command_queue.pop_back();
                
               read_response_sequence_counter++;
               ->__signal_command_end;

               __print_response("Popped Response Queue", current_read_response);
               drive_read_response_state = 1;
            end 

            // Schedule the response to be driven in a future time slot
            // Do this each clock cycle without blocking on previous responses
             
            if (drive_read_response_state) begin
               fork
                  begin
                     drive_read_response(pending_command,
                                         current_read_response, 
                                         read_response_sequence_counter);
                  end
               join_none
            end
         end
      end 
   end

   task automatic drive_read_response(IssuedCommand_t pending_command,
                                      SlaveResponse_t current_response,
                                      int             response_sequence_counter
   );
      int            response_time_stamp           = 0;
      int            current_latency               = 0;
      int            next_scheduled_response_cycle = 0;
      
      SlaveCommand_t current_command;
      
      if (reset) begin
         __drive_read_response_idle();
      end else begin
         if (!USE_CLKEN || avs_clken == 1) begin
            current_command = pending_command.command;  

            response_time_stamp = clock_counter + 1;

            // do not drive a response while in wait state
            while (avs_waitrequest) begin
               @(negedge clk);
               if (reset) begin
                  __reset();
                  return;
               end
            end
            
            if (USE_CLKEN) begin
               while (!avs_clken) begin
                  @(negedge clk);
                  if (reset) begin
                     __reset();
                     return;
                  end
               end
            end
          
            if (current_response.request == REQ_READ && USE_READ_DATA_VALID == 0) begin
               repeat (AV_FIX_READ_LATENCY) begin
                  @(negedge clk);
                  if (reset) begin
                     __reset();
                     return;
                  end
                  if (USE_CLKEN) begin
                     while (!avs_clken) begin
                        @(negedge clk);
                        if (reset) begin
                           __reset();
                           return;
                        end
                     end
                  end
               end
            end
               
            for (int i=0; i<current_response.burst_count; i++) begin
               if (current_response.request == REQ_READ && USE_READ_DATA_VALID > 0) begin
                
                  current_latency = current_response.latency[i];
                        
                  if ((i==0) && (current_latency == 0)) begin
                     next_scheduled_response_cycle = clock_counter + current_latency + 1;
                  end else begin
                     next_scheduled_response_cycle = clock_counter + current_latency;
                  end
                
                  $sformat(message, "%m: current response %0d - latency = %0d", 
                           response_sequence_counter, current_latency);
                  print(VERBOSITY_DEBUG, message);

                  if (i>0) begin
                     if (drive_read_response_semaphore.try_get(1) > 0) begin
                        __drive_read_response_idle();
                        drive_read_response_semaphore.put(1);
                     end else begin
                        $sformat(message, 
                                 "%m: Response transaction %0d, cycle %0d - schedule conflict",
                                 response_sequence_counter, i);
                        print(VERBOSITY_ERROR, message);    
                     end
                  end

                  while (clock_counter < next_scheduled_response_cycle) begin
                     for (int j = i+1; j < current_response.burst_count; j++) begin
                        temp_pending_rlc = temp_pending_rlc + current_response.latency[j];
                     end
                     temp_pending_rlc = temp_pending_rlc + current_response.burst_count - i - 1;
                     if (store_read_resp_clock_counter == clock_counter) begin
                        if (pending_rlc > temp_pending_rlc + next_scheduled_response_cycle - clock_counter)
                           pending_rlc = temp_pending_rlc + next_scheduled_response_cycle - clock_counter;
                     end else begin
                        pending_rlc = temp_pending_rlc + next_scheduled_response_cycle - clock_counter;
                     end
                     
                     store_read_resp_clock_counter = clock_counter;
                     temp_pending_rlc = 0;
                     @(negedge clk);
                     if (reset) begin
                        __reset();
                        return;
                     end
                     if (USE_CLKEN) begin
                        while (!avs_clken) begin
                           @(negedge clk);
                           if (reset) begin
                              __reset();
                              return;
                           end
                        end
                     end
                  end
                  for (int j = i+1; j < current_response.burst_count; j++) begin
                     temp_pending_rlc = temp_pending_rlc + current_response.latency[j];
                  end
                  temp_pending_rlc = temp_pending_rlc + current_response.burst_count - i - 1;
                  pending_rlc = temp_pending_rlc + next_scheduled_response_cycle - clock_counter;
                  temp_pending_rlc = 0; 
                  store_read_resp_clock_counter = clock_counter;
               end

               // allow only one thread to drive the bus at a time
               if (drive_read_response_semaphore.try_get(1) > 0) begin
                
                  if (response_sequence_counter >= 
                     last_read_response_sequence_counter) begin
                     last_read_response_sequence_counter = response_sequence_counter; 
                  end else begin
                     $sformat(message, 
                          "%m: Response sequence count %0d < previous", 
                     response_sequence_counter);
                     print(VERBOSITY_ERROR, message);
                  end

                  if (USE_READRESPONSE > 0) begin
                     avs_readresponse       = current_response.read_status[i];
                     avs_readid             = current_response.read_id;

                     $sformat(message, 
                        "%m: Read Response id: %0d status: %0h",
                              current_response.read_id, current_response.read_status[i]);
                     print(VERBOSITY_DEBUG, message);
                  end else begin
                     avs_readresponse = 'x;
                     avs_readid       = 'x;
                  end

                  if (USE_READ_DATA_VALID) begin
                     avs_readdatavalid = 1;
                  end
                  avs_readdata  = current_response.data[i];

                  // latency is with respect to previous burst response cycle
                  // (not the time of the Read command initiation)
             
                  pending_command.time_stamp = clock_counter; 
             
                  if (i < current_response.burst_count-1) begin
                     @(negedge clk);
                     if (reset) begin
                        drive_read_response_semaphore.put(1);
                        __reset();
                        return;
                     end
                     if (USE_CLKEN) begin
                        while (!avs_clken) begin
                           @(negedge clk);
                           if (reset) begin
                              drive_read_response_semaphore.put(1);
                              __reset();
                              return;
                           end
                        end
                     end
                  end

                  // hold semaphore long enough for drive_response_idle
                  // always block to see that it has been taken
                  #1;   
                
                  drive_read_response_semaphore.put(1);
               end else begin 
                  $sformat(message, 
                           "%m: Response transaction %0d, cycle %0d - schedule conflict",
                           response_sequence_counter, i);
                  print(VERBOSITY_ERROR, message);	       
               end
            end
            pending_read_counter--;
            if ((pending_read_counter < AV_MAX_PENDING_READS) || AV_MAX_PENDING_READS == 0)
               slave_is_full = 0;
            else
               slave_is_full = 1;
            ->signal_response_issued;
         end
      end 
   endtask

   ///for debug
   int write_response_queue_size;
   int issued_write_command_queue_size;
   ///

   always @(negedge clk or posedge reset) begin  
      // slave responses are driven mid cycle
      if (reset) begin
         write_response_queue = {};
         __drive_write_response_idle();
         drive_write_response_state = 0;
         write_response_sequence_counter = 1;
         last_write_response_sequence_counter = 1;
      end else begin
         if (!USE_CLKEN || avs_clken == 1) begin
            drive_write_response_state = 0;  

            ///for debug
            write_response_queue_size = write_response_queue.size();
            issued_write_command_queue_size = issued_write_command_queue.size();
            ///
             
            if (write_response_queue.size() > 0 && 
               issued_write_command_queue.size() > 0) begin

               current_write_response = write_response_queue.pop_back();
               pending_command = issued_write_command_queue.pop_back();
                
               write_response_sequence_counter++;
               ->__signal_command_end;

               __print_response("Popped Response Queue", current_write_response);
               drive_write_response_state = 1;
            end 

            // Schedule the response to be driven in a future time slot
            // Do this each clock cycle without blocking on previous responses
             
            if (drive_write_response_state) begin
               fork
                  begin
                     drive_write_response(pending_command,
                                          current_write_response, 
                                          write_response_sequence_counter);
                  end
               join_none
            end 
         end
      end 
   end

   
   task automatic drive_write_response(IssuedCommand_t pending_command,
                                      SlaveResponse_t current_response,
                                      int             response_sequence_counter
   );
      int            response_time_stamp           = 0;
      int            current_latency               = 0;
      int            next_scheduled_response_cycle = 0;

      SlaveCommand_t current_command;
      
      if (reset) begin
          __drive_write_response_idle();
      end else begin
         if (!USE_CLKEN || avs_clken == 1) begin
            current_command = pending_command.command;  

            response_time_stamp = clock_counter + 1;

            // do not drive a response while in wait state
            while (avs_waitrequest) begin
               @(negedge clk);
               if (reset) begin
                  __reset();
                  return;
               end
            end
               
            if (USE_CLKEN) begin
               while (!avs_clken) begin
                  @(negedge clk);
                  if (reset) begin
                     __reset();
                     return;
                  end
               end
            end
       
            for (int i=0; i<current_response.burst_count; i++) begin
               if (current_response.request == REQ_WRITE && USE_WRITERESPONSE != 0) begin
                
                  current_latency = current_response.latency[i];

                  if ((i==0) && (current_latency == 0)) begin
                     next_scheduled_response_cycle = clock_counter + current_latency + 1;
                  end else begin
                     next_scheduled_response_cycle = clock_counter + current_latency;
                  end
             
                  $sformat(message, "%m: Current Write Response %0d - latency = %0d", 
                           response_sequence_counter, current_latency);
                  print(VERBOSITY_DEBUG, message);

                  if (i>0) begin
                     if (drive_write_response_semaphore.try_get(1) > 0) begin
                        __drive_write_response_idle();
                        drive_write_response_semaphore.put(1);
                     end else begin
                        $sformat(message, 
                                 "%m: Write Response transaction %0d, cycle %0d - schedule conflict",
                                 response_sequence_counter, i);
                        print(VERBOSITY_ERROR, message);    
                     end
                  end

                  while (clock_counter < next_scheduled_response_cycle) begin
                     for (int j = i+1; j < current_response.burst_count; j++)
                        temp_pending_wlc = temp_pending_wlc + current_response.latency[j];
                     temp_pending_wlc = temp_pending_wlc + current_response.burst_count - i - 1;
                     
                     if (store_write_resp_clock_counter == clock_counter) begin
                        if (pending_wlc > temp_pending_wlc + next_scheduled_response_cycle - clock_counter)
                           pending_wlc = temp_pending_wlc + next_scheduled_response_cycle - clock_counter;
                     end else begin
                        pending_wlc = temp_pending_wlc + next_scheduled_response_cycle - clock_counter;
                     end
                     
                     store_write_resp_clock_counter = clock_counter;
                     temp_pending_wlc = 0;
                     @(negedge clk);
                     if (reset) begin
                        __reset();
                        return;
                     end
                     if (USE_CLKEN) begin
                        while (!avs_clken) begin
                           @(negedge clk);
                           if (reset) begin
                              __reset();
                              return;
                           end
                        end
                     end
                  end
                  for (int j = i+1; j < current_response.burst_count; j++)
                     temp_pending_wlc = temp_pending_wlc + current_response.latency[j];
                  temp_pending_wlc = temp_pending_wlc + current_response.burst_count - i - 1;
                  pending_wlc = temp_pending_wlc + next_scheduled_response_cycle - clock_counter;
                  temp_pending_wlc = 0; 
                  store_write_resp_clock_counter = clock_counter;
               end

               // allow only one thread to drive the bus at a time
               if (drive_write_response_semaphore.try_get(1) > 0) begin
                
                  if (response_sequence_counter >= 
                     last_write_response_sequence_counter) begin
                     last_write_response_sequence_counter = response_sequence_counter; 
                  end else begin
                     $sformat(message, 
                              "%m: Response sequence count %0d < previous", 
                              response_sequence_counter);
                     print(VERBOSITY_ERROR, message);
                  end
             
                  if (current_response.request == REQ_WRITE) begin
                     if (USE_WRITERESPONSE > 0) begin
                        avs_writeresponsevalid = 1'b1;
                        avs_writeresponse      = current_response.write_status[i];
                        avs_writeid            = current_response.write_id;

                        $sformat(message, 
                           "%m: Write Response id: %0d status: %0h",
                        current_response.write_id, current_response.write_status[i]);
                        print(VERBOSITY_DEBUG, message); 
                     end else begin
                        avs_writeresponsevalid = 1'b0;
                        avs_writeresponse      = 'x;
                        avs_writeid            = 'x;
                     end
                  end else begin
                     avs_writeresponsevalid = 1'b0;
                  end

                  // latency is with respect to previous burst cycle	
                  // (not the time of the Read command initiation)
             
                  pending_command.time_stamp = clock_counter; 
             
                  if (i < current_response.burst_count-1) begin
                     @(negedge clk);
                     if (reset) begin
                        drive_write_response_semaphore.put(1);
                        __reset();
                        return;
                     end
                     if (USE_CLKEN) begin
                        while (!avs_clken) begin
                           @(negedge clk);
                           if (reset) begin
                              drive_write_response_semaphore.put(1);
                              __reset();
                              return;
                           end
                        end
                     end
                  end

                  // hold semaphore long enough for drive_response_idle
                  // always block to see that it has been taken
                  #1;
                
                  drive_write_response_semaphore.put(1);
               end else begin 
                  $sformat(message, 
                           "%m: Response transaction %0d, cycle %0d - schedule conflict",
                           response_sequence_counter, i);
                  print(VERBOSITY_ERROR, message);	       
               end
            end 

            ->signal_response_issued;
         end
      end 
   endtask


   
   always @(negedge clk) begin
      // If no drive_response forked task is driving the bus, we drive bus 
      // to idle state
      // We ensure that this always block is scheduled after any possible
      // blocks which call forked drive_response tasks.
      // That is, driving the response bus to idle has lower priority
      
      #0;
      
      if (drive_read_response_semaphore.try_get(1) > 0) begin
         __drive_read_response_idle();
         drive_read_response_semaphore.put(1);
      end
      if (drive_write_response_semaphore.try_get(1) > 0) begin
         __drive_write_response_idle();
         drive_write_response_semaphore.put(1);
      end      
   end

   always @(posedge clk or posedge reset) begin
      if (reset)
         avs_waitrequest_q1 <= 1'b1;
      else
         avs_waitrequest_q1 <= avs_waitrequest_d1;
   end
   
   // synthesis translate_on  
endmodule
   
// =head1 SEE ALSO
// avalon_mm_master_bfm
// =cut



 
