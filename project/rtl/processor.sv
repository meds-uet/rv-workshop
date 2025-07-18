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

    // Internal signals
    logic [31:0] pc, pc_next, new_pc;
    logic [31:0] instruction;

    // TODO: Declare additional internal signals like:

    logic [31:0] write_data, rd1, rd2, imm_ext, src_b, alu_result, result, read_data;
    logic [2:0] imm_src;
    logic [3:0] alu_control;
    logic reg_write, alu_src, mem_write, result_src, branch, jump, pc_src, zero, jump_src;

    // PC logic

    assign new_pc = pc + 4; 
    assign alu_result = new_pc + (imm_ext << 2);
    assign jump_src = (jump) ? jump: pc_src;
    assign pc_next = (jump_src) ? alu_result: new_pc;

    // TODO: Replace with branch/jump-aware logic

    // Debug outputs
    assign pc_out = pc;
    assign instruction_out = instruction;

    // Module instantiations

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

    register_file regfile (
        .clk(clk),
        .rst(reset),
        .we(reg_write),
        .ra1(instruction[19:15]),
        .ra2(instruction[24:20]),
        .wa(instruction[11:7]),
        .wd(write_data),
        .rd1(rd1),
        .rd2(rd2)
    );

    control ctrlr(
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .imm_src(imm_src),
        .result_src(result_src),
        .branch(branch),
        .jump(jump),
        .alu_control(alu_control)
    );

    immgen imm_gen(
        .instruction(instruction),
        .imm_src(imm_src),
        .imm_ext(imm_ext)
    );

    assign src_b = (alu_src) ? imm_ext: rd2;

    alu ALU(
        .a(rd1),
        .b(src_b),
        .result(result),
        .alu_control(alu_control),
        .zero(zero)
    );

    dmem data_mem(
        .clk(clk),
        .rst(reset),
        .we(mem_write),
        .rdata(read_data),
        .addr(result),
        .wdata(rd2)
    );

    assign write_data = (result_src) ? read_data: result;

    branch_unit BranchUnit(
        .rd1(rd1),
        .rd2(rd2),
        .funct3(instruction[14:12]),
        .branch(branch),
        .pc_src(pc_src)
    );

    // TODO: Instantiate remaining modules
    // register_file
    // immgen
    // alu
    // dmem
    // control
    // branch_unit

endmodule
