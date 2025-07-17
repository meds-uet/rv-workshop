// Code your design here
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

        case (opcode)
            7'b0110011: begin // R-type (only ADD shown as example)
                reg_write = 1'b1;
                case ({funct3, funct7[5]})
                    4'b0000: alu_control = 4'b0000; // ADD
                    4'b0001: alu_control = 4'b0001; // SUB
                    4'b1110: alu_control = 4'b0010; // AND
                    4'b1100: alu_control = 4'b0011; // OR
                    4'b1000: alu_control = 4'b0100; // XOR
                    4'b0010: alu_control = 4'b0101; // SLL
                    4'b1010: alu_control = 4'b0110; // SRL
                    4'b1011: alu_control = 4'b0111; // SRA
                    4'b0100: alu_control = 4'b1000; // SLT
                    4'b0110: alu_control = 4'b1001; // SLTU
                    default: alu_control = 4'b0000;
                    
                endcase
            end

            7'b0010011: begin
                reg_write = 1;
                alu_src   = 1; // Immediate as ALU input
                imm_src   = 3'b000; // I-type immediate
                case (funct3)
                    3'b000: alu_control = 4'b0000;// ADDI
                    3'b111: alu_control = 4'b0010; // ANDI
                    3'b110: alu_control = 4'b0011; // ORI
                    3'b100: alu_control = 4'b0100; // XORI
                    3'b001: alu_control = 4'b0101; // SLLI
                    3'b101: alu_control = funct7[5] ? 4'b0111 : 4'b0110; // SRAI or SRLI
                    3'b010: alu_control = 4'b1000; // SLTI
                    3'b011: alu_control = 4'b1001; // SLTIU
                    default: alu_control = 4'b0000;
                endcase
            end

            7'b0000011: begin
                reg_write  = 1;
                result_src = 1;    // Select data memory output
                alu_src    = 1;    // Base + offset
                imm_src    = 3'b000; // I-type immediate
                alu_control = 4'b0000; // ADD
            end

            7'b0100011: begin
                mem_write = 1;
                alu_src   = 1; // Base + offset
                imm_src   = 3'b001; // S-type immediate
                alu_control = 4'b0000; // ADD
            end
        

            7'b1100011: begin
                branch     = 1;
                imm_src    = 3'b010; // B-type immediate
                alu_control = 4'b0001; // SUB for comparison (used in branch_unit)
            end

             7'b1101111: begin
                reg_write  = 1;
                jump       = 1;
                imm_src    = 3'b011; // J-type immediate
                alu_control = 4'b0000; // Default ADD
            end

            7'b0110111: begin
                reg_write  = 1;
                imm_src    = 3'b100; // U-type
                alu_src    = 1;
                alu_control = 4'b0000; // Just pass upper immediate
            end

            
           
            default: begin
                // NOP or unsupported instruction
            end
        endcase
    end
endmodule
