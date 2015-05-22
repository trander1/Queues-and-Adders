`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:43:14 03/25/2015
// Design Name:   fifo_top
// Module Name:   S:/Xilinx/assignment5/fifo_top_tb.v
// Project Name:  assignment5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fifo_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fifo_top_tb;

	// Inputs
	reg [5:0] vector_in;
	reg reset;
	reg clk;

	// Outputs
	wire [3:0] data_out;
	wire empty_flag;
	wire full_flag;

	// Instantiate the Unit Under Test (UUT)
	fifo_top fifo (
		.data_out(data_out), 
		.empty_flag(empty_flag), 
		.full_flag(full_flag), 
		.vector_in(vector_in), 
		.reset(reset), 
		.clk(clk)
	);

	initial begin
		// Initialize Inputs
//		vector_in = 0;
		clk = 1;
		reset = 1;
		// Wait 100 ns for global reset to finish
//		#100;
        
		// Add stimulus here
		// 4 writes
		#2 reset = 0; vector_in = 6'b10_1111;
		#2 vector_in = 6'b10_1110;
		#2 vector_in = 6'b10_1101;
		#2 vector_in = 6'b10_1001;
		#2 vector_in = 6'b00_1001;
		// 4 reads
		#2 vector_in = 6'b01_1001;
		#2 vector_in = 6'b01_1001;
		#2 vector_in = 6'b01_1001;
		#2 vector_in = 6'b01_1001;
		#2 vector_in = 6'b00_1001;
		// 4 writes
		#2 vector_in = 6'b10_0000;
		#2 vector_in = 6'b10_0001;
		#2 vector_in = 6'b10_0111;
		#2 vector_in = 6'b10_0110;
		#2 vector_in = 6'b00_1001;
		// 4 more writes
		#2 vector_in = 6'b10_0000;
		#2 vector_in = 6'b10_0001;
		#2 vector_in = 6'b10_0111;
		#2 vector_in = 6'b10_0110;
		#2 vector_in = 6'b00_1001;		
		// 2 writes
		#2 vector_in = 6'b10_1101;
		#2 vector_in = 6'b10_1001;
		#2 vector_in = 6'b00_1000;
		
		#2 $finish;
	end
	
	always
		#1 clk = ~clk;   
		
endmodule

