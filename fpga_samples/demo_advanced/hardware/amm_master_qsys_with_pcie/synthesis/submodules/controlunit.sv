// $Id: $
// File name:   controlunit.sv
// Created:     11/18/2014
// Author:      Fangda Li
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: control unit SM

module controlunit
  (
    input wire clk,
    input wire n_rst,
    input wire start,
    input wire user_data_available,
    input wire user_buffer_full,
    input wire sweep_done,
    input wire rollover_image,
	 input wire idle_out,
    input wire read_state,
	 
    output reg user_read_buffer,
    output reg user_write_buffer,
    output reg buffer_clear,
    output reg buffer_load,
    output reg load_size,
    output reg n_action,
    output reg rdwr_cntl,
    output reg [2:0] address_select,  //000 row1, 010 row2, 010 row3, 011 write, 100 idle address, 101 ini addr, 111 test addr
    output reg [1:0] rw_load_ctrl,  //00 do nothing  01 for read addrs reload, 10 for write addr reload, 11 for initial load
    output reg count_enable,
    output reg ini_shift,
    output reg data_select,  //0 stop data, 1 normal data
    output reg output_load,
	 output reg LED1,
	 output reg LED2,
	 output reg LED3,
	 output reg LED4,
	 output reg LED5,
	 output reg LED6
  );
  
  typedef enum {IDLE,START_CHECK,READ_LOAD,READ_LOAD1,READ_LOAD2,READ_LOAD3,READ_LOAD4,READ_LOAD5,READ_LOAD6,READ_LOAD7,
  WRITE_LOAD,WRITE_LOAD1,WRITE_LOAD2,WRITE_LOAD3,WRITE_LOAD4,WRITE_LOAD5,WRITE_LOAD6,WRITE_LOAD7,
  COL_LOAD,COL_LOAD1,COL_LOAD2,COL_LOAD3,ROW_LOAD,ROW_LOAD1,ROW_LOAD2,ROW_LOAD3,
  INITIAL_LOAD,INITIAL_LOAD1,
  PIXEL_LOAD,PIXEL_LOAD1,PIXEL_LOAD2,PIXEL_LOAD3,PIXEL_LOAD4,PIXEL_LOAD5,WAIT,OUTPUT_LOAD,
  PIXEL_WRITE,PIXEL_WRITE1,ROW_DONE,STOP_WRITE,STOP_WRITE1,PIXEL_WRITE2,STOP_WRITE2,ADDR_INCR,PIXEL_WRITE_REQ,STOP_WRITE_REQ,PIXEL_WRITE5,READ_ST,PIXEL1_WRITE,PIXEL1_WRITE_REQ} states;
  states state, nextstate;
  
  //assign LED5 = sweep_done;
  //assign LED6 = rollover_image;
  //current state reg                
  always @ (posedge clk, negedge n_rst) begin 
    if(!n_rst) begin
      state <= IDLE;
		LED1 <= 0;
		//LED2 <= 0;
		end
    else begin
      LED1 <= ~LED1;
		//LED2 <= ~LED2;
		state <= nextstate;
		end
    end
	 
  //output logic
  always_comb begin
        user_read_buffer = 0;
        user_write_buffer = 0;
        buffer_clear = 0;
        buffer_load = 0;
        load_size = 0;
        rdwr_cntl = 0;
        address_select = 3'b100;  //default idle address
        rw_load_ctrl = 2'b00;  //00 do nothing  01 for read addrs reload, 10 for write addr reload, 11 for initial load
        n_action = 1;
        count_enable = 0;
        data_select = 1;
        output_load = 0;
        ini_shift = 0;
		  LED2 = 0;
		  LED3 = 0;
		  LED4 = 0;
		  LED5 = 0;
		  LED6 = 0;
    case (state)
	 
	   IDLE: begin
			n_action = 0;
			rdwr_cntl = 0;
			address_select = 3'b100;
			end
		
		READ_ST: begin
			address_select = 3'b100;
			LED2 = 1;
		end
		
		PIXEL_WRITE_REQ:
		begin
			n_action = 0;
			rdwr_cntl = 1;
			data_select = 1;
			address_select = 3'b101;
		end
		
		PIXEL_WRITE: begin
			data_select = 1;
			address_select = 3'b101;
			//address_select = 3'b101;
			LED3 = 1;
		end
		
		ADDR_INCR: begin
			rw_load_ctrl = 2'b10;
		end
		
		PIXEL1_WRITE_REQ: begin
			n_action = 0;
			rdwr_cntl = 1;
			data_select = 1;
			address_select = 3'b110;
		end
      PIXEL1_WRITE: begin
			data_select = 1;
			address_select = 3'b110;
			LED4 = 1;
      end
		
		STOP_WRITE_REQ:
		begin
			n_action = 0;
			rdwr_cntl = 1;
			data_select = 0;
			address_select = 3'b111;
		end
		
		STOP_WRITE: begin
			data_select = 0;
			address_select = 3'b111;
			LED5 = 1;
      end
      default: begin

      end                                                                                                   
		endcase
	end 
		
  always_comb begin
	nextstate = state;
    case (state)
      IDLE: begin
			nextstate = READ_ST;
			end
		READ_ST:
		begin
			if (read_state == 1'b1)
			begin
				if (start == 1'b1)
					nextstate = PIXEL_WRITE_REQ;
				else
					nextstate = IDLE;
			end
			
		end

		PIXEL_WRITE_REQ:
		begin
			nextstate = PIXEL_WRITE;
		end
		PIXEL_WRITE: begin
			if (idle_out)
				nextstate = ADDR_INCR;
		end
		
		ADDR_INCR: begin
			nextstate = PIXEL1_WRITE_REQ;
		end
		
		PIXEL1_WRITE_REQ: begin
			nextstate = PIXEL1_WRITE;
		end
      PIXEL1_WRITE: begin
			if (idle_out)
				nextstate = STOP_WRITE_REQ;
      end
		
		STOP_WRITE_REQ:
		begin
			nextstate = STOP_WRITE;
		end
		STOP_WRITE: begin
		if(idle_out) begin
			nextstate = IDLE;
      end	
      end
      default: begin

        end                                                        
		 endcase
		end 		
		
endmodule


		/*
		READ_REQ_ST: begin
			nextState = READ_WAIT_ST;
		end
		READ_WAIT_ST: begin
			if ( read_control_done ) begin
				nextState = READ_ACK_ST;
			end
		end
		READ_ACK_ST: begin
			nextState = READ_DATA_ST;

		end
		READ_DATA_ST: begin
			//Here the Start Decoder can check the value.
			//Or take Start Decoder logic inside the state (better).
			if(read_user_buffer_output_data == 8'h53)	//LOOP BREAK.
			begin
				next_state = PIXEL_WRITE;
			end
			else
			begin
				next_state = IDLE;
			end;
		end*/

/*		ADDR_INCR: begin
			nextstate = PIXEL_WRITE3;
		end
		
		PIXEL_WRITE3: begin
		if(user_buffer_full == 1'b0) begin
			nextstate = PIXEL_WRITE4;
      end
		end
      PIXEL_WRITE4: begin
			nextstate = PIXEL_WRITE5;
      end	
		PIXEL_WRITE5: begin
			nextstate = STOP_WRITE;
      end
	*/	
/*		ADDR_INCR: begin
			nextstate = PIXEL_WRITE3;
		end
		
		PIXEL_WRITE3: begin
		if(user_buffer_full == 1'b0) begin
			nextstate = PIXEL_WRITE4;
      end
		end
      PIXEL_WRITE4: begin
			nextstate = PIXEL_WRITE5;
      end	
		PIXEL_WRITE5: begin
			nextstate = STOP_WRITE;
      end
	*/	
 /*     IDLE: begin
		  user_read_buffer = 0;
        user_write_buffer = 0;
        buffer_clear = 0;
        buffer_load = 0;
        load_size = 0;
        //rdwr_cntl = 0;
        address_select = 3'b100;  //default idle address, else -> 32'h00000008
        rw_load_ctrl = 2'b00;  //default do nothing
        count_enable = 0;
        output_load = 0;
        ini_shift = 0;
        rdwr_cntl = 0;
        n_action = 0;
		  LED2 = 1;		  
      end
		START_CHECK: begin
		  address_select = 3'b011;
		  data_select = 1;	
		end
		PIXEL_WRITE: begin
		  rdwr_cntl = 1;
        n_action = 0;
		  address_select = 3'b011;  //000 row1, 010 row2, 010 row3, 011 write, 100 idle address, 101 ini addr, 111 test addr
		  data_select = 1;
		  LED3 = 1;
      end
		PIXEL_WRITE1: begin
		  rdwr_cntl = 1;        n_action = 0;
		  address_select = 3'b011;
		  data_select = 1;
		  LED3 = 1;
      end
      PIXEL_WRITE2: begin
			LED4 = 1;
			address_select = 3'b011;
			data_select = 1;
      end	
		  
		ADDR_INCR: begin
			rw_load_ctrl = 2'b10;
      end
		  
		PIXEL_WRITE3: begin
		  rdwr_cntl = 1;
        n_action = 0;
		  address_select = 3'b011;
		  data_select = 0;
		  LED3 = 1;
      end
		PIXEL_WRITE4: begin
		  rdwr_cntl = 1;
        n_action = 0;
		  address_select = 3'b011;
		  data_select = 0;
		  LED3 = 1;
      end
      PIXEL_WRITE5: begin
			LED4 = 1;
			address_select = 3'b011;
			data_select = 0;
      end			
		
		STOP_WRITE: begin
		  rdwr_cntl = 1;
        n_action = 0;
		  data_select = 0;
		  address_select = 3'b111;  //00000004
		  LED5 = 1;
        end
      STOP_WRITE1: begin
		  rdwr_cntl = 1;
        n_action = 0;
		  LED6 = 1;
		  data_select = 0;
		  address_select = 3'b111;
        end
      STOP_WRITE2: begin
		  LED6 = 1;
		  address_select = 3'b111;
		  data_select = 0;
        end 		  
      default: begin

        end  */  