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
// INSTRUCTION MEMORY MODULE
// =============================================================================
module imem (
    input  logic [31:0] addr,
    output logic [31:0] instruction
);
    logic [31:0] mem [0:1023]; // 4KB instruction memory
    
    // Initialize with some sample instructions for testing
    initial begin
        mem[0] = 32'h00500093; // addi x1, x0, 5
        mem[1] = 32'h00600113; // addi x2, x0, 6
        mem[2] = 32'h002081b3; // add x3, x1, x2
        mem[3] = 32'h00000013; // nop
        // Fill rest with nop instructions
        for (int i = 4; i < 1024; i++) begin
            mem[i] = 32'h00000013;
        end
    end
    
    assign instruction = mem[addr[31:2]]; // Word-aligned access
endmodule

