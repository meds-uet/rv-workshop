// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Talha Ayyaz (@talhaticx)
// =============================================================================
// Single-Cycle RISC-V Processor - Top-Level Module (Workshop Skeleton Version)
// =============================================================================

module riscv_processor (
    input  logic clk,
    input  logic reset,
    output logic [31:0] pc_out,
    output logic [31:0] instruction_out
);

    // Internal signals
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

    // ========== Instruction Decode ==========
    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];

    // ========== PC Logic ==========
    logic pc_src;
    assign pc_src = branch & zero;
    assign pc_next = jump   ? pc + imm_ext :
                     pc_src ? pc + imm_ext :
                              pc + 4;

    assign pc_out = pc;
    assign instruction_out = instruction;

    // ========== Module Instantiations ==========

    pc pc_reg (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );

    imem instruction_memory (
        .addr(pc),
        .instruction(instruction)
    );

    register_file rf (
        .clk(clk),
        .reset(reset),       // also missing!
        .we(reg_write),
        .ra1(rs1),
        .ra2(rs2),
        .wa(rd),
        .wd(result),
        .rd1(rd1),
        .rd2(rd2)
    );


    imm_gen imm_generator (
        .instruction(instruction),
        .imm_src(imm_src),
        .imm_ext(imm_ext)
    );

    controller cu (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .imm_src(imm_src),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .result_src(result_src),
        .branch(branch),
        .jump(jump),
        .alu_control(alu_control)
    );

    assign src_a = rd1;
    assign src_b = alu_src ? imm_ext : rd2;

    alu alu_core (
        .a(src_a),
        .b(src_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero)
    );

    data_mem dm (
        .clk(clk),
        .reset(reset),
        .we(mem_write),
        .addr(alu_result),
        .wdata(rd2),
        .rdata(read_data)
    );

    assign result = 
        (result_src == 2'b00) ? alu_result :
        (result_src == 2'b01) ? read_data  :
                                pc + 4;


endmodule
