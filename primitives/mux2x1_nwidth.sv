// Name: mux2x1_nwidth
// Date: August 10th, 2026
// Description: 2-to-1 n-width multiplexer, for 32-bit CPU and other projects 

// DESIGNER: ANDRE AVIZ VASCONCELOS, Mon Aug 10 2026, 22:47:37, Shoal Bay East, Anguilla

module mux2x1_nwidth #(
    parameter WIDTH = 32
)(
    input  logic [WIDTH-1:0] IN0,
    input  logic [WIDTH-1:0] IN1,
    input  logic			 SEL,
    
    output logic [WIDTH-1:0] OUT
);
always_comb begin
    case (SEL)
        1'b0:	 OUT = IN0;
        1'b1:	 OUT = IN1
;
		default: OUT = '0;
    endcase
end
endmodule