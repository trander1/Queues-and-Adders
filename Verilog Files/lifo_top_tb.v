`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:49:07 03/26/2015
// Design Name:   lifo_top
// Module Name:   D:/Modelsim Projects/Xilinx/assignment5/lifo_top_tb.v
// Project Name:  assignment5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: lifo_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module lifo_top_tb;

	// Inputs
	reg [5:0] vector_in;
	reg reset;
	reg clk;

	// Outputs
	wire [3:0] data_out;
	wire empty_flag;
	wire full_flag;

	 //Instantiate the Unit Under Test (UUT)
	 lifo_top lifo (
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
		reset = 1;
		clk = 1;

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
		// 2 Reads
		#2 vector_in = 6'b01_1001;
		#2 vector_in = 6'b01_1001;
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

