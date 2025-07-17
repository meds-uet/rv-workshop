// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Talha Ayyaz (@talhaticx)
// =============================================================================
// Single-Cycle RISC-V Processor - Complete Implementation
// MEDS Workshop: "Build your own RISC-V Processor in a day"
// =============================================================================

// =============================================================================
// CONTROL UNIT MODULE
// =============================================================================

module controller (
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

            7'b0110011: begin // R-type 
                reg_write = 1'b1;

                case (funct3)
                    3'b000: alu_control = (funct7 == 7'b0100000) ? 4'b0001 : 4'b0000; // SUB : ADD
                    3'b001: alu_control = 4'b0101; // SLL
                    3'b010: alu_control = 4'b1000; // SLT
                    3'b011: alu_control = 4'b1001; // SLTU
                    3'b100: alu_control = 4'b0100; // XOR
                    3'b101: alu_control = (funct7 == 7'b0100000) ? 4'b0111 : 4'b0110; // SRA : SRL
                    3'b110: alu_control = 4'b0011; // OR
                    3'b111: alu_control = 4'b0010; // AND
                endcase
            end

            7'b0010011: begin // I-type
                reg_write = 1'b1;
                alu_src   = 1'b1;

                case (funct3)
                    3'b000: alu_control = 4'b0000; // ADDI
                    3'b010: alu_control = 4'b1000; // SLTI
                    3'b100: alu_control = 4'b0100; // XORI
                    3'b110: alu_control = 4'b0011; // ORI
                    3'b111: alu_control = 4'b0010; // ANDI
                endcase
            end

            7'b0000011: begin // Load
                reg_write = 1;
                alu_src = 1;
                result_src = 1;
                reg_write = 1;
            end

            7'b0100011: begin // STORE
                alu_src = 1;
                mem_write = 1;
                imm_src = 3'b001;

            end

            7'b1100011: begin // BRANCH
                branch    = 1;
                imm_src   = 3'b010;
                case (funct3)
                    3'b000: alu_control = 4'b0001; // BEQ → SUB
                    3'b001: alu_control = 4'b0001; // BNE → SUB
                    3'b100: alu_control = 4'b1000; // BLT → SLT
                    3'b101: alu_control = 4'b1000; // BGE → SLT
                endcase
            end

            // JAL
            7'b1101111: begin // JAL
                reg_write = 1;
                jump      = 1;
                imm_src   = 3'b100;
                result_src = 2; // assumes mux with 3 inputs: 0=ALU, 1=mem, 2=PC+4
            end

            default: begin
                // NOP or unsupported instruction
            end
        endcase
    end
endmodule
