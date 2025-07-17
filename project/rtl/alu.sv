// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Umer Shahid (@umershahidengr)
// =============================================================================
// Single-Cycle RISC-V Processor - Complete Implementation
// MEDS Workshop: "Build your own RISC-V Processor in a day"
// =============================================================================


module alu (
    input  logic [31:0] a, b,
    input  logic [3:0]  alu_control,
    output logic [31:0] result,
    output logic        zero
);

    always_comb begin
        // TODO: Implement ALU operations based on alu_control signal
        case (alu_control) begin // alu_control encoding:
            4'b0000: result = a + b;                    // ADD
            4'b0001: result = a - b;                    // SUB
            4'b0010: result = a & b;                    // AND
            4'b0011: result = a | b;                    //  OR
            4'b0011: result = a ^ b;                    // XOR
            4'b0101: result = a << b[4:0];              // SLL (Shift Left Logical)
            4'b0110: result = a >> b[4:0];              // (Shift Right Logical)
            4'b0111: result = $signed(a) >>> b[4:0];    // SRA (Shift Right Arithmetic)
            4'b1000: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;  // SLT (signed)
            4'b1001: result = (a < b) ? 32'd1 : 32'd0;   // SLTU (unsigned)
            default: result = 32'h0000_0000;
        endcase
        

        case (alu_control)
            4'b0000: result = a + b;              // ADD
            4'b0001: result = a - b;              // SUB
            4'b0010: result = a & b;              // AND
            // TODO: Complete rest of the ALU operations
            default: result = 32'h0000_0000;
        endcase
    end

    // TODO: Set 'zero' flag based on result
    assign zero = (result == 32'h0000_0000);

endmodule
