// Name: alu_nwidth
// Date: August 16th, 2026
// Description: N-width RISC-V ALU, for 32-bit CPU and other projects. 

// DESIGNER: ANDRE AVIZ VASCONCELOS, Sun August 16 2026, 00:30:44, 
// Shoal Bay East, Anguilla	


module alu_nwidth #(
    parameter WIDTH = 32
)(
	input  logic [WIDTH-1:0] A,			// Operand 1
	input  logic [WIDTH-1:0] B,			// Operand 2
	input  logic [3:0]	     ALU_SEL,	// ALU operation select line
														
	output logic [WIDTH-1:0] RESULT,	// ALU operation result
	output logic		     ZERO,		// Zero flag
	output logic		     COUT,		// COUT flag
	output logic		     OVERFLOW   // Overflow flag
);

localparam logic [3:0]				    // ALU select line definitions, in binary:
		OP_ADD	= 4'b0000,			    //	Add								(0000)
		OP_SUB	= 4'b0001,			    // Subtract							(0001)
		OP_AND	= 4'b0010,			    // AND								(0010)
		OP_OR	= 4'b0011,    		    // OR								(0011)
		OP_XOR	= 4'b0100,    		    // XOR								(0100)
		OP_SLL	= 4'b0101,			    // Logical left shift				(0101) 
		OP_SRL	= 4'b0110,			    // Logical right shift				(0110)		
		OP_SRA	= 4'b0111,			    // Arithmetic right shift			(0111)
		OP_SLT	= 4'b1000,			    // Set less than signed		    	(1000)
		OP_SLTU	= 4'b1001;			    // Set less than unsigned			(1001)
        // (arithmetic LEFT shift unnecessary; logical version produces same bit pattern)

logic			  SUB_SEL;
logic [WIDTH-1:0] ARITHMETIC_RESULT;
logic			  ARITHMETIC_COUT;
logic			  ARITHMETIC_OVERFLOW;

localparam int SHAMT_WIDTH = $clog2(WIDTH); // shift amount

// SUB_SEL used to select subtraction in shared add/sub arithmetic unit
assign SUB_SEL = (ALU_SEL == OP_SUB);

add_sub_nwidth #( 
    .WIDTH    (WIDTH)
) u_arithmetic (
	.OP1	  (A),
	.OP2	  (B),
	.SUB	  (SUB_SEL),
	.RESULT	  (ARITHMETIC_RESULT),
	.COUT	  (ARITHMETIC_COUT),
	.OVERFLOW (ARITHMETIC_OVERFLOW)
);

always_comb begin
	RESULT	 = '0;
	COUT	 = 1'b0;
	OVERFLOW = 1'b0;
	
	case (ALU_SEL)
        OP_ADD:	begin
            RESULT	 = ARITHMETIC_RESULT;
            COUT	 = ARITHMETIC_COUT;
            OVERFLOW = ARITHMETIC_OVERFLOW;
        end
                
        OP_SUB:	begin
            RESULT	 = ARITHMETIC_RESULT;
            COUT	 = ARITHMETIC_COUT;
            OVERFLOW = ARITHMETIC_OVERFLOW;
        end
                
        OP_AND:	begin
            RESULT   = A & B;
        end
            
        OP_OR:	begin
            RESULT	 = A | B;
        end
            
        OP_XOR:	begin
            RESULT	 = A ^ B;
        end
        
        OP_SLL:	begin
            RESULT	= A << B[SHAMT_WIDTH-1:0];
        end
            
        OP_SRL:	begin
            RESULT	= A >> B[SHAMT_WIDTH-1:0];
        end
            
        OP_SRA:	begin
            RESULT	= $signed(A) >>> B[SHAMT_WIDTH-1:0];
        end

        OP_SLT: begin
            RESULT[0] = ($signed(A) < $signed(B));
        end
            
        OP_SLTU: begin
            RESULT[0] = (A < B);
        end
            
        default: begin	// output 0 for any undefined ALU operation code; prevent latch from undefined opcodes
            RESULT = '0;
            end
            
	endcase
end
	assign ZERO	= (RESULT == '0); // assert ZERO when RESULT equals 0; RESULT == 0, ZERO = 1 RESULT != 0, ZERO = 0
endmodule