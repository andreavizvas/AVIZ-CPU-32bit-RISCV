// Name: XOR_control_nwidth
// Date: August 10th, 2026
// Description: N-width XOR control module, for 32-bit CPU and other projects 

// DESIGNER: ANDRE AVIZ VASCONCELOS, Thu August 13 2026, 16:32:21, Shoal Bay East, Anguilla


// n-width conditional XOR control module, supporting adder/subtraction with same hardware,
// by taking 1's complement of OP2 when selected for, and using CIN (SUB) to make it 2's complement

module XOR_control_nwidth #(
    parameter WIDTH = 32
)(
	input  logic [WIDTH-1:0] OP2,		  // subtrahend
	input  logic             SUB,		  // if SUB == 1, subtracting; else adding

	output logic [WIDTH-1:0] OP2_COND_INV // modified OP2 input for adder, (~OP2); 1's complement of OP2, 
                                          // needs LSB + 1 to get 2's complement for (-) 
);

	assign OP2_COND_INV = OP2 ^ {WIDTH{SUB}}; // replication operator, WIDTH copies of SUB, then XOR with OP2.
									          // XOR module handles inversion or non-inversion without requiring a separate MUX
endmodule