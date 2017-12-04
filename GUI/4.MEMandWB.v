module DataMemoryWithMux (Clk,MemWrite,Address,WriteData,ReadData,MemRead);
input MemWrite,Clk,MemRead;
input [31:0] Address;
input [31:0]WriteData;
output reg [31:0] ReadData;
parameter MemDepth = (2**8)-1;
reg [31:0] memory [0:MemDepth];
integer i;

initial begin for(i=0;i<(2**8);i=i+1) begin memory[i]<=0; end
		memory[0]  <= 15;
		memory[1]  <= 8;
		memory[2]  <= 0;
		memory[3]  <= 0;
		memory[4]  <= 0;
		memory[5]  <= 5;
		memory[6]  <= 0;
		memory[7]  <= 0;
		memory[8]  <= 0;
		memory[9]  <= 0;
		memory[10] <= 10;
		memory[11] <= 0;
		memory[12] <= 0;
		memory[13] <= 0;
		memory[14] <= 76;
		memory[15] <= 12;
		memory[16] <= 0;
		memory[17] <= 35;
		memory[18] <= 44;
		memory[19] <= 0;
		memory[20] <= 20;
		memory[21] <= 0;
		memory[22] <= 0;
		memory[23] <= 1;
		memory[24] <= 0;
		memory[25] <= 0;
		memory[26] <= 26;
		memory[27] <= 0;
		memory[35] <= 77;
		memory[29] <= 0;
		memory[44] <= 0;
		memory[45] <= 47;
		memory[46] <= 50;
		memory[246] <= 250;
end


always @(negedge Clk) begin
  if (MemWrite == 1) begin
    memory[Address] <= WriteData;
  end
  // Use memread to indicate a valid address is on the line and read the memory into a register at that address when memread is asserted
  if (MemRead == 1) begin
    ReadData <= memory[Address];
  end
end

endmodule



module MEMandWB( AlUResult, ReadData2, MemtoReg ,MemRead,MemWrite,Clk,MemtoMux);
input wire  MemWrite,Clk,MemRead,MemtoReg;
input wire [31:0] AlUResult;
input wire [31:0] ReadData2;

output wire [31:0] MemtoMux;

DataMemoryWithMux x(Clk,MemWrite,AlUResult,ReadData2,MemtoMux,MemRead);

endmodule




