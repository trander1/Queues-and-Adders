`timescale 1ns / 1ps

`define READ			2'b01
`define WRITE			2'b10
`define DO_NOTHING	2'b00
`define INVALID		2'b11

`define DATA_VALID	1'b1
`define DATA_INVALID	1'b0

`define FIFO_FULL			1'b1
`define FIFO_NOT_FULL	1'b0

`define FIFO_EMPTY		1'b1
`define FIFO_NOT_EMPTY	1'b0

`define LOG2(width) 	(width<=2)?1:\
							(width<=4)?2:\
							(width<=8)?3:\
							(width<=16)?4:\
							(width<=32)?5:\
							(width<=64)?6:\
							(width<=128)?7:\
							(width<=256)?8:\
							-1							
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:33:56 03/25/2015 
// Design Name: 
// Module Name:    fifo_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module fifo_top(
    data_out, empty_flag, full_flag,
    vector_in, reset,
    clk
    );
parameter DATA_WIDTH = 4;
parameter NUM_ENTRIES = 4;
parameter OPCODE_WIDTH = 2;
parameter LINE_WIDTH = DATA_WIDTH+OPCODE_WIDTH; // length of the input vector 
parameter INITIAL_VALUE = 'b0; 
parameter NUM_ENTRIES_BIT = `LOG2(NUM_ENTRIES); 

output reg [DATA_WIDTH-1:0]data_out;
output reg empty_flag;
output reg full_flag;
input [OPCODE_WIDTH+DATA_WIDTH-1:0]vector_in;
input reset;
input clk;

reg [DATA_WIDTH-1:0]fifo_data[NUM_ENTRIES-1:0];
reg [NUM_ENTRIES-1:0]fifo_valid_invalid_bit;

reg [OPCODE_WIDTH-1:0]control_in;	// control bits for the module obtained from the input vector
reg [DATA_WIDTH-1:0]data_in;			// data bits for the module obtained from the input vector

reg [NUM_ENTRIES_BIT-1:0]fifo_head_pos;
reg [NUM_ENTRIES_BIT-1:0]fifo_tail_pos;

reg [NUM_ENTRIES_BIT-1:0]loop_variable;

always@(posedge clk)
begin	
	if(reset)
	begin
		data_out = INITIAL_VALUE;
		fifo_head_pos = INITIAL_VALUE;
		fifo_tail_pos = INITIAL_VALUE;
		loop_variable = INITIAL_VALUE;
		control_in = INITIAL_VALUE;
		data_in = INITIAL_VALUE;
		fifo_valid_invalid_bit = INITIAL_VALUE;
		empty_flag = `FIFO_NOT_EMPTY;
		full_flag = `FIFO_NOT_FULL;
	end else
		begin
			// if the tail and head are at the same location
			if(fifo_tail_pos == fifo_head_pos)begin
				// check if the data contained in that location is VALID/INVALID
				if(fifo_valid_invalid_bit[fifo_tail_pos] == `DATA_INVALID && fifo_valid_invalid_bit[fifo_head_pos] == `DATA_INVALID)
					begin
					// if INVALID, fifo empty
					// $display("INVALID, EMPTY");
					empty_flag = `FIFO_EMPTY;
					full_flag = `FIFO_NOT_FULL;
				end else
					begin
						// else, fifo full
						// $display("VALID, FULL");
						empty_flag = `FIFO_NOT_EMPTY;
						full_flag = `FIFO_FULL;					
					end	
			end else 				
				begin
					// $display("DIFFERENT LOCATIONS");
					empty_flag = `FIFO_EMPTY;
					full_flag = `FIFO_NOT_FULL;
				end				
			// $display("fifo_head_pos:%d, fifo_tail_pos:%d, empty_flag:%d, full_flag:%d", fifo_head_pos, fifo_tail_pos, empty_flag,full_flag);
			control_in = vector_in[LINE_WIDTH-1:LINE_WIDTH-OPCODE_WIDTH];	
			data_in = vector_in[LINE_WIDTH-OPCODE_WIDTH-1:LINE_WIDTH-OPCODE_WIDTH-DATA_WIDTH];
			// $display("control: %d,data_in: %d",control_in, data_in);	
			case(control_in)			
					`READ: 
							begin
								// $display("FIFO READ");						
								if(fifo_valid_invalid_bit[fifo_tail_pos] == `DATA_VALID)
								begin
									data_out = fifo_data[fifo_tail_pos];
									fifo_valid_invalid_bit[fifo_tail_pos] = `DATA_INVALID;
									fifo_tail_pos = fifo_tail_pos + 1'b1;							
								end else
									begin
										data_out = 'bx;
									end
							end	
					`WRITE: 
							begin
								// $display("FIFO WRITE");
								if(empty_flag == `FIFO_EMPTY && full_flag == `FIFO_NOT_FULL)
								begin
									fifo_data[fifo_head_pos] = data_in;
									fifo_valid_invalid_bit[fifo_head_pos] = `DATA_VALID;
									if(fifo_head_pos == NUM_ENTRIES-1)
										fifo_head_pos = 0;
									else	
										fifo_head_pos = fifo_head_pos + 1'b1;
								end 
//								else
									// $display("CACHE FULL, empty_flag:%d, full_flag:%d",empty_flag,full_flag);
							end
					// `INVALID: $display("INVLAID");
					// `DO_NOTHING:
						// begin
							// repeat(NUM_ENTRIES)
							// begin
								// $display("loop_variable:%d, fifo_valid_invalid_bit:%d, fifo_data:%d", loop_variable, fifo_valid_invalid_bit[loop_variable], fifo_data[loop_variable]);
								// loop_variable = loop_variable + 1'b1;
							// end
						// end
					default: data_out = 'bx;
				endcase
		end		
end
endmodule
