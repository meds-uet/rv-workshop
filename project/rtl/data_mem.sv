// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Talha Ayyaz (@talhaticx)
// =============================================================================
// Single-Cycle RISC-V Processor - Data Memory (Workshop Skeleton Version)
// =============================================================================

module data_mem (
    input  logic        clk, reset,
    input  logic        we,
    input  logic [31:0] addr,
    input  logic [31:0] wdata,
    output logic [31:0] rdata
);

    logic [31:0] mem [0:1023]; // 4KB data memory

    // TODO: Initialize memory to zero using a for loop
    always_ff @(posedge clk) begin
        if (reset)
            for (int i = 0; i < 1024; i++) begin
                mem[i] = 32'h0;
            end
        else if (we)
            mem[addr >> 2] = wdata;
    end

    // Read operation
    assign rdata = mem[addr >> 2];

    // Hint: if (we) then write wdata to mem[addr[31:2]]

endmodule
