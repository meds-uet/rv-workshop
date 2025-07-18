// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: javeria
// =============================================================================
// ALU Testbench with Logging and Result Summary
// =============================================================================

module tb_ALU;

    // Inputs
    reg [31:0] a, b;
    reg [3:0] alu_control;

    // Output
    wire [31:0] result;

    // Counters
    int total = 0, passed = 0, failed = 0;

    // Instantiate DUT
    ALU dut (
        .alu_op(alu_control),
        .A(a),
        .B(b),
        .AB_out(result)
    );

    // Test task
    task run_test(
        input [31:0] ain, bin,
        input [3:0] ctrl,
        input [31:0] exp_result,
        input string desc
    );
        begin
            a = ain;
            b = bin;
            alu_control = ctrl;
            #1; // small delay to simulate logic propagation

            total++;
            if (result === exp_result) begin
                passed++;
                $display("[PASS] %-30s | result = %h", desc, result);
            end else begin
                failed++;
                $display("[FAIL] %-30s | result = %h (expected %h)", desc, result, exp_result);
            end
        end
    endtask

    // Initial test sequence
    initial begin
        $display("=== ALU Testbench Start ===");

        run_test(32'h00000005, 32'h00000003, 4'b0000, 32'h00000008, "ADD");
        run_test(32'h00000005, 32'h00000003, 4'b0001, 32'h00000002, "SUB");
        run_test(32'h00000001, 32'h00000004, 4'b0010, 32'h00000010, "SLL");
        run_test(32'h80000000, 32'h00000004, 4'b0011, 32'h08000000, "SRL");
        run_test(32'h80000000, 32'h00000004, 4'b0100, 32'hF8000000, "SRA");
        run_test(32'hFFFFFFFF, 32'h00000001, 4'b0101, 32'h00000001, "SLT (signed -1 < 1)");
        run_test(32'hFFFFFFFF, 32'h00000001, 4'b0110, 32'h00000000, "SLTU (unsigned)");
        run_test(32'hF0F0F0F0, 32'h0F0F0F0F, 4'b0111, 32'hFFFFFFFF, "XOR");
        run_test(32'hF0F0F0F0, 32'h0F0F0F0F, 4'b1000, 32'hFFFFFFFF, "OR");
        run_test(32'hF0F0F0F0, 32'h0F0F0F0F, 4'b1001, 32'h00000000, "AND");
        run_test(32'h00000000, 32'h00000000, 4'b0000, 32'h00000000, "ADD (zero result)");
        run_test(32'hDEADBEEF, 32'h12345678, 4'b1010, 32'h12345678, "Pass B");

        $display("=== ALU Testbench Summary ===");
        $display("Total tests: %0d", total);
        $display("Passed     : %0d", passed);
        $display("Failed     : %0d", failed);

        if (failed == 0)
            $display("✅ All ALU tests passed.");
        else
            $display("❌ Some ALU tests failed. Review results above.");

        $finish;
    end

endmodule
