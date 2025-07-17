// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Umer Shahid (@umershahidengr)
// =============================================================================
// Single-Cycle RISC-V Processor - Register File (Complete Version)
// =============================================================================

module register_file (
    input  logic        clk,
    input  logic        we,
    input  logic [4:0]  ra1, ra2, wa,
    input  logic [31:0] wd,
    output logic [31:0] rd1, rd2
);

    logic [31:0] registers [0:31];

    // Initialize all registers to zero at start
    initial begin
        for (int i = 0; i < 32; i++) begin
            registers[i] = 32'h0000_0000;
        end
    end

    // Read port 1
    assign rd1 = (ra1 == 5'd0) ? 32'h0000_0000 : registers[ra1];

    // Read port 2
    assign rd2 = (ra2 == 5'd0) ? 32'h0000_0000 : registers[ra2];

    // Write logic
    always_ff @(posedge clk) begin
        if (we && (wa != 5'd0)) begin
            registers[wa] <= wd;
        end
    end

endmodule
