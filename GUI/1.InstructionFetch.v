


module PC(Clk,InputAddress,PCSrc,OutputAddress,stallMuxSelector);
input wire Clk;
input wire [31:0]InputAddress;
input wire PCSrc;
output reg [31:0]OutputAddress;
input wire stallMuxSelector;

initial begin OutputAddress<=0; end  
         
always@(posedge Clk)
begin
if(PCSrc==1) begin OutputAddress<=(InputAddress+4); end
else if(stallMuxSelector==0) begin OutputAddress <= (OutputAddress); end
//if(stallMuxSelector!=0) begin OutputAddress <= OutputAddress + 4; end
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
reg [7:0]count;
//genvar i;
//initial begin #5 $readmemh("test.txt", InstrucionMem); end
//for(i=0;i<(2**8);i=i+1) begin  read(Clk,WriteData,InstrucionMem[i]); end

initial begin 	

	

		$readmemh("inst.txt", InstrucionMem);
		//for(i=0;i<(2**8);i=i+1) begin InstrucionMem[i]<=0; end 
		
		
		  /*InstrucionMem[0]  <= 32'b10001110011100010000000000010100; //lw $s1, 20($s3)
		  InstrucionMem[1]  <= 32'b10001110001010000000000000000000; //lw $t0, 0($s1) 
		  InstrucionMem[2]  <= 32'b10001101000100100000000000000000; //lw $s2, 0($t0)*/ 
		
                  /*InstrucionMem[0] <= 32'b100011_10000_010010000000000000000;   //lw $t1, 0($s0)
                  InstrucionMem[1] <= 32'b000000_01001_10011_01010_00000100000;  //add $t2,$t1,$s3
                  InstrucionMem[2] <= 32'b00010001001010100000000000000001;   //beq $t1,$t2,label
                  InstrucionMem[3] <= 32'b00000010011100111000100000100000;   //add $s1,$s3,$s3
                  InstrucionMem[4] <= 32'b00000010010100111000100000100000;   //label: add $s1,$s2,$s3*/
           
                  /*InstrucionMem[0] <= 32'b100011_10000_01001_0000000000000000;   //lw $t1, 0($s0)
                  InstrucionMem[1] <= 32'b100011_10000_01010_0000000000000000;   //lw $t2, 0($s0)
                  InstrucionMem[2] <= 32'b000100_01001_01010_0000000000001010;   //beq $t1,$t2,label
                  InstrucionMem[3] <= 32'b000000_10011_10011_10010_00000100000;   //add $s2,$s3,$s3
                  InstrucionMem[13] <= 32'b000000_01001_01010_10001_00000100000;   //label: add $s1,$t1,$t2*/
                 

                  /*InstrucionMem[0] <= 32'b100011_10000_01001_0000000000000000;   //lw $t1, 0($s0)
                  InstrucionMem[1] <= 32'b101011_01010_01001_0000000000000000;   //sw $t1, 0($t2)
                  InstrucionMem[2] <= 32'b100011_01010_01100_0000000000000000;   //lw $t4, 0($t2)
                  InstrucionMem[3] <= 32'b000100_01001_01100_0000000000000001;   //beq $t1,$t4,label
                  InstrucionMem[4] <= 32'b00000010011100111000100000100000;   //add $s1,$s3,$s3
                  InstrucionMem[5] <= 32'b00000010010100111000100000100000;   //label: add $s1,$s2,$s3*/



		 /* InstrucionMem[0] <= 32'b00000010010100111000100000100000;   //add $s1,$s2,$s3
                  InstrucionMem[1] <= 32'b00000010100101011001100000100000;   //add $s3,$s4,$s5
                  InstrucionMem[2] <= 32'b00000001001010100100000000100000;   //add $t0,$t1,$t2
                  InstrucionMem[3] <= 32'b00010010001100100000000000001010;   //beq $s1,$s2,Loop
                  InstrucionMem[4] <= 32'b00000000000000000000000000000000;   //nop
                  InstrucionMem[5] <= 32'b00000000000000000000000000000000;   //nop
		  InstrucionMem[14]<= 32'b00000001000010100100000000100000;  //Loop: add $t0,$t0,$t2*/



		/* InstrucionMem[0] <= 32'b00000010100101011001000000100000;   //add $s2,$s4,$s5
                  InstrucionMem[1] <= 32'b00000010010101101000100000100000;   //add $s1,$s2,$6
                  InstrucionMem[2] <= 32'b00000001001010100100000000100000;   //add add $t0,$t1,$t2
                 InstrucionMem[3] <= 32'b00010010001100100000000000001010;   //beq $s1,$s2,Loop
                  //InstrucionMem[4] <= 32'b00000000000000000000000000000000;   //nop
                  //InstrucionMem[5] <= 32'b00000000000000000000000000000000;   //nop
		  InstrucionMem[14]<= 32'b00000001000010100100000000100000;  //Loop: add $t0,$t0,$t2*/



		/*InstrucionMem[0] <= 32'b00000010100101011001000000100000;   //add $s2,$s4,$s5
		 InstrucionMem[1] <= 32'b00000001001010100100000000100000;   //add $t0,$t1,$t2
                  InstrucionMem[2] <= 32'b00000010010101101000100000100000;   //add $s1,$s2,$6
                 


                  InstrucionMem[3] <= 32'b000100_10001_01000_0000000000001010;   //beq $s1,$t0,Loop
                  InstrucionMem[4] <= 32'b00000000000000000000000000000000;   //nop
                  InstrucionMem[5] <= 32'b00000000000000000000000000000000;   //nop
		  InstrucionMem[14]<= 32'b00000001000010100100000000100000;  //Loop: add $t0,$t0,$t2*/



		  /*InstrucionMem[0] <= 32'b10001110011100010000000000010100;   //lw $s1, 20($s3)
               InstrucionMem[1] <= 32'b10001110001010000000000000000000;   //lw $t0,0($s1)
                  InstrucionMem[2] <= 32'b10001101000100100000000000000000;   //lw $s2,0($t0)
                  InstrucionMem[3] <= 32'b00000010010100011000000000100000;   //add $s0,$s2,$s1
                  //InstrucionMem[4] <= 32'b00000000000000000000000000000000;   //nop*/



		/*  InstrucionMem[0] <= 32'b00000010001100101000000000100000;   //add $s0,$s1,$s2
                  InstrucionMem[1] <= 32'b00000010000100000100000000100000;   //add $t0,$s0,$s0
                  InstrucionMem[2] <= 32'b00000001000100000100100000100000;   //add $t1,$t0,$s0
		  InstrucionMem[3] <= 32'b10001110000010100000000000000000;   //lw $t2,0($s0)*/



		 /* InstrucionMem[0] <= 32'b00000010100101011001000000100000;   //add $s2,$s4,$s5
                  InstrucionMem[1] <= 32'b00000010010101101000100000100000;   //add $s1,$s2,$6
                  //InstrucionMem[2] <= 32'b00000010010101101001100000100000;   //add $s3,$s2,$s6
                 // InstrucionMem[2] <= 32'b000100_10001_10010_0000_0000_0000_1010;   //beq $s1,$s2,Loop
                  //InstrucionMem[4] <= 32'b00000000000000000000000000000000;   //nop
                  //InstrucionMem[5] <= 32'b00000000000000000000000000000000;   //nop
		//  InstrucionMem[13]<= 32'b00000001000010100100000000100000;  //Loop: add $t0,$t0,$t2*/





		/* InstrucionMem[1] <= 32'b00000010001100101000000000100000;   //add $s0,$s1,$s2
		 InstrucionMem[2] <= 32'b10001110001010010000000000000000;   //lw $t1,0($s1)
                InstrucionMem[3] <= 32'b00010001001010100000000000001011;   //beq $t1,$t2, Label
                 //InstrucionMem[5] <= 32'b00000000000000000000000000000000;   //nop
                //  InstrucionMem[4] <= 32'b00000000000000000000000000000000;   //nop
                  //InstrucionMem[5] <= 32'b00000000000000000000000000000000;   //nop
		  InstrucionMem[15]<= 32'b00000010000100101000000000100000;  //Label: add $s0,$s0,$s2*/


 		 /*InstrucionMem[0] <= 32'b00000010100101011001000000100000;   //add $s2,$s4,$s5
                  InstrucionMem[1] <= 32'b000000_10010_10110_1000100000100000;   //add $s1,$s2,$6
                  InstrucionMem[2] <= 32'b000000_10010_10110_10011_00000100000;   //add $s3,$s2,$s6
                  InstrucionMem[3] <= 32'b000100_10001_10011_0000000000001010;   //beq $s1,$s3,Loop
                  InstrucionMem[4] <= 32'b00000000000000000000000000000000;   //nop
                  InstrucionMem[5] <= 32'b00000000000000000000000000000000;   //nop
		  InstrucionMem[14]<= 32'b00000001000010100100000000100000;  //Loop: add $t0,$t0,$t2*/

		  
             	/* InstrucionMem[0]<= 32'b00100010001100000000000000001010;  //addi $s0,$s1,10
		 InstrucionMem[1]<= 32'b00100010000100100000000000010100;  //addi $s2,$s0,20*/


		  /*InstrucionMem[0] <= 32'b10001110001010010000000000000000;   //lw $t1,0($s1)
		  InstrucionMem[1] <= 32'b00000010001100100101000000100000;   //add $t2,$s1,$s2
                  InstrucionMem[2] <= 32'b00010001001010100000000000001011;   //beq $t1,$t2, Label
                  InstrucionMem[3] <= 32'b000000_10010_10110_10011_00000100000;   //add $s3,$s2,$s6
                //  InstrucionMem[4] <= 32'b00000000000000000000000000000000;   //nop
                  //InstrucionMem[5] <= 32'b00000000000000000000000000000000;   //nop
		  InstrucionMem[14]<= 32'b00000010000100101000000000100000;  //Label: add $s0,$s0,$s2*/


		 /*InstrucionMem[1]<= 32'b000011_00000000000000000000010011;  //jal L
		 InstrucionMem[20]<=32'b000000_10001_10010_10000_00000100000;  //add $s0,$s1,$s2 de 3awza 200ns leh?*/

		/*InstrucionMem[1]<= 32'b00000001011011000110100000100000;  //add $t5,$t3,$t4
		 InstrucionMem[2]<=32'b00000001101000000000000000001000;  //jr $t5
		 InstrucionMem[3]<=32'b00000010001100100101000000100000;   //add $t2,$s1,$s2
		InstrucionMem[20]<=32'b00000010001100101000000000100000;  //add $s0,$s1,$s2  // de 3awza 180ns*/


		/*InstrucionMem[1]<= 32'b10001111000011010000000000000000;  //lw $t5,0($t8)
		 InstrucionMem[2]<=32'b00000001101000000000000000001000;  //jr $t5
		 InstrucionMem[3]<=32'b00000010001100100101000000100000;   //add $t2,$s1,$s2
		InstrucionMem[20]<=32'b00000010001100101000000000100000;  //add $s0,$s1,$s2  // de 3awza 200ns*/


		//InstrucionMem[1]<= 32'b00111100000100000000000000110010; //lui $s0,50

		//InstrucionMem[1]<= 32'b00000010011100101000100000_101010; //sgt $s1,$s2,$s3 NOT Suported

		//InstrucionMem[1]<= 32'b00000000000010100100101010000000;

		//InstrucionMem[1]<= 32'b00100001000010000000000000000001;//addi $t0,$t0,1 overflow detection


		 /* InstrucionMem[0] <= 32'b00000010001100101001100000100000;   //add $s3,$s1,$s2
		  InstrucionMem[1] <= 32'b00000010001100111000100000100000;   //add $s1,$s1,$s3
                  InstrucionMem[2] <= 32'b00010110001100000000000000001011;   //bne $s1,$s0,Label
                  InstrucionMem[3] <= 32'b000000_10010_10110_10011_00000100000;   //add $s3,$s2,$s6
                //  InstrucionMem[4] <= 32'b00000000000000000000000000000000;   //nop
                  //InstrucionMem[5] <= 32'b00000000000000000000000000000000;   //nop
		  InstrucionMem[14]<= 32'b10001110010010000000000000000000;  //Label:lw $t0,0($s2)*/


end


initial begin ReadData<=0; end
always @(negedge Clk) begin ReadData <= InstrucionMem[PCaddress>>2];end //Read from InstMem @ negedge

endmodule

module FetchStage(Clk,WriteData,ReadData,WriteEnable,InputAddress,OutputAddress,PCSrc,stallMuxSelector);
input wire Clk;
input wire [31:0]WriteData;
input wire WriteEnable;
output wire [31:0]ReadData;
input wire [31:0]InputAddress;
input wire PCSrc;
output wire [31:0]OutputAddress;
input wire stallMuxSelector;
PC PC1(Clk,InputAddress,PCSrc,OutputAddress,stallMuxSelector);
InstMem MyInst(Clk,OutputAddress,WriteData/*From file!*/,ReadData,WriteEnable);
endmodule


