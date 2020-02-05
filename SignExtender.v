`timescale 1ns / 1ps
`define I 3'b000
`define D 3'b001
`define B 3'b010
`define CB 3'b011
`define IW 3'b100
`define Q0 2'b00
`define Q1 2'b01
`define Q2 2'b10
`define Q3 2'b11

module SignExtender(BusImm, Ins26, Ctrl);
	output reg[63:0] BusImm; //output
	input [25:0] Ins26;//input is 26 bit of the instruction
	input [2:0]Ctrl; //Control is 3 bit wide to account for 5 types  of instructions
	
	reg extBit; //the extension bit

	always@(*)
	begin
	case(Ctrl) //switch case for the control signal
		`I: begin //for I type Instruction
				extBit = Ins26[21];
				BusImm = {{52{extBit}},Ins26[21:10]};
			end
		`D: begin //for D type Instruction
				extBit = Ins26[20];
				BusImm = {{55{extBit}},Ins26[20:12]};
			end
		`B: begin //for B type Instruction
				extBit = Ins26[25];
				BusImm = {{38{extBit}},Ins26[25:0]};
			end
		`CB:begin //for CB type Instruction
				extBit = Ins26[23];
				BusImm = {{45{extBit}},Ins26[23:5]};
			end
		`IW:begin //for the MOVZ instruction
			case(Ins26[22:21]) //for the different cases
				`Q0:begin
						extBit = 0;
						BusImm ={{48{extBit}},Ins26[20:5]};
					end
				`Q1:begin
						extBit = 0;
						BusImm ={{32{extBit}},Ins26[20:5],{16{extBit}}};
					end
				`Q2:begin
						extBit =0;
						BusImm ={{16{extBit}},Ins26[20:5],{32{extBit}}};
					end
				`Q3:begin
						extBit = 0;
						BusImm ={Ins26[20:5],{48{extBit}}};
					end
				endcase
		    end
	endcase
	end
	

endmodule
