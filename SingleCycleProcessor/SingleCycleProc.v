module singlecycle(
    input resetl,
    input [63:0] startpc,
    output reg [63:0] currentpc,
    output [63:0] dmemout,
    input CLK
);

    // Next PC connections
    wire [63:0] nextpc;       // The next PC, to be updated on clock cycle

    // Instruction Memory connections
    wire [31:0] instruction;  // The current instruction

    // Parts of instruction
    wire [4:0] rd;            // The destination register
    wire [4:0] rm;            // Operand 1
    wire [4:0] rn;            // Operand 2
    wire [10:0] opcode;

    // Control wires
    wire reg2loc;
    wire alusrc;
    wire mem2reg;
    wire regwrite;
    wire memread;
    wire memwrite;
    wire branch;
    wire uncond_branch;
    wire [3:0] aluctrl;
    wire [2:0] signop; //changed to 3 bits

    // Register file connections
    wire [63:0] regoutA;     // Output A
    wire [63:0] regoutB;     // Output B
	wire [63:0] busw; // this is the bus w, meaning the data to write, this was added by me

    // ALU connections
    wire [63:0] aluout;
    wire zero;
	
/*********Added********************/
	//Mux output before the ALU
	wire[63:0] alumuxout;
/**********************************/

    // Sign Extender output
    wire [63:0] extimm;
	
/**********************ADDED***********************/
	// PC update logic
	//nextPC
	NextPClogic next(nextpc,currentpc,extimm,branch,zero,uncond_branch);
    always @(negedge CLK)
    begin
        if (resetl)
            currentpc <= nextpc;
        else
            currentpc <= startpc;
    end

    // Parts of instruction
    assign rd = instruction[4:0];
    assign rm = instruction[9:5];
    assign rn = reg2loc ? instruction[4:0] : instruction[20:16];//MUX for the register file
    assign opcode = instruction[31:21];

    InstructionMemory imem(
        .Data(instruction),
        .Address(currentpc)
    );

    control control(
        .reg2loc(reg2loc),
        .alusrc(alusrc),
        .mem2reg(mem2reg),
        .regwrite(regwrite),
        .memread(memread),
        .memwrite(memwrite),
        .branch(branch),
        .uncond_branch(uncond_branch),
        .aluop(aluctrl),
        .signop(signop),
        .opcode(opcode)
    );

 /*
    * Connect the remaining datapath elements below.
    * Do not forget any additional multiplexers that may be required.
    */
/***************NOTE: I used behavioral verilog to simulate the mux that are needed.**********************/
	//register File
	RegisterFile registers(regoutA,regoutB,busw,rm,rn,rd,regwrite,CLK);
	
	//sign externder
	SignExtender signextender(extimm,instruction[25:0],signop);

	//MUX for ALU, desribided with behaviorial verilog
	assign #2 alumuxout = alusrc ? extimm:regoutB;
	
	//alu
	ALU alu(aluout,regoutA,alumuxout,aluctrl,zero);
	
	//dataMemory
	DataMemory data(dmemout, aluout, regoutB, memread, memwrite, CLK);
	
	//Mux after the data memory to decide what busW will be
	assign #2 busw = mem2reg ? dmemout: aluout;
	
endmodule

