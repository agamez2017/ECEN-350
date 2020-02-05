`timescale 1ns / 1ps
`define AND   4'b0000
`define OR    4'b0001
`define ADD   4'b0010
`define SUB   4'b0110
`define PassB 4'b0111


module ALU(BusW, BusA, BusB, ALUCtrl, Zero);
    
    parameter n = 64; //set the bit width

    output  [n-1:0] BusW; //output is 64 bits wide
    input   [n-1:0] BusA, BusB; // input is also 64 bits wide
    input   [3:0] ALUCtrl; //Control is 4 bits wide, so we can define different instructions
    output  Zero; //1 bit output, whether the result of ALU is 0 or not
    
    reg     [n-1:0] BusW; //drive the output
    
    always @(ALUCtrl or BusA or BusB) begin //if control, or inputs change
        case(ALUCtrl) //switch case for the control to handle different instruction types
            `AND: begin
                BusW <= #20 BusA & BusB; //wait 20 time units and the output is the result of AND-ing the two inputs
				  end
			`OR: begin
				BusW <= #20 BusA | BusB; //wait for 2o time units and the output is the result of OR-ing the two inputs
				 end
			`ADD: begin
				BusW <= #20 $signed(BusA) + $signed(BusB); //wait 20 time units and the output is the result of adding the two inputs
				  end
			`SUB: begin	
				BusW <= #20 $signed(BusA) - $signed(BusB);//wait 20 time units and the output is the result of subtracting the two inputs
				  end
			`PassB: begin
				BusW <= #20 BusB; //wait 20 time units and the output should be equal to the input B
					end
        endcase
    end

    assign #1 Zero = (BusW==64'b0) ? 1:0; // check to see if the output is equal to zero, if it is assign Zero to 1 otherwise assign it 0
endmodule
