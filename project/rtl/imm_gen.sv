// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Umer Shahid (@umershahidengr)
// =============================================================================
// Single-Cycle RISC-V Processor - Immediate Generator (Workshop Skeleton Version)
// =============================================================================

module immgen (
    input  logic [31:0] instruction,
    input  logic [2:0]  imm_src,
    output logic [31:0] imm_ext
);

    always_comb begin
        case (imm_src)
            // I-type: imm[11:0] = instruction[31:20]
            3'b000: 
                imm_ext = {{20{instruction[31]}}, instruction[31:20]};
            
            // S-type: imm[11:5] = instruction[31:25], imm[4:0] = instruction[11:7]
            3'b001:
                imm_ext = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

            // B-type: imm[12|10:5|4:1|11] = instruction[31|30:25|11:8|7], LSB = 0
            3'b010:
                imm_ext = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

            // U-type: imm[31:12] = instruction[31:12], LSBs = 12'b0
            3'b011:
                imm_ext = {instruction[31:12], 12'b0};

            // J-type: imm[20|10:1|11|19:12] = instruction[31|30:21|20|19:12], LSB = 0
            3'b100:
                imm_ext = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};

            default:
                imm_ext = 32'h0000_0000;
        endcase
    end

endmodule
