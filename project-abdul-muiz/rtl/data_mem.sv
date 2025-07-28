// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Umer Shahid (@umershahidengr)
// =============================================================================
// Single-Cycle RISC-V Processor - Data Memory (Workshop Skeleton Version)
// =============================================================================

module dmem (
    input  logic        clk,
    input  logic        we,
    input logic reset,
    input  logic [31:0] addr,
    input  logic [31:0] wdata,
    output logic [31:0] rdata
);

    logic [31:0] mem [0:1023]; // 4KB data memory


    // Read operation
    assign rdata = mem[addr[31:2]];//gives word index instead of bit index

    // TODO: Implement write operation on positive clock edge
    // TODO: Initialize memory to zero using a for loop
    // Hint: if (we) then write wdata to mem[addr[31:2]]
    always_ff @(posedge clk) begin
        if(reset) begin
            for (int i=0;i<1024;i++)begin
                mem[i] = 0;
            end
        end
        else if (we==1)begin
            mem[addr[31:2]]=wdata;//gives word index instead of bit index
        end
    end
endmodule
