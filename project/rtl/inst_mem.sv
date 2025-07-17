// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Talha Ayyaz (@talhaticx)
// =============================================================================
// Single-Cycle RISC-V Processor - Instruction Memory (Workshop Skeleton Version)
// =============================================================================

module imem (
    input  logic [31:0] addr,
    output logic [31:0] instruction
);

    logic [31:0] mem [0:1023]; // 4KB instruction memory

    initial begin
        for (int i = 0; i < 1024; i++)
            mem[i] = 32'h00000013;

        $readmemh("mem.hex", mem);
    end

    // Word-aligned access
    assign instruction = mem[addr >> 2];

endmodule
