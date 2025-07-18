// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Javeria
// =============================================================================
// RISC-V Data Memory Testbench (Enhanced with Checks)
// =============================================================================

module tb_dmem;

    // Inputs
    logic clk;
    logic rst;
    logic wr_en;
    logic rd_en;
    logic [31:0] address;
    logic [31:0] wdata;

    // Output
    logic [31:0] rdata;

    int total = 0, passed = 0, failed = 0;

    // Instantiate DUT
    Data_Memory dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .address(address),
        .wdata(wdata),
        .rdata(rdata)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Task for result checking
    task check(input [31:0] expected, input string desc);
        total++;
        #1;
        if (rdata === expected) begin
            passed++;
            $display("[PASS] %s | addr=%h, rdata=%h", desc, address, rdata);
        end else begin
            failed++;
            $display("[FAIL] %s | addr=%h, rdata=%h, expected=%h", desc, address, rdata, expected);
        end
    endtask

    // Initial block
    initial begin
        $display("=== Data Memory Testbench Start ===");

        // Init
        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        address = 0;
        wdata = 0;

        #10;
        rst = 0; // De-assert reset

        // Test 1: Read from zero-initialized memory
        rd_en = 1;
        address = 32'h0000_0000;
        #10;
        check(32'h0000_0000, "Read from addr 0 after reset");

        // Test 2: Write A5A5A5A5 to addr 0x04
        wr_en = 1;
        rd_en = 0;
        address = 32'h0000_0004;
        wdata = 32'hA5A5A5A5;
        #10;
        wr_en = 0;

        // Test 3: Write 12345678 to addr 0x10
        wr_en = 1;
        address = 32'h0000_0010;
        wdata = 32'h12345678;
        #10;
        wr_en = 0;

        // Test 4: Read back A5A5A5A5 from addr 0x04
        rd_en = 1;
        address = 32'h0000_0004;
        #10;
        check(32'hA5A5A5A5, "Read back addr 0x04");

        // Test 5: Read back 12345678 from addr 0x10
        address = 32'h0000_0010;
        #10;
        check(32'h12345678, "Read back addr 0x10");

        // Test 6: Try to write DEADBEEF with wr_en = 0
        wr_en = 0;
        rd_en = 0;
        address = 32'h0000_0020;
        wdata = 32'hDEADBEEF;
        #10; // No write

        // Test 7: Read from addr 0x20 (should remain 0)
        rd_en = 1;
        #10;
        check(32'h0000_0000, "Read back addr 0x20 (should remain 0)");

        // Summary
        $display("=== Data Memory Testbench Summary ===");
        $display("Total tests: %0d", total);
        $display("Passed     : %0d", passed);
        $display("Failed     : %0d", failed);
        if (failed == 0)
            $display("✅ All memory tests passed.");
        else
            $display("❌ Some memory tests failed. Please review above.");

        $finish;
    end
endmodule

