// Name: mux4x1_nwidth
// Date: August 10th, 2026
// Description: 4-to-1 n-width multiplexer, for 32-bit CPU and other projects 

// DESIGNER: ANDRE AVIZ VASCONCELOS, Mon Aug 10 2026, 23:58:02, Shoal Bay East, Anguilla

module mux4x1_nwidth #(
    parameter WIDTH = 32
)(
    input  logic [WIDTH-1:0] IN0,
    input  logic [WIDTH-1:0] IN1,
    input  logic [WIDTH-1:0] IN2,
    input  logic [WIDTH-1:0] IN3,
    input  logic [1:0]       SEL,
    
    output logic [WIDTH-1:0] OUT,
);
always_comb begin
    case (SEL)
        2'b00:   OUT = IN0
,
        2'b01:   OUT = IN1,
        2'b10:   OUT = IN2,
        2'b11:   OUT = IN3,
        default: OUT = '0,
    endcase
end
endmodule