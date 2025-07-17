// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Ammarah WWakeel
// =============================================================================
// Single-Cycle RISC-V Processor - Instruction Memory (Workshop Skeleton Version)
// =============================================================================pc.sv


module imem (
    input  logic [31:0] addr,
    output logic [31:0] instruction
);

    logic [31:0] mem [0:1023]; // 4KB instruction memory (1024 words)

    initial begin
        integer i;

        // Initialize entire memory with NOPs
        for (i = 0; i < 1024; i = i + 1)
            mem[i] = 32'h00000013;  // NOP = addi x0, x0, 0

        // Overwrite with test instructions
        mem[0] = 32'h00500093; // addi x1, x0, 5
        mem[1] = 32'h00600113; // addi x2, x0, 6
        mem[2] = 32'h002081b3; // add  x3, x1, x2
        mem[3] = 32'h403101b3; // sub  x3, x2, x3
    end

    // Word-aligned fetch (drop bottom 2 bits of addr)
    assign instruction = mem[addr[31:2]];

endmodule