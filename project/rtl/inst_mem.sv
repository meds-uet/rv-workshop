// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Umer Shahid (@umershahidengr)
// =============================================================================
// Single-Cycle RISC-V Processor - Instruction Memory (Workshop Skeleton Version)
// =============================================================================

module imem (
    input  logic [31:0] addr,
    output logic [31:0] instruction
);

    logic [31:0] mem [0:1023]; // 4KB instruction memory

    initial begin
        integer i;

        // Fill memory with NOPs (addi x0, x0, 0)
        for (i = 0; i < 1024; i = i + 1) begin
            mem[i] = 32'h00000013; // NOP
        end

        // Example test instructions
        mem[0] = 32'h00500093; // addi x1, x0, 5
        mem[1] = 32'h00a00113; // addi x2, x0, 10
        mem[2] = 32'h002081b3; // add  x3, x1, x2
        mem[3] = 32'h40218233; // sub  x4, x3, x2
        mem[4] = 32'h0041a023; // sw   x4, 0(x3)
        mem[5] = 32'h0001a503; // lw   x10, 0(x3)
        mem[6] = 32'h0062a263; // beq  x5, x6, offset (example only, depends on offset encoding)
        mem[7] = 32'h0000006f; // jal  x0, 0 (infinite loop)

        // Remaining entries stay as NOP

    // Word-aligned access
    assign instruction = mem[addr[31:2]];

endmodule
