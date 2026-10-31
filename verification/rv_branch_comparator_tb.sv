/*
Name: Andre Aviz Vasconcelos
Date: October 30th, 2026
Description: Testbench for 'rv_branch_comparator.sv'
*/

`timescale 1ns/1ps

module rv_branch_comparator_tb;

  // Parameters
  localparam int XLEN = 32;
  localparam time TIMEOUT = 1ms;

  localparam logic [2:0]
        BEQ  = 3'b000,      // branch if equal
        BNE  = 3'b001,      // branch if not equal
        BLT  = 3'b100,      // branch if less than
        BGE  = 3'b101,      // branch if greater than or equal
        BLTU = 3'b110,      // branch if less than (unsigned)
        BGEU = 3'b111;      // branch if greater than or equal (unsigned)

  // Signals
  logic [XLEN-1:0] A;
  logic [XLEN-1:0] B;
  logic [2:0] BRANCH_SEL;

  time start_time;

  int pass_count = 0;
  int fail_count = 0;


  // DUT drives this output
  logic BRANCH;

  int unsigned tests  = 0;
  int unsigned errors = 0;


// *********************************** DUT ***********************************
  rv_branch_comparator_nwidth #(
    // .submodule(PARENT)
    .XLEN(XLEN)
  ) DUT (
    .A(A),
    .B(B),
    .BRANCH_SEL(BRANCH_SEL),
    .BRANCH(BRANCH)
  );


// ***************************** TESTING PROCESS ******************************

  // TEST 1
  task automatic check_branch(
        input logic [XLEN-1:0] A,
        input logic [XLEN-1:0] B,
        input logic [2:0]      BRANCH_SEL,
        input logic            expected
    );
        A          = A;
        B          = B;
        BRANCH_SEL = BRANCH_SEL;

  #1;  // Allow comb. logic to "settle"
        tests++;

        // Case inequality to detect unexpected outputs
        if (BRANCH !== expected) begin
            errors++;
            $error(
                "A=%h B=%h SEL=%b expected=%b actual=%b",
                A, 
                B, 
                BRANCH_SEL, 
                expected, 
                BRANCH
            );
        end
    endtask


    initial begin
        A          = '0;
        B          = '0;
        BRANCH_SEL = BEQ;

/*
    framework:
check_branch(32'h, 32'h, op, 1'b);
*/
    // ---------------------------- EQUAL OPERANDS ----------------------------
check_branch(32'h00000005, 32'h00000005, BEQ, 1'b1);
check_branch(32'h00000005, 32'h00000005, BNE, 1'b0);


    // ---------------------- UNEQUAL POSITIVE OPERANDS -----------------------
check_branch(32'h00000005, 32'h00000007, BEQ, 1'b0);
check_branch(32'h00000005, 32'h00000007, BNE, 1'b1);


   // ------------ SIGNED COMPARISONS WITH OPPOSITE-SIGN OPERANDS -------------
check_branch(32'hFFFFFFFF, 32'h00000001, BEQ, 1'b0);
check_branch(32'hFFFFFFFF, 32'h00000001, BNE, 1'b1);
check_branch(32'hFFFFFFFF, 32'h00000001, BLT, 1'b1);
check_branch(32'hFFFFFFFF, 32'h00000001, BGE, 1'b0);



   // ---------------- UNSIGNED COMPARISONS WITH SAME OPERANDS ----------------
check_branch(32'h00000007, 32'h00000007, BLTU, 1'b0);
check_branch(32'h00000007, 32'h00000007, BGEU, 1'b1);

// opposite-sign bit pattern, now as unsigned
check_branch(32'hFFFFFFFF, 32'h00000001, BLTU, 1'b0);
check_branch(32'hFFFFFFFF, 32'h00000001, BGEU, 1'b1);

// reversing the operands
check_branch(32'h00000001, 32'hFFFFFFFF, BLTU, 1'b1);
check_branch(32'h00000001, 32'hFFFFFFFF, BGEU, 1'b0);


   // ---------------------- SIGNED MIN./MAX. BOUNDARIES ----------------------

// ZERO-VALUE TESTS.
check_branch(32'h00000000, 32'h00000000, BEQ, 1'b1);
check_branch(32'h00000000, 32'h00000000, BNE, 1'b0);
check_branch(32'h00000000, 32'h00000000, BLT, 1'b0);
check_branch(32'h00000000, 32'h00000000, BGE, 1'b1);

// ALL-ONES TESTS. signed value = -1
check_branch(32'hFFFFFFFF, 32'hFFFFFFFF, BEQ, 1'b1);
check_branch(32'hFFFFFFFF, 32'hFFFFFFFF, BNE, 1'b0);
check_branch(32'hFFFFFFFF, 32'hFFFFFFFF, BLT, 1'b0);
check_branch(32'hFFFFFFFF, 32'hFFFFFFFF, BGE, 1'b1);

// signed MIN. vs signed MAX.

check_branch(32'h80000000, 32'h7FFFFFFF, BLT, 1'b1);
check_branch(32'h80000000, 32'h7FFFFFFF, BGE, 1'b0);

// signed MAX. vs signed MIN.

check_branch(32'h7FFFFFFF, 32'h80000000, BLT, 1'b0);
check_branch(32'h7FFFFFFF, 32'h80000000, BGE, 1'b1);


   // ---------------- INVALID RISC-V SELECTORS (op. 010, 011) ----------------
/*
        RISC-V does not have branch conditions mapped to BRANCH_SEL = 010, 011;
        therefore, the modules 'default' case returns 0, regardless of inputs
        when BRANCH_SEL = 010, 011; the CPU decoder will decide the instruction
        legality. 
*/

check_branch(32'h00000005, 32'h00000005, 3'b010, 1'b0);
check_branch(32'h00000007, 32'h00000007, 3'b010, 1'b0);
check_branch(32'h7FFFFFFF, 32'h80000000, 3'b010, 1'b0);
check_branch(32'h80000000, 32'h7FFFFFFF, 3'b010, 1'b0);

check_branch(32'h00000005, 32'h00000005, 3'b011, 1'b0);
check_branch(32'h00000007, 32'h00000007, 3'b011, 1'b0);
check_branch(32'h7FFFFFFF, 32'h80000000, 3'b011, 1'b0);
check_branch(32'h80000000, 32'h7FFFFFFF, 3'b011, 1'b0);


   // ***************************** FINAL SUMMARY: ****************************

    if (errors == 0) begin
        $display("----------------------------------------");
        $display("PASS: all %0d TESTBENCH COMPLETED SUCCESSFULLY", tests);
        $display("FAILED: %0d", errors);
        $display("----------------------------------------");
    end
    else begin
        $fatal(1, "FAIL: %0d FAILURES IN %0d CHECKS", errors, tests);
    end

    $finish;
  end

endmodule