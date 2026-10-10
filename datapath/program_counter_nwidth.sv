// Name: program_counter_nwidth
// Date: August 10th, 2026
// Description: N-width Program Counter (RISC-V), for 32-bit CPU and other projects. 
// Loads next program 'NEXT_PC' on a rising clock edge when 'ENABLE' is true

// DESIGNER: ANDRE AVIZ VASCONCELOS, Fri August 21 2026, 00:32:03, Gainesville FL, United States

module program_counter #(
    parameter WIDTH = 32
)(
	input logic				 CLK,			// Clock cycle. Program counter updates on rising clock edges
	input logic				 RESET,		// Synchronously reset the program counter
	input logic				 ENABLE,		// Enables loading 'NEXT_PC'
	input logic	 [WIDTH-1:0] NEXT_PC,		// Next instruction address
	
	output logic [WIDTH-1:0] CURRENT_PC	//	Current instruction address
);

parameter logic [WIDTH-1:0] RESET_PC = '0;

always_ff @(posedge	CLK) begin
		if (RESET)
			CURRENT_PC <= RESET_PC;
		else if (ENABLE)
			CURRENT_PC <= NEXT_PC;
		end
// when neither reset nor enable are asserted, the flip-flops retain the current PC
endmodule