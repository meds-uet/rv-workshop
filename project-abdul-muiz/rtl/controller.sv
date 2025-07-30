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
    output logic [2:0] imm_src,
    output logic       alu_src,
    output logic       mem_write,
    output logic       result_src,
    output logic       branch,
    output logic       mem_read,
    output logic       mem_to_reg,
    output logic       jump,
    output logic [3:0] alu_control
);

    always_comb begin
        // Default values
        reg_write   = 1'b0;
        imm_src     = 3'b000;
        alu_src     = 1'b0;
        mem_write   = 1'b0;
        result_src  = 1'b0;
        branch      = 1'b0;
        jump        = 1'b0;
        alu_control = 4'b0000;
        mem_read = 1'b0;
        mem_to_reg = 1'b0;

        case (opcode)
            7'b0110011: begin // R-type (only ADD shown as example)
                reg_write = 1'b1;
                case ({funct7[5],funct3})
                    4'b0000: alu_control = 5'b0000; // ADD
                    // TODO: Implement other R-type operations
                    4'b1000: alu_control = 4'b0001; // SUB
                    4'b0111: alu_control = 4'b0010; // AND
                    4'b0110: alu_control = 4'b0011; // OR
                    4'b0100: alu_control = 4'b0100; // XOR
                    4'b0001: alu_control = 4'b0101; // SLL
                    4'b0101: alu_control = 4'b0110; // SRL
                    4'b1101: alu_control = 4'b0111; // SRA
                    4'b0010: alu_control = 4'b1000; // SLT
                    4'b0011: alu_control = 4'b1001; // SLTU
                    default: alu_control = 4'b0000; // Default to ADD
                endcase
            end

            // TODO: Implement remaining instruction types:
            // I-type (0010011)
            7'b0010011:begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                 case (funct3)
                    3'b000: alu_control = 4'b0000; // ADDI
                    // TODO: Implement other R-type operations
                    3'b111: alu_control = 4'b0010; // AND
                    3'b110: alu_control = 4'b0011; // OR
                    3'b100: alu_control = 4'b0100; // XOR
                    3'b001: alu_control = 4'b0101; // SLL
                    3'b101:begin
                        if (funct7 == 7'b0000000)
                            alu_control = 4'b0110; // SRLI
                        else if (funct7 == 7'b0100000)
                            alu_control = 4'b0111; // SRAI
                    end
                    3'b010: alu_control = 4'b1000; // SLT
                    3'b011: alu_control = 4'b1001; // SLTU
                    default: alu_control = 4'b111; // Default to ADD
                 endcase
            end
            
            // Load (0000011)
            7'b0000011:begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                mem_read = 1'b1;
                mem_to_reg = 1'b1; 
            end
            // Store (0100011)
            7'b0100011:begin
                imm_src = 3'b001;
                alu_src = 1'b1;
                mem_write = 1'b1;
            end
            // Branch (1100011)
            7'b1100011:begin
                imm_src = 3'b010;
                branch = 1'b1;
                alu_control = 4'b0001;
            end
            // JAL (1101111)
            7'b1101111:begin
                reg_write = 1'b1;
                imm_src=3'b100;
                jump = 1'b1;
            end
            // LUI (0110111)
            7'b0110111:begin
                reg_write = 1'b1;
                imm_src = 3'b011;
                alu_src = 1'b1;
            end
            
        endcase
    end
endmodule
