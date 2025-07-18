// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: javeria
// =============================================================================
// RISC-V PC Module Testbench (Enhanced with Checks)
// =============================================================================

module tb_pc;

    // Inputs
    logic clk;
    logic rst;
    logic [31:0] pc_in;

    // Output
    wire [31:0] pc_next;

    // Test bookkeeping
    int total = 0, passed = 0, failed = 0;

    // Instantiate the Program Counter module
    Progam_Counter dut (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_in),
        .pc_next(pc_next)
    );

    // Clock generation (100MHz)
    always #5 clk = ~clk;

    // Utility to check result
    task check(input [31:0] expected, input string desc);
        total++;
        #1;
        if (pc_next === expected) begin
            passed++;
            $display("[PASS] %s | pc_next = %h", desc, pc_next);
        end else begin
            failed++;
            $display("[FAIL] %s | pc_next = %h, expected = %h", desc, pc_next, expected);
        end
    endtask

    // Test sequence
    initial begin
        $display("=== Program Counter Testbench Start ===");

        // Initialize inputs
        clk = 0;
        rst = 0;
        pc_in = 0;

        // Test 1: Reset functionality
        rst = 1;
        pc_in = 32'h0000_0004;
        #12;
        check(32'h0000_0000, "Test 1: PC Reset should be zero");

        // Test 2: Normal operation after reset deasserted
        rst = 0;
        pc_in = 32'h0000_0004;
        #10;
        check(32'h0000_0004, "Test 2a: PC update to 0x4");

        pc_in = 32'h0000_0008;
        #10;
        check(32'h0000_0008, "Test 2b: PC update to 0x8");

        pc_in = 32'h0000_000C;
        #10;
        check(32'h0000_000C, "Test 2c: PC update to 0xC");

        // Test 3: Reset during operation
        rst = 1;
        pc_in = 32'h1234_5678;
        #10;
        check(32'h0000_0000, "Test 3: Reset asserted again");

        // Test 4: Continue after reset
        rst = 0;
        pc_in = 32'hFFFF_FFFC;
        #10;
        check(32'hFFFF_FFFC, "Test 4a: PC update to FFFF_FFFC");

        pc_in = 32'hABCD_1234;
        #10;
        check(32'hABCD_1234, "Test 4b: PC update to ABCD_1234");

        // Summary
        $display("=== PC Testbench Summary ===");
        $display("Total tests : %0d", total);
        $display("Passed      : %0d", passed);
        $display("Failed      : %0d", failed);
        if (failed == 0)
            $display("✅ All PC tests passed.");
        else
            $display("❌ Some PC tests failed. Check logs.");

        $finish;
    end
endmodule

