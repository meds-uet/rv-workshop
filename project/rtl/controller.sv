// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Umer Shahid (@umershahidengr)
// =============================================================================
// Single-Cycle RISC-V Processor - Complete Implementation
// MEDS Workshop: "Build your own RISC-V Processor in a day"
// =============================================================================

// =============================================================================
// CONTROL UNIT MODULE
// =============================================================================

module control (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic       reg_write,
    output logic       alu_src,
    output logic       mem_write,
    output logic [2:0] imm_src,
    output logic       result_src,
    output logic       branch,
    output logic       jump,
    output logic [3:0] alu_control
);

    always_comb begin
        // Default values
        reg_write   = 1'b0;
        alu_src     = 1'b0;
        mem_write   = 1'b0;
        imm_src     = 3'b000;
        result_src  = 1'b0;
        branch      = 1'b0;
        jump        = 1'b0;
        alu_control = 4'b0000;

        // 0000: ADD
        // 0001: SUB
        // 0010: AND
        // 0011: OR
        // 0100: XOR
        // 0101: SLL (Shift Left Logical)
        // 0110: SRL (Shift Right Logical)
        // 0111: SRA (Shift Right Arithmetic)
        // 1000: SLT (Set Less Than - signed)
        // 1001: SLTU (Set Less Than - unsigned)
        case (opcode)
            7'b0110011: begin // R-type (only ADD shown as example)
                reg_write = 1'b1;
                case ({funct3, funct7[5]})
                    4'b0000: alu_control = 4'b0000; // ADD
                    4'b0001: alu_control = 4'b0001; // SUB
                    4'b1110: alu_control = 4'b0010; // AND
                    4'b1100: alu_control = 4'b0011; // OR
                    4'b1000: alu_control = 4'b0100; // XOR
                    4'b0100: alu_control = 4'b1000; // SLT
                endcase
            end

            7'b0010011: begin // I Type
                reg_write = 1'b1;
                alu_src = 1'b1;
                case ({funct3})
                    4'b000: alu_control = 4'b0000; // ADDI
                    4'b111: alu_control = 4'b0010; // ANDI
                    4'b110: alu_control = 4'b0011; // ORI
                    4'b100: alu_control = 4'b0100; // XORI
                    4'b010: alu_control = 4'b1000; // SLTI
                endcase
            end

            7'b0000011: begin //Load
                    alu_control = 4'b0000;
                    reg_write = 1;
                    alu_src = 1;
                    result_src = 1;
            end

            7'b0100011: begin //Store
                    alu_control = 4'b0000;
                    mem_write = 1;
                    alu_src = 1;
                    imm_src = 3'b001;
            end

            7'b1100011: begin // B Type
                branch = 1'b1;
                imm_src = 3'b010;
                alu_control = 4'b0001;
            end

            7'b1101111: begin // Jal
                jump = 1'b1;
                reg_write = 1'b1;
                imm_src = 3'b100;
            end
            
            // TODO: Implement remaining instruction types:
            // I-type (0010011)
            // Load (0000011)
            // Store (0100011)
            // Branch (1100011)
            // JAL (1101111)

            default: begin
                // NOP or unsupported instruction
            end
        endcase
    end
endmodule
