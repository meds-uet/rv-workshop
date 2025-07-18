// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: javeria
// =============================================================================
// RISC-V Branch Unit Testbench
// =============================================================================

module tb_Branch_Condition;

    // Inputs
    logic [31:0] rdataA, rdataB;
    logic [2:0] br_type;

    // Output
    wire br_taken;

    // Test counters
    int total = 0, passed = 0, failed = 0;

    // Instantiate DUT
    Branch_Condition dut (
        .br_type(br_type),
        .rdataA(rdataA),
        .rdataB(rdataB),
        .br_taken(br_taken)
    );

    // Test task
    task run_test(
        input logic [31:0] a, b,
      input logic [2:0] br,
        input logic expected,
        input string desc
    );
        begin
            rdataA = a;
            rdataB = b;
            br_type = br;
            #1; // Wait for evaluation

            total++;
            if (br_taken === expected) begin
                passed++;
                $display("[PASS] %-30s | br_taken = %b", desc, br_taken);
            end else begin
                failed++;
                $display("[FAIL] %-30s | br_taken = %b (expected %b)", desc, br_taken, expected);
            end
        end
    endtask

    // Test cases
    initial begin
        $display("=== Branch_Condition Testbench Start ===");

        run_test(32'h12345678, 32'h12345678, 3'b001, 1, "BEQ - Equal");
        run_test(32'h12345678, 32'h87654321, 3'b010, 1, "BNE - Not Equal");
        run_test(-5,           10,           3'b011, 1, "BLT - Signed less than");
        run_test(-5,           -10,          3'b100, 1, "BGE - Signed greater or equal");
        run_test(32'h00000001, 32'hFFFFFFFF, 3'b101, 1, "BLTU - Unsigned less than");
        run_test(32'hFFFFFFFF, 32'h00000001, 3'b110, 1, "BGEU - Unsigned greater or equal");
        run_test(32'h00000000, 32'h00000000, 3'b000, 0, "NOP - Should not take branch");
        run_test(32'h11111111, 32'h22222222, 3'b111, 1, "Unconditional jump");

        $display("=== Branch_Condition Testbench Summary ===");
        $display("Total tests: %0d", total);
        $display("Passed     : %0d", passed);
        $display("Failed     : %0d", failed);

        if (failed == 0)
            $display("✅ All tests passed!");
        else
            $display("❌ Some tests failed. Check above.");

        $finish;
    end

endmodule
