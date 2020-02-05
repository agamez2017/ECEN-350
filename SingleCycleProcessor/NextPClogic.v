`timescale 1ns / 1ps

/*This module implements the NextPc logic used to calculate and choose  what address to go to.
*/

module NextPClogic(NextPC,CurrentPC,SignExtImm64,Branch,ALUZero,Uncondbranch);
	
	input [63:0] CurrentPC, SignExtImm64;
	input Branch, ALUZero, Uncondbranch;
	output [63:0] NextPC;
	
	//some reg for synthesizable code 
	reg [63:0] IncPC, tempPC, signPC, NextPC;
	
	always@(*) //when anything changes
	begin
		tempPC = CurrentPC;
		
		IncPC = tempPC+4;
		
		#2 signPC = #1 tempPC + (SignExtImm64 <<2);
		
		#1 NextPC = ((Branch && ALUZero) || Uncondbranch) ? signPC:IncPC;
	end
	
endmodule