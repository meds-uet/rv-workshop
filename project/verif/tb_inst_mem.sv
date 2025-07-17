// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Umer Shahid (@umershahidengr)
// =============================================================================
// RISC-V Instruction Memory Testbench
// =============================================================================

module tb_imem;

    logic [31:0] addr;
    wire  [31:0] instruction;

    int passed = 0, failed = 0, total = 0;

    // Instantiate DUT
    imem dut (
        .addr(addr),
        .instruction(instruction)
    );

    task run_test(
        input logic [31:0] test_addr,
        input logic [31:0] expected_instr,
        input string       description
    );
        begin
            addr = test_addr;
            #1;
            total++;
            if (instruction === expected_instr) begin
                $display("[PASS] %s | Addr = %h, Instruction = %h", description, test_addr, instruction);
                passed++;
            end else begin
                $display("[FAIL] %s | Addr = %h | Got = %h, Expected = %h",
                         description, test_addr, instruction, expected_instr);
                failed++;
            end
        end
    endtask

    initial begin
        $display("=== Starting IMEM Testbench ===");

        // Aligned addresses
        run_test(32'h0000_0000, 32'h00500093, "ADDI x1, x0, 5");
        run_test(32'h0000_0004, 32'h00600113, "ADDI x2, x0, 6");
        run_test(32'h0000_0008, 32'h002081b3, "ADD x3, x1, x2");
        run_test(32'h0000_000C, 32'h403101b3, "SUB x3, x2, x3");

        // Word-aligned NOPs
        run_test(32'h0000_0010, 32'h00000013, "NOP at 0x10");
        run_test(32'h0000_0050, 32'h00000013, "NOP at 0x50");

        // Misaligned address (e.g., 0x00000005 should still return instruction at addr 0x00000004)
        run_test(32'h0000_0005, 32'h00600113, "Misaligned address 0x00000005 → same as 0x00000004");

        $display("=== IMEM Test Summary ===");
        $display("Total: %0d | Passed: %0d | Failed: %0d", total, passed, failed);
        if (failed == 0)
            $display("✅ All tests passed.");
        else
            $display("❌ Some tests failed.");

        $finish;
    end

endmodule

