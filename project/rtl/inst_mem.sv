// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author:  javeria
// =============================================================================
// Single-Cycle RISC-V Processor - Instruction Memory (Workshop Skeleton Version)
// =============================================================================

module Instruction_Memory (
    input  logic [31:0] address,
    output logic [31:0] instruction
);
    logic [31:0] instruction_memory [0:1023]; // 4KB instruction memory

    initial begin
        // Initialize all memory locations to NOP (0x00000013)
        for (int i = 0; i < 1024; i++) begin
            instruction_memory[i] = 32'h00000013;
        end

        // Overwrite specific locations with test instructions
        instruction_memory[0] = 32'h00500093; // ADDI x1, x0, 5
        instruction_memory[1] = 32'h00600113; // ADDI x2, x0, 6
        instruction_memory[2] = 32'h002081b3; // ADD  x3, x1, x2
        instruction_memory[3] = 32'h00000013; // NOP
    end

    // Instruction fetch based on address
    always_comb begin
        instruction = instruction_memory[address[11:2]]; // address >> 2
    end
endmodule

