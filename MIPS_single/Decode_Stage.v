module mux5bit(input wire[4:0] input_1,input wire[4:0] input_2,input wire selector,output reg[4:0] write_data);
always @(selector)
begin
case(selector)
0: write_data<=input_1;
1: write_data<=input_2;
endcase
end
endmodule

module RegisterFile(Clk, WriteEnb, ReadReg1, ReadReg2, WriteReg, ReadData1, ReadData2, WriteData);

// ??? ??? ??? ???????? ???? ???
	input [4:0] ReadReg1,ReadReg2,WriteReg;
	input [31:0] WriteData;
	input wire WriteEnb ;		//Note write enable may be 2bits to support various operations later
	input wire Clk;
	output reg [31:0] ReadData1,ReadData2;
	reg [31:0] Registers [0:31];
initial begin
		//$monitor("Reg0=%d Reg1=%d",Registers[0],Registers[1]);
		Registers[0]  <= 15;
		Registers[1]  <= 8;
		Registers[2]  <= 32'h00000000;
		Registers[3]  <= 32'h00000000;
		Registers[4]  <= 32'h00000000;
		Registers[5]  <= 32'h00000000;
		Registers[6]  <= 32'h00000000;
		Registers[7]  <= 32'h00000000;
		Registers[8]  <= 32'h00000000;
		Registers[9]  <= 32'h00000000;
		Registers[10] <= 32'h00000000;
		Registers[11] <= 32'h00000000;
		Registers[12] <= 32'h00000000;
		Registers[13] <= 32'h00000000;
		Registers[14] <= 32'h00000000;
		Registers[15] <= 32'h00000000;
		Registers[16] <= 32'h00000000;
		Registers[17] <= 32'h00000000;
		Registers[18] <= 32'h00000000;
		Registers[19] <= 32'h00000000;
		Registers[20] <= 32'h00000000;
		Registers[21] <= 32'h00000000;
		Registers[22] <= 32'h00000000;
		Registers[23] <= 32'h00000000;
		Registers[24] <= 32'h00000000;
		Registers[25] <= 32'h00000000;
		Registers[26] <= 32'h00000000;
		Registers[27] <= 32'h00000000;
		Registers[28] <= 32'h00000000;
		Registers[29] <= 32'h00000000;
		Registers[30] <= 32'h00000000;
		Registers[31] <= 32'h00000000;
end

	always@(posedge Clk)
		begin
		if(WriteEnb && WriteReg!=0) //we dont need to write in $zero reg ,NOTE:dont forget to initialize it in testbench
		Registers[WriteReg]<=WriteData;
		end

	always@(negedge Clk)
		begin
			ReadData1 <= Registers[ReadReg1];
			ReadData2 <= Registers[ReadReg2];
		end

endmodule

 module ControlUnit(Fn,Opcode,ControlLines); 
input wire [5:0] Fn;
input wire [5:0] Opcode;
output reg [11:0]ControlLines;
//wire RegDst    =ControlLines[0];
//wire Jump      =ControlLines[1];
//wire Branch    =ControlLines[2];
//wire MemRead   =ControlLines[3];
//wire MemtoReg  =ControlLines[4];
//wire [3:0]ALUOp={ControlLines[8],ControlLines[7],ControlLines[6],ControlLines[5]};
//wire MemWrite  =ControlLines[9];
//wire ALUSrc    =ControlLines[10];
//wire RegWrite  =ControlLines[11];  ////Note write enable may be 2bits to support various operations later
	
always@(Opcode)
	begin
		case(Opcode)	//R-FORMAT
						0: 
						if(Fn==32) begin ControlLines<=12'b100_0010_00001; end//ADD
						else if(Fn==36) begin ControlLines<=12'b100_0000_00001; end//AND
						else if(Fn==34) begin ControlLines<=12'b100_0001_00001;	end//SUB
						else if(Fn==37) begin ControlLines<=12'b100_0011_00001;	end//OR
						else if(Fn==0)  begin ControlLines<=12'b100_0100_00001;	end//SLL
						else if(Fn==42) begin ControlLines<=12'b100_1000_00001;	end//SLT
						else if(Fn==2)  begin ControlLines<=12'b100_0101_00001;	end//SRL
						else if(Fn==3)  begin ControlLines<=12'b100_0110_00001;	end//SRA
						else if(Fn==55) begin  end// take in consedration SGT instruct. 
					
			4:  ControlLines<=12'b000_0001_00100; //BEQ
			5:  ControlLines<=12'b000_0001_00000; //BNE      ------NEED to be implemented
			35: ControlLines<=12'b110_0010_11000; //LW
			43: ControlLines<=12'b011_0010_00000; //SW
		endcase
end
endmodule

module Decode(Clk,Instruction,ControlLines,MemtoReg_Data,ReadData1,ReadData2,shamt,ImmediateField);
input wire Clk;
input wire [31:0]Instruction;
input wire [31:0]MemtoReg_Data;
output wire [11:0]ControlLines;
output wire [31:0]ReadData1;
output wire [31:0]ReadData2;
output wire [4:0]shamt;
output wire [15:0]ImmediateField;
wire [4:0]WriteReg;

ControlUnit CU(Instruction[5:0],Instruction[31:26],ControlLines);
mux5bit RegDst(Instruction[20:16],Instruction[15:11],ControlLines[0],WriteReg);
RegisterFile RegFile(Clk,ControlLines[11],Instruction[25:21],Instruction[20:16],WriteReg,ReadData1,ReadData2,MemtoReg_Data);
assign shamt=Instruction[10:6];
assign ImmediateField=Instruction[15:0];
endmodule


