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
// RISCV PROCESSOR MODULE (main module)
// =============================================================================
module riscv_processor (
    input  logic clk,
    input  logic reset,
    // Optional debug outputs
    output logic [31:0] pc_out,
    output logic [31:0] instruction_out
);
    
    // Internal signals
    logic [31:0] pc, pc_next, pc_plus4, pc_target;
    logic [31:0] instruction;
    logic [31:0] rd1, rd2, imm_ext;
    logic [31:0] src_a, src_b, alu_result;
    logic [31:0] read_data, result;
    logic        zero, pc_src;
    
    // Control signals
    logic        reg_write, alu_src, mem_write, result_src, branch, jump;
    logic [2:0]  imm_src;
    logic [3:0]  alu_control;
    
    // PC logic
    assign pc_plus4 = pc + 4;
    assign pc_target = pc + imm_ext;
    assign pc_next = (pc_src | jump) ? pc_target : pc_plus4;
    
    // ALU input logic
    assign src_a = rd1;
    assign src_b = alu_src ? imm_ext : rd2;
    
    // Result selection
    assign result = result_src ? read_data : alu_result;
    
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
    
    register_file register_file (
        .clk(clk),
        .we(reg_write),
        .ra1(instruction[19:15]),
        .ra2(instruction[24:20]),
        .wa(instruction[11:7]),
        .wd(result),
        .rd1(rd1),
        .rd2(rd2)
    );
    
    immgen immediate_generator (
        .instruction(instruction),
        .imm_src(imm_src),
        .imm_ext(imm_ext)
    );
    
    alu arithmetic_logic_unit (
        .a(src_a),
        .b(src_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero)
    );
    
    dmem data_memory (
        .clk(clk),
        .we(mem_write),
        .addr(alu_result),
        .wdata(rd2),
        .rdata(read_data)
    );
    
    control control_unit (
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .reg_write(reg_write),
        .imm_src(imm_src),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .result_src(result_src),
        .branch(branch),
        .jump(jump),
        .alu_control(alu_control)
    );
    
    branch_unit branch_controller (
        .rd1(rd1),
        .rd2(rd2),
        .funct3(instruction[14:12]),
        .branch(branch),
        .pc_src(pc_src)
    );
    
    
endmodule