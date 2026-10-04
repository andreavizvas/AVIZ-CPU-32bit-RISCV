// Name: add_sub_nwidth
// Date: August 10th, 2026
// Description: N-width adder and subtractor, for 32-bit CPU and other projects 

// DESIGNER: ANDRE AVIZ VASCONCELOS, Thu August 13 2026, 16:32:21, Shoal Bay East, Anguilla


// **************************************** parent module *****************************************

module add_sub_nwidth #(
    parameter WIDTH = 32
)(
    input  logic [WIDTH-1:0] OP1,           // minuend (when subtraction is selected)
    input  logic [WIDTH-1:0] OP2,           // subtrahend (when subtraction is selected)
    input  logic             SUB,           // controls whether we are adding or subtracting
                                            // during subtraction, SUB also supplies the +1 for two's comp, where ~OP2 is 1's comp.
    output logic [WIDTH-1:0] RESULT,        // (RISC-V does not have a carry or borrow flag)
    output logic             COUT,
    output logic             OVERFLOW
);
           logic [WIDTH:0]   SUM_EXTENDED;  // extended SUM with COUT as MSB
           logic [WIDTH-1:0] OP2_COND_INV;

// *********************************** submodule instantiations ************************************

// 1. ---------------------------------------------------------------------------------------------

// n-width conditional XOR control module, supporting adder/subtraction with same hardware,
// by taking 1's complement of OP2 when selected for, and using CIN (SUB) to make it 2's complement

     XOR_control_nwidth #(
        .WIDTH (WIDTH)
    ) u_xor_control (
        .OP2          (OP2),         // subtrahend
        .SUB          (SUB),         // if SUB == 1, subtracting; else adding
        .OP2_COND_INV (OP2_COND_INV) // modified OP2 input for adder, (~OP2); 1's complement of OP2, 
                                     // needs LSB + 1 to get 2's complement for (-)
    );

// 2. ---------------------------------------------------------------------------------------------

    OVERFLOW_control_nwidth #(
        .WIDTH(WIDTH)
    ) u_overflow_control (
        .OP1          (OP1),
        .OP2_COND_INV (OP2_COND_INV),
        .RESULT       (RESULT),      // intakes arithmetic result, checking it for overflow
        .OVERFLOW     (OVERFLOW)
    );

// ****************************************** arithmetic ******************************************

    assign SUM_EXTENDED = {1'b0, OP1} + {1'b0, OP2_COND_INV} + SUB;
    assign RESULT       = SUM_EXTENDED[WIDTH-1:0];
    assign COUT         = SUM_EXTENDED[WIDTH];

endmodule



