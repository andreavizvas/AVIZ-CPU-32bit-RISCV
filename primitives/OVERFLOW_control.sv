// Name: OVERFLOW_control
// Date: August 10th, 2026
// Description: N-width OVERFLOW control module, for 32-bit CPU and other projects 

// DESIGNER: ANDRE AVIZ VASCONCELOS, Thu August 13 2026, 16:32:21, Shoal Bay East, Anguilla


module OVERFLOW_control #(
    parameter WIDTH = 32
)(
    input  logic [WIDTH-1:0] OP1,
    input  logic [WIDTH-1:0] OP2_COND_INV,
    input  logic [WIDTH-1:0] RESULT,       // intakes arithmetic result, checking it for overflow

    output logic [WIDTH-1:0] OVERFLOW
);
    // ~^ <= XNOR;
    assign OVERFLOW = (OP1[WIDTH-1] ~^ OP2_COND_INV[WIDTH-1]) 
                    & (OP1[WIDTH-1] ^ RESULT[WIDTH-1]);
endmodule