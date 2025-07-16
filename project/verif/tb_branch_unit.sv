// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Umer Shahid (@umershahidengr)
// =============================================================================
// Single-Cycle RISC-V Processor - Complete Implementation
// MEDS Workshop: "Build your own RISC-V Processor in a day"
// =============================================================================
// =============================================================================
// RISC-V Processor Comprehensive Testbench
// Tests individual modules and complete processor
// =============================================================================
module tb_branch_unit;
    // Inputs
    reg [31:0] rd1, rd2;
    reg [2:0] funct3;
    reg branch;
    
    // Output
    wire pc_src;
    
    // Instantiate branch unit
    branch_unit dut (
        .rd1(rd1),
        .rd2(rd2),
        .funct3(funct3),
        .branch(branch),
        .pc_src(pc_src)
    );
    
    // Test sequence
    initial begin
        $display("Starting Branch Unit test...");
        $monitor("Time=%t: rd1=%h rd2=%h funct3=%b branch=%b pc_src=%b",
                $time, rd1, rd2, funct3, branch, pc_src);
        
        // Test 1: BEQ (equal)
        branch = 1;
        funct3 = 3'b000;
        rd1 = 32'h1234_5678;
        rd2 = 32'h1234_5678;
        #10;
        
        // Test 2: BEQ (not equal)
        rd2 = 32'h8765_4321;
        #10;
        
        // Test 3: BNE (not equal)
        funct3 = 3'b001;
        #10;
        
        // Test 4: BNE (equal)
        rd2 = 32'h1234_5678;
        #10;
        
        // Test 5: BLT (a < b, signed)
        funct3 = 3'b100;
        rd1 = 32'hFFFF_FFFF; // -1
        rd2 = 32'h0000_0001; // 1
        #10;
        
        // Test 6: BLT (a >= b, signed)
        rd1 = 32'h0000_0001;
        #10;
        
        // Test 7: BGE (a >= b, signed)
        funct3 = 3'b101;
        #10;
        
        // Test 8: BGE (a < b, signed)
        rd1 = 32'hFFFF_FFFF;
        #10;
        
        // Test 9: BLTU (a < b, unsigned)
        funct3 = 3'b110;
        rd1 = 32'h0000_0001;
        rd2 = 32'hFFFF_FFFF;
        #10;
        
        // Test 10: BLTU (a >= b, unsigned)
        rd1 = 32'hFFFF_FFFF;
        #10;
        
        // Test 11: BGEU (a >= b, unsigned)
        funct3 = 3'b111;
        #10;
        
        // Test 12: BGEU (a < b, unsigned)
        rd1 = 32'h0000_0001;
        #10;
        
        // Test 13: Branch disabled
        branch = 0;
        #10;
        
        $display("Branch Unit test completed");
        $finish;
    end
endmodule