module PC(Clk,InputAddress,PCSrc,OutputAddress);
input wire Clk;
input wire [31:0]InputAddress;
input wire PCSrc;
output reg [31:0]OutputAddress;

//initial begin InputAddress<=0; end              take care
initial begin OutputAddress<=0; end           
always@(posedge Clk)
begin
if(PCSrc==1) begin OutputAddress<=(InputAddress+4); end
else begin OutputAddress <= OutputAddress + 4; end
end

endmodule 

module InstMem(Clk,PCaddress,WriteData/*From file!*/,ReadData,WriteEnable);

input wire Clk;
input wire[31:0]PCaddress ;
input wire[31:0]WriteData/*From file!*/;
output reg [31:0] ReadData;
parameter MemDepth = (2**8)-1;
reg [31:0] InstrucionMem [0:MemDepth];
input wire  WriteEnable;
integer i;
initial begin 	for(i=0;i<(2**8);i=i+1) begin InstrucionMem[i]<=0; end 
		InstrucionMem[0]  <= 32'b000000_10001_10010_01000_00000_100000;//add $t0, $s0, $s1 ->t0=35
		InstrucionMem[1]  <= 32'b000000_01010_01011_01101_00000100010;//sub $t4,$t2,$t3
		
		//InstrucionMem[2]  <= 32'b000000_10001_10010_01001_00000_100000;//lw $t0, 28($s0) ->t0=47
		//InstrucionMem[1]  <= 32'b000000_01000_01000_01000_00000_100000;//add $t0,$t0,$t0 ->t0=94
		//InstrucionMem[3]  <= 32'b101011_01000_01000_0000000000000000; //sw $t0,0($t0) ->t0=94
		//InstrucionMem[4]  <= 32'b000000_10001_10001_10001_00000_100000; //add $s0,s0,s0 34
		InstrucionMem[5]  <= 32'b100011_01000_10001_0000000000000000; //lw $s0,0($t0) ->s0=94
		//InstrucionMem[6]  <= 32'b000100_10001_10001_00000000_00000010;//beq $s0, $t0, C
		//InstrucionMem[5]  <= 32'b000100_010000_01000_0000000000000010;
		//InstrucionMem[9]  <= 32'b000000_10001_10001_10001_00000_100000;//add s0,s0,s0
		//InstrucionMem[0]  <= 32'b101011_10010_01000_0000000000000000;//sw $t0,0($s1) 
		//InstrucionMem[1]  <= 32'b100011_00000_01000_0000000000010010;//lw $s0, 17(0)
		//
		//InstrucionMem[3]  <= 32'b101011_01000_01000_0000000000000000; //sw $t0,0($t0)
		
end


//always @(posedge Clk) begin if(WriteEnable) begin InstrucionMem[PCaddress>>2] <= WriteData;end end

always @(posedge Clk) begin ReadData <= InstrucionMem[PCaddress>>2];end //Read from InstMem @ negedge

endmodule

module FetchStage(Clk,WriteData,ReadData,WriteEnable,InputAddress,OutputAddress,PCSrc);
input wire Clk;
input wire [31:0]WriteData;
input wire WriteEnable;
output wire [31:0]ReadData;
input wire [31:0]InputAddress;
input wire PCSrc;
output wire [31:0]OutputAddress;
PC PC1(Clk,InputAddress,PCSrc,OutputAddress);
InstMem MyInst(Clk,OutputAddress,WriteData/*From file!*/,ReadData,WriteEnable);
endmodule

