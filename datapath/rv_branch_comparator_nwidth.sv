// Name: rv_branch_comparator_nwidth
// Date: October 13th, 2026
// Description: N-width branch comparator for 6 RV32I branch conditions:
// BEQ, BNE, BLT, BGE, BLTU, BGEU
// For 32-bit CPU and other projects

// DESIGNER: ANDRE AVIZ VASCONCELOS, Tue October 13 2026, 21:37:41, 
// Gainesville FL, United States

module rv_branch_comparator_nwidth # (
    parameter XLEN = 32
)(
    input  logic [XLEN-1:0] A,
    input  logic [XLEN-1:0] B,
    input  logic [2:0]    BRANCH_SEL,
    
    output logic          BRANCH
);
    localparam logic [2:0]
        BEQ  = 3'b000,      // branch if equal
        BNE  = 3'b001,      // branch if not equal
        BLT  = 3'b100,      // branch if less than
        BGE  = 3'b101,      // branch if greater than or equal
        BLTU = 3'b110,      // branch if less than (unsigned)
        BGEU = 3'b111;      // branch if greater than or equal (unsigned)

    always_comb begin
        case (BRANCH_SEL)
            BEQ: begin
                BRANCH = (A == B);
            end

            BNE: begin
                BRANCH = (A != B);
            end

            BLT: begin
                BRANCH = ($sugned(A) < $signed(B));
            end

            BGE: begin
                BRANCH = ($signed(A) >= $signed(B));
            end

            BLTU: begin
                BRANCH = (A < B);
            end

            BGEU: begin
                BRANCH = (A >= B);
            end

            default: begin
                BRANCH = 1'b0;
            end
        endcase
    end

endmodule