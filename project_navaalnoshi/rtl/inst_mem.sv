// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Navaal Noshi
// =============================================================================
// Single-Cycle RISC-V Processor - Instruction Memory (Workshop Skeleton Version)
// =============================================================================


module imem (
    input  logic [31:0] addr,           // Byte address input
    output logic [31:0] instruction     // Output instruction
);

    // 4KB instruction memory: 1024 words of 32-bit width
    logic [31:0] mem [0:1023];

    // Initialized memory with test instructions and fill remaining with NOPs
    initial begin
        // Specific test instructions
        mem[0] = 32'h00500093; // ADDI x1, x0, 5
        mem[1] = 32'h00600113; // ADDI x2, x0, 6
        mem[2] = 32'h002081b3; // ADD x3, x1, x2
        mem[3] = 32'h40218233; // sub x4, x3, x2
        mem[4] = 32'h00000013; // NOP

        // Filled remaining memory with NOPs
        for (int i = 4; i < 1024; i++) begin
            mem[i] = 32'h00000013; // NOP (default for uninitialized memory)
        end
    end

    // Word-aligned access: bottom 2 bits ignored (handles misaligned addresses)
    assign instruction = mem[addr[31:2]];

endmodule

