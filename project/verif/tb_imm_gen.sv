// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Javeria
// =============================================================================
// RISC-V Immediate Generator Testbench
// =============================================================================

module tb_immgen;
    logic [31:0] instruction;
    wire [31:0] immediate_value;

    int passed = 0, failed = 0, total = 0;

    Immediate_Generator dut (
        .instruction(instruction),
        .immediate_value(immediate_value)
    );

    task run_test(
        input logic [31:0] instr,
        input logic [31:0] expected,
        input string desc
    );
        begin
            instruction = instr;
            #10;  // Increased delay to ensure settling
            
            total++;
            if (immediate_value === expected) begin
                passed++;
                $display("[PASS] %s | imm = %h", desc, immediate_value);
            end else begin
                failed++;
                $display("[FAIL] %s | imm = %h, expected = %h", desc, immediate_value, expected);
            end
        end
    endtask

    initial begin
        $display("\n=== IMMGEN Testbench Start ===\n");

        // I-type (Load)
      run_test(32'hFFF12383, 32'hFFFFFFFF, "I-type (Load)");
        // I-type (ALU)
      run_test(32'h00F12313, 32'h0000000F, "I-type (ALU)");
        // S-type
      run_test(32'h00F12323, 32'h00000006, "S-type (Store)");
        // B-type
      run_test(32'hFE512EE3, 32'hFFFFFFFC, "B-type (Branch)");
        // U-type (LUI)
        run_test(32'h12345037, 32'h12345000, "U-type (LUI)");
        // U-type (AUIPC)
        run_test(32'h12345017, 32'h12345000, "U-type (AUIPC)");
        // J-type
      run_test(32'hFFF0016F, 32'hFFF00FFE, "J-type (JAL)");
        // R-type
        run_test(32'h002081B3, 32'h00000000, "R-type (ADD)");
        // Default case
        run_test(32'h00000000, 32'h00000000, "NOP / Default");

        $display("\n=== IMMGEN Summary ===");
        $display("Total: %0d | Passed: %0d | Failed: %0d", total, passed, failed);
        if (failed == 0) $display("✅ All tests passed.");
        else $display("❌ Some tests failed.");
        
        $finish;
    end
endmodule