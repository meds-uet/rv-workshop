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

module tb_pc;
    // Inputs
    reg clk;
    reg reset;
    reg [31:0] pc_next;
    
    // Output
    wire [31:0] pc;
    
    // Instantiate the PC module
    pc dut (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );
    
    // Clock generation (100MHz)
    always #5 clk = ~clk;
    
    // Test sequence
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 0;
        pc_next = 0;
        
        // Monitor changes
        $monitor("Time = %t: reset = %b, pc_next = %h, pc = %h", 
                 $time, reset, pc_next, pc);
        
        // Test 1: Reset functionality
        reset = 1;
        pc_next = 32'h0000_0004;
        #20;
        
        // Test 2: Normal operation
        reset = 0;
        pc_next = 32'h0000_0004;
        #10;
        
        pc_next = 32'h0000_0008;
        #10;
        
        pc_next = 32'h0000_000C;
        #10;
        
        // Test 3: Reset during operation
        reset = 1;
        pc_next = 32'h1234_5678;
        #10;
        
        // Test 4: Continue after reset
        reset = 0;
        pc_next = 32'hFFFF_FFFC;
        #10;
        
        pc_next = 32'hABCD_1234;
        #10;
        
        $display("PC testbench completed");
        $finish;
    end
endmodule