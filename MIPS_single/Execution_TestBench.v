//ALU testbench
module tb_ALU();
	reg [31:0] A,B;
	reg [3:0] op;
	reg [4:0] shamt;
	wire [31:0] Result;
	wire overFlow;
	wire zero;
	reg ALUSrc;
	reg [31:0]ImmediateField;
	

	initial begin
		ALUSrc<=0;
		A<= -15;
		B<= -22;
		shamt <= 1;

		#50
		op = 0;
		$monitor("%d ADD %d is %d OVERFLOW = %1d", $signed(A), $signed(B), $signed(Result), overFlow);

		#50
		op = 1;
		$monitor("%d SUB %d is %d OVERFLOW = %1d", $signed(A), $signed(B), $signed(Result), overFlow);

		#50
		op = 2;
		$monitor("%b AND %b is %b", A, B, Result);

		#50
		op = 3;
		$monitor("%b OR  %b is %b", A, B, Result);

		#50
		op = 4;
		$monitor("SLL	%b by %d bits is %b", A, shamt, Result);

		#50
		op = 5;
		$monitor("SRL	%b by %d bits is %b", A, shamt, Result);

		#50
		op = 6;
		$monitor("SRA	%b by %d bits is %b", A, shamt, Result);

		#50
		op = 7;
		$monitor("%d IS Greater %d : %1d", $signed(A), $signed(B), Result);

		#50
		op = 8;
		$monitor("%d IS less    %d : %1d", $signed(A), $signed(B), Result);

	end
Execution Ex1(A,B,op,shamt,ALUSrc,ImmediateField,Result,zero,overFlow);

endmodule

