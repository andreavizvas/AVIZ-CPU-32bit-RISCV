// Name: immgen_nwidth
// Date: August 25th 2026
// Description: Extracts and adds sign extension for RISC-V instruction formats; I, S, B, U, J. 
// IMM generator does not include R-type instructions as they dont have IMM values.
// For 32-bit CPU and other projects

// DESIGNER: ANDRE AVIZ VASCONCELOS, Tue August 25 2026, 13:03:13, 
// Gainesville FL, United States

module immgen_XLEN #(
    parameter XLEN = 32
)(
    input  logic [31:0] INSTR,
    input  logic [2:0]       IMM_SEL,
    output logic [XLEN-1:0] IMM
);

    localparam logic [2:0]
        IMM_I = 3'b000,
        IMM_S = 3'b001,
        IMM_B = 3'b010,
        IMM_U = 3'b011,
        IMM_J = 3'b100;

always_comb begin
    case (IMM_SEL)
    // immediate arithmetic (imm[11:0] = instr[31:20])
        IMM_I: begin
            IMM = {{(XLEN-12){INSTR[31]}}, INSTR[31:20]};        
        end

    // store instructions
        IMM_S: begin
            IMM = {{(XLEN-12){INSTR[31]}}, INSTR[31:25], INSTR[11:7]};
        end

    // branch instructions
        IMM_B: begin
            IMM = {{(XLEN-13){INSTR[31]}}, INSTR[31], INSTR[7], INSTR[30:25], INSTR[11:8], 1'b0};
        end
    // load upper immediate
        IMM_U: begin
            IMM = {{(XLEN-32)INSTR[31:12]}, 12'b0};
        end
    // jump unconditional
        IMM_J: begin
            IMM = {{(XLEN-21){INSTR[31]}}, INSTR[31], INSTR[19:12], INSTR[20], INSTR[30:21], 1'b0};
        end
    endcase

    default: begin
        IMM = '0;
    end
end
endmodule