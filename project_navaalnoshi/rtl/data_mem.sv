// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Navaal Noshi
// =============================================================================
// Single-Cycle RISC-V Processor - Data Memory (Workshop Skeleton Version)
// =============================================================================

module dmem (
    input  logic        clk,
    input  logic        we,
    input  logic [31:0] addr,
    input  logic [31:0] wdata,
    output logic [31:0] rdata
);

    logic [31:0] mem [0:1023]; // 4KB data memory
    //Initialization memory to zero using a for loop
    initial begin
        for (int i = 0; i < 1024; i++) begin
            mem[i] = 32'd0;
        end
    end

    // Read operation
    assign rdata = mem[addr[31:2]];
    //Implementation write operation on positive clock edge
    // Hint: if (we) then write wdata to mem[addr[31:2]]
    always @(posedge clk) begin
        if (we) begin
            mem[addr[31:2]] <= wdata;  // Word-aligned write
        end
    end

endmodule
