// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: javeria
// =============================================================================
// RISC-V Register File Testbench
// =============================================================================

module tb_register_file;

    logic clk, rst, reg_wr;
    logic [4:0] raddr1, raddr2, waddr;
    logic [31:0] wdata;
    wire [31:0] rdata1, rdata2;

    int passed = 0, failed = 0, total = 0;

    // Instantiate the register file
    register_file dut (
        .clk(clk), .rst(rst), .reg_wr(reg_wr),
        .raddr1(raddr1), .raddr2(raddr2),
        .waddr(waddr), .wdata(wdata),
        .rdata1(rdata1), .rdata2(rdata2)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Check task
    task check_read(input [4:0] r1, r2, input [31:0] exp1, exp2, input string msg);
        raddr1 = r1; raddr2 = r2;
        #1;
        total++;
        if (rdata1 === exp1 && rdata2 === exp2) begin
            passed++;
            $display("[PASS] %s | rdata1 = %h, rdata2 = %h", msg, rdata1, rdata2);
        end else begin
            failed++;
            $display("[FAIL] %s | rdata1 = %h (exp %h), rdata2 = %h (exp %h)", msg, rdata1, exp1, rdata2, exp2);
        end
    endtask

    initial begin
        clk = 0;
        rst = 1; reg_wr = 0;
        raddr1 = 0; raddr2 = 0;
        waddr = 0; wdata = 0;

        $display("=== Register File Testbench Start ===");

        // Apply reset
        #10;
        rst = 0;

        // Test initial reset values
        check_read(0, 1, 0, 10, "Read x0 and x1 after reset");

        // Test write disabled
        waddr = 3; wdata = 32'hDEAD_BEEF; reg_wr = 0;
        #10;
        check_read(3, 0, 30, 0, "Write disabled, should remain old value");

        // Write to x2
        waddr = 2; wdata = 32'h1111_2222; reg_wr = 1;
        #10;
        reg_wr = 0;
        check_read(2, 1, 32'h1111_2222, 10, "Write to x2, read x2 and x1");

        // Write to x0 (should be ignored and remain 0)
        waddr = 0; wdata = 32'hFFFF_FFFF; reg_wr = 1;
        #10;
        reg_wr = 0;
        check_read(0, 2, 0, 32'h1111_2222, "Write to x0 ignored");

        // Summary
        $display("=== Register File Summary ===");
        $display("Total: %0d | Passed: %0d | Failed: %0d", total, passed, failed);
        if (failed == 0)
            $display("✅ All tests passed.");
        else
            $display("❌ Some tests failed.");
        $finish;
    end
endmodule

