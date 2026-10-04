// Name: adder_nwidth
// Date: August 11th, 2026
// Description: N-width full adder, for 32-bit CPU and other projects 

// DESIGNER: ANDRE AVIZ VASCONCELOS, Tue Aug 11 2026, 13:54:17, Shoal Bay East, Anguilla

module adder_nwidth #(
    parameter WIDTH = 8
)(
    input  logic [WIDTH-1:0] OP1,
    input  logic [WIDTH-1:0] OP2,
    input  logic             CIN,
    
    output logic [WIDTH-1:0] RESULT,
    output logic             COUT
);
    assign {COUT, RESULT} = OP1 + OP2 + CIN;
endmodule