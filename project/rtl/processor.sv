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


module riscv_processor (
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] pc_out,
    output logic [31:0] instruction_out
);

    // Internal Signals 
    logic [31:0] pc, pc_next;
    logic [31:0] instruction;
    logic [31:0] rd1, rd2;
    logic [31:0] imm_ext;
    logic [31:0] src_a, src_b;
    logic [31:0] alu_result;
    logic [31:0] read_data;
    logic [31:0] result;

    logic [6:0] opcode, funct7;
    logic [2:0] funct3;
    logic [4:0] rs1, rs2, rd;

    logic        zero;
    logic [3:0]  alu_control;
    logic [2:0]  imm_src;
    logic [1:0]  result_src;
    logic        reg_write;
    logic        alu_src;
    logic        mem_write;
    logic        branch;
    logic        jump;
    logic        pc_src;

    //Instruction Decode
    always_comb begin
        opcode = instruction[6:0];
        rd     = instruction[11:7];
        funct3 = instruction[14:12];
        rs1    = instruction[19:15];
        rs2    = instruction[24:20];
        funct7 = instruction[31:25];
    end

    // PC Source Decision
    always_comb begin
        pc_src = 0;
        if (branch && zero)
            pc_src = 1;
    end

    // PC Next Calculation
    always_comb begin
        if (jump)
            pc_next = pc + imm_ext;
        else if (pc_src)
            pc_next = pc + imm_ext;
        else
            pc_next = pc + 4;
    end

    assign pc_out = pc;
    assign instruction_out = instruction;

    // Module Instantiations 

    pc pc_reg (
        .clk     (clk),
        .reset   (reset),
        .pc_next (pc_next),
        .pc      (pc)
    );

    imem instruction_memory (
        .addr       (pc),
        .instruction(instruction)
    );

    register_file rf (
        .clk   (clk),
        .reset (reset),
        .we    (reg_write),
        .ra1   (rs1),
        .ra2   (rs2),
        .wa    (rd),
        .wd    (result),
        .rd1   (rd1),
        .rd2   (rd2)
    );

    immgen imm_generator (
        .instruction(instruction),
        .imm_src    (imm_src),
        .imm_ext    (imm_ext)
    );

    control cu (
        .opcode      (opcode),
        .funct3      (funct3),
        .funct7      (funct7),
        .reg_write   (reg_write),
        .imm_src     (imm_src),
        .alu_src     (alu_src),
        .mem_write   (mem_write),
        .result_src  (result_src),
        .branch      (branch),
        .jump        (jump),
        .alu_control (alu_control)
    );

    // ALU Input Selection 
    always_comb begin
        src_a = rd1;
        if (alu_src)
            src_b = imm_ext;
        else
            src_b = rd2;
    end

    alu alu_core (
        .a           (src_a),
        .b           (src_b),
        .alu_control (alu_control),
        .result      (alu_result),
        .zero        (zero)
    );

    dmem dm (
        .clk    (clk),
        .reset  (reset),
        .we     (mem_write),
        .addr   (alu_result),
        .wdata  (rd2),
        .rdata  (read_data)
    );

    // Result Selection 
    always_comb begin
        case (result_src)
            2'b00: result = alu_result;
            2'b01: result = read_data;
            default: result = pc + 4;
        endcase
    end

endmodule