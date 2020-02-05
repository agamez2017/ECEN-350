`timescale 1ns / 1ps

module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);

	output [63:0] BusA, BusB;
	input [63:0] BusW;
	input RegWr, Clk;
	input [4:0] RA, RB, RW;
	
  	reg [63:0] registers [31:0]; //32 64-bit registers
  
  always@(*)
    begin
      registers[31] <= #3 64'b0;
    end
  	assign #2 BusA = ( (RA==5'd31) ? 64'b0 : registers[RA]);
  	assign #2 BusB = ( (RB==5'd31) ? 64'b0 : registers[RB]);
  
	always@(negedge Clk)
		begin
			if(RegWr) begin
              if(RW != 0)
					registers[RW] <= #3 BusW;
			end
		end
endmodule