// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Umer Shahid (@umershahidengr)
// =============================================================================
// Single-Cycle RISC-V Processor - Top-Level Module (Workshop Skeleton Version)
// =============================================================================
module riscv_processor (
    input  logic clk,
    input  logic reset,
    output logic [31:0] pc_out,
    output logic [31:0] instruction_out
);
    logic [31:0] pc, pc_next, instruction;
    logic [31:0] rd1, rd2, imm_ext;
    logic [31:0] src_a, src_b, alu_result, read_data, result;
    logic        zero, pc_src;

    logic        reg_write, alu_src, mem_write, branch, jump, mem_read, mem_to_reg;
    logic [2:0]  imm_src;
    logic [3:0]  alu_control;

    logic [4:0] rs1, rs2, rd;

    assign pc_out = pc;
    assign instruction_out = instruction;

    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd  = instruction[11:7];

    assign pc_next = (branch && pc_src) ? (pc + imm_ext) :
                     (jump) ? (pc + imm_ext) :
                     (pc + 4);

    assign src_a = rd1;
    assign src_b = alu_src ? imm_ext : rd2;
    assign result = mem_to_reg ? read_data : alu_result;

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
        .reset(reset),
        .we(reg_write),
        .ra1(rs1),
        .ra2(rs2),
        .wa(rd),
        .wd(result),
        .rd1(rd1),
        .rd2(rd2)
    );

    immgen imm_gen (
        .instruction(instruction),
        .imm_src(imm_src),
        .imm_ext(imm_ext)
    );

    control control_unit (
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .reg_write(reg_write),
        .imm_src(imm_src),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .mem_read(mem_read),
        .jump(jump),
        .alu_control(alu_control)
    );

    alu alu_unit (
        .a(src_a),
        .b(src_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero)
    );

    dmem data_memory (
        .clk(clk),
        .we(mem_write),
        .reset(reset),
        .addr(alu_result),
        .wdata(rd2),
        .rdata(read_data)
    );

    branch_unit branch_logic (
        .rd1(rd1),
        .rd2(rd2),
        .funct3(instruction[14:12]),
        .branch(branch),
        .pc_src(pc_src)
    );

endmodule
