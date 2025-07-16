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
module tb_alu;
    // Inputs
    reg [31:0] a, b;
    reg [3:0] alu_control;
    
    // Outputs
    wire [31:0] result;
    wire zero;
    
    // Instantiate ALU
    alu dut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );
    
    // Test sequence
    initial begin
        $display("Starting ALU test...");
        $monitor("Time=%t: a=%h b=%h op=%b result=%h zero=%b", 
                $time, a, b, alu_control, result, zero);
        
        // Test ADD
        a = 32'h0000_0005;
        b = 32'h0000_0003;
        alu_control = 4'b0000;
        #10;
        
        // Test SUB
        a = 32'h0000_0005;
        b = 32'h0000_0003;
        alu_control = 4'b0001;
        #10;
        
        // Test AND
        a = 32'hF0F0_F0F0;
        b = 32'h0F0F_0F0F;
        alu_control = 4'b0010;
        #10;
        
        // Test OR
        a = 32'hF0F0_F0F0;
        b = 32'h0F0F_0F0F;
        alu_control = 4'b0011;
        #10;
        
        // Test XOR
        a = 32'hF0F0_F0F0;
        b = 32'h0F0F_0F0F;
        alu_control = 4'b0100;
        #10;
        
        // Test SLL (shift left logical)
        a = 32'h0000_0001;
        b = 32'h0000_0004; // Shift by 4
        alu_control = 4'b0101;
        #10;
        
        // Test SRL (shift right logical)
        a = 32'h8000_0000;
        b = 32'h0000_0004; // Shift by 4
        alu_control = 4'b0110;
        #10;
        
        // Test SRA (shift right arithmetic)
        a = 32'h8000_0000;
        b = 32'h0000_0004; // Shift by 4
        alu_control = 4'b0111;
        #10;
        
        // Test SLT (set less than signed)
        a = 32'hFFFF_FFFF; // -1
        b = 32'h0000_0001; // 1
        alu_control = 4'b1000;
        #10;
        
        // Test SLTU (set less than unsigned)
        a = 32'hFFFF_FFFF; // large unsigned
        b = 32'h0000_0001; // small unsigned
        alu_control = 4'b1001;
        #10;
        
        // Test zero flag
        a = 32'h0000_0000;
        b = 32'h0000_0000;
        alu_control = 4'b0000; // ADD
        #10;
        
        $display("ALU test completed");
        $finish;
    end
endmodule