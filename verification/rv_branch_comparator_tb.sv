/*
Name: Andre Aviz Vasconcelos
Date: October 30th, 2026
Description: Testbench for 'rv_branch_comparator.sv'
*/

`timescale 1ns/1ps

module rv_branc_comparator_tb;

  // Parameters
  localparam int WIDTH = 32;
  localparam time TIMEOUT = 1ms;

  // Signals
  logic clk = 0;
  logic clkEn = 1;
  logic rst = 1;
  logic go = 0;
  logic done;
  logic [WIDTH-1:0] x = 0;
  logic [WIDTH-1:0] y = 0;
  logic [WIDTH-1:0] out;
  time start_time;

  int pass_count = 0;
  int fail_count = 0;

  // Clock generation
  always #20 if (clkEn) clk = ~clk;

  // Instantiation of branch comparator module
  rv_branch_comparator_nwidth #(
    // .submodule(PARENT)
    .WIDTH(WIDTH)
  ) DUT (
    
  );

  // GCD reference function
  function automatic logic [WIDTH-1:0] compute_gcd(input int a, input int b);
    int tx, ty;
    begin
      tx = a;
      ty = b;

      while (tx != ty) begin
        if (tx < ty)
          ty = ty - tx;
        else
          tx = tx - ty;
      end

      compute_gcd = tx;
    end
  endfunction

  // Run one GCD test.
  task automatic test_gcd(input int a, input int b);
    logic [WIDTH-1:0] expected;
    begin
      @(posedge clk);
      x  <= a;
      y  <= b;
      go <= 1;

      @(posedge clk);  // pulse go for one cycle
      go <= 0;

      @(posedge clk);

      start_time = $time;
      wait (done || $time - start_time >= TIMEOUT);

      if (!done) begin
        $warning("Timeout: done never asserted for x=%0d, y=%0d", a, b);
        fail_count++;
      end
      else begin
        expected = compute_gcd(a, b);

        if (out !== expected) begin
          $warning("Incorrect GCD for x=%0d, y=%0d. Expected %0d, Got %0d",
                   a, b, expected, out);
          fail_count++;
        end
        else begin
          $display("PASS: gcd(%0d, %0d) = %0d", a, b, out);
          pass_count++;
        end
      end

      @(posedge clk);  // wait before next test
    end
  endtask

// ***************************** TESTING PROCESS ******************************
    initial begin
    // Reset
    clkEn <= 1;
    rst   <= 1;
    go    <= 0;
    x     <= 0;
    y     <= 0;

    repeat (10) @(posedge clk);
    rst <= 0;
    repeat (5) @(posedge clk);

// ---------------------------------- TESTS -----------------------------------

    // Exhaustive testing of a small input range
    for (int i = 1; i <= 8; i++) begin
      for (int j = 1; j <= 8; j++) begin
        test_gcd(i, j);
      end
    end

    // Additional directed cases

    $display("");
    $display("----------------------------------------");
    $display("Completed student testbench complete.");
    $display("Passed: %0d", pass_count);
    $display("Failed: %0d", fail_count);
    $display("----------------------------------------");

    clkEn <= 0;
    $finish;
  end

endmodule
