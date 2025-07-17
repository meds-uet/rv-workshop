// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Navaal Noshi
// =============================================================================
// Single-Cycle RISC-V Processor - Top-Level Module (Complete Version)
// =============================================================================

module riscv_processor (
    input  logic clk,
    input  logic reset,
    output logic [31:0] pc_out,
    output logic [31:0] instruction_out
);

    logic [31:0] pc, pc_next;
    logic [31:0] instruction;
    logic [4:0] rs1, rs2, rd;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [31:0] imm_ext;
    logic [31:0] rd1, rd2;
    logic [31:0] src_a, src_b;
    logic [31:0] alu_result;
    logic [31:0] read_data;
    logic [31:0] result;

    logic zero;
    logic reg_write;
    logic alu_src;
    logic mem_write;
    logic branch;
    logic jump;
    logic [1:0] result_src;
    logic [2:0] imm_src;
    logic [3:0] alu_ctrl;
    logic pc_src;

    assign pc_next = pc_src ? alu_result : (pc + 4);
    assign pc_out = pc;
    assign instruction_out = instruction;

    pc pc_reg (
        .clk(clk), .reset(reset), .pc_next(pc_next), .pc(pc)
    );

    imem instruction_memory (
        .addr(pc), .instruction(instruction)
    );

    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];

    control control_unit (
        .opcode(instruction[6:0]),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .imm_src(imm_src),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .result_src(result_src),
        .branch(branch),
        .jump(jump),
        .alu_control(alu_ctrl)
    );

    register_file rf (
        .clk(clk), .we(reg_write),
        .ra1(rs1), .ra2(rs2), .wa(rd),
        .wd(result), .rd1(rd1), .rd2(rd2)
    );

    immgen imm_generator (
        .instruction(instruction), .imm_src(imm_src), .imm_ext(imm_ext)
    );

    assign src_a = rd1;
    assign src_b = alu_src ? imm_ext : rd2;

    alu alu_unit (
        .a(src_a), .b(src_b), .alu_control(alu_ctrl), .result(alu_result), .zero(zero)
    );

    dmem data_memory (
        .clk(clk), .we(mem_write),
        .addr(alu_result), .wdata(rd2), .rdata(read_data)
    );

    branch_unit branch_check (
        .rd1(rd1), .rd2(rd2),
        .funct3(funct3), .branch(branch), .pc_src(pc_src)
    );

    always_comb begin
        case (result_src)
            2'b00: result = alu_result;
            2'b01: result = read_data;
            2'b10: result = pc + 4;
            default: result = 32'hDEAD_BEEF;
        endcase
    end

endmodule
module alu (
    input  logic [31:0] a, b,             // ALU input operands
    input  logic [3:0]  alu_control,      // ALU operation selector
    output logic [31:0] result,           // ALU result
    output logic        zero              // Zero flag (used for branch decisions)
);

    always_comb begin
        case (alu_control)
            4'b0000: result = a + b;                          // ADD
            4'b0001: result = a - b;                          // SUB
            4'b0010: result = a & b;                          // AND
            4'b0011: result = a | b;                          // OR
            4'b0100: result = a ^ b;                          // XOR
            4'b0101: result = a << b[4:0];                    // SLL - shift left logical
            4'b0110: result = a >> b[4:0];                    // SRL - shift right logical
            4'b0111: result = $signed(a) >>> b[4:0];          // SRA - shift right arithmetic
            4'b1000: result = ($signed(a) < $signed(b)) ? 1 : 0; // SLT - signed
            4'b1001: result = (a < b) ? 1 : 0;                // SLTU - unsigned
            default: result = 32'h0000_0000;                  // Default: 0
        endcase
    end

    // Zero flag is high when result is zero
    assign zero = (result == 32'h0000_0000);

endmodule
module branch_unit (
    input  logic [31:0] rd1, rd2,
    input  logic [2:0]  funct3,
    input  logic        branch,
    output logic        pc_src
);

    logic branch_condition;

    always_comb begin
        // Implemented branch condition logic based on funct3
        // funct3:
        // 000: BEQ   (rd1 == rd2)
        // 001: BNE   (rd1 != rd2)
        // 100: BLT   (signed comparison)
        // 101: BGE   (signed comparison)
        // 110: BLTU  (unsigned comparison)
        // 111: BGEU  (unsigned comparison)
        
        case (funct3)
            3'b000: branch_condition = (rd1 == rd2);       // BEQ
            3'b001: branch_condition = (rd1 != rd2);       // BNE
            3'b100: branch_condition = ($signed(rd1) <  $signed(rd2));
            3'b101: branch_condition = ($signed(rd1) >= $signed(rd2));
            3'b110: branch_condition = (rd1 < rd2); 
            3'b111: branch_condition = (rd1 >= rd2);
            
            default: branch_condition = 1'b0;
        endcase
    end

    // Set pc_src = branch & branch_condition
    assign pc_src = branch & branch_condition;

endmodule
module dmem (
    input  logic        clk,
    input  logic        we,
    input  logic [31:0] addr,
    input  logic [31:0] wdata,
    output logic [31:0] rdata
);

    logic [31:0] mem [0:1023]; // 4KB data memory

    initial begin
        for (int i = 0; i < 1024; i++) begin
            mem[i] = 32'h00000000;
        end
    end

    // Read operation
    assign rdata = mem[addr[31:2]];

    // Hint: if (we) then write wdata to mem[addr[31:2]]
     always_ff @(posedge clk) begin
        if (we) begin
            mem[addr[31:2]] <= wdata;
        end
    end


endmodule
module immgen (
    input  logic [31:0] instruction,
    input  logic [2:0]  imm_src,
    output logic [31:0] imm_ext
);
    always_comb begin
        case (imm_src)
            // I-type
            3'b000: imm_ext = {{20{instruction[31]}}, instruction[31:20]};
            
            // S-type: imm = [31:25][11:7]
            3'b001: imm_ext = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

            // B-type: imm = [31][7][30:25][11:8][0]
            3'b010: imm_ext = {{19{instruction[31]}}, instruction[31], instruction[7],
                               instruction[30:25], instruction[11:8], 1'b0};

            // U-type: imm = [31:12] << 12
            3'b011: imm_ext = {instruction[31:12], 12'b0};

            // J-type: imm = [31][19:12][20][30:21][0]
            3'b100: imm_ext = {{11{instruction[31]}}, instruction[31], instruction[19:12],
                               instruction[20], instruction[30:21], 1'b0};

            default: imm_ext = 32'h00000000;
        endcase
    end
endmodule
module imem (
    input  logic [31:0] addr,
    output logic [31:0] instruction
);

    logic [31:0] mem [0:1023]; // 4KB instruction memory (1024 words)

    initial begin
        
        mem[0] = 32'h00500093; // ADDI x1, x0, 5       @ 0x00
        mem[1] = 32'h00600113; // ADDI x2, x0, 6       @ 0x04
        mem[2] = 32'h002081b3; // ADD x3, x1, x2       @ 0x08
        mem[3] = 32'h00000013; // NOP                  @ 0x0C
        // All uninitialized instructions default to NOP
        for (int i = 4; i < 1024; i++) begin
            mem[i] = 32'h00000013;
        end
    end

    // Word-aligned access
    assign instruction = mem[addr[31:2]];

endmodule
module pc (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] pc_next,
    output logic [31:0] pc
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'h0000_0000; // Reset to address 0
        else
            pc <= pc_next;       // Update PC with next value
    end

endmodule
module register_file (
    input  logic        clk,
    input  logic        we,
    input  logic [4:0]  ra1, ra2, wa,
    input  logic [31:0] wd,
    output logic [31:0] rd1, rd2
);

    logic [31:0] registers [0:31];

    // Initialize all registers to zero at start
    initial begin
        for (int i = 0; i < 32; i++) begin
            registers[i] = 32'h0000_0000;
        end
    end

    // Read port 1
    assign rd1 = (ra1 == 5'd0) ? 32'h0000_0000 : registers[ra1];

    // Read port 2
    assign rd2 = (ra2 == 5'd0) ? 32'h0000_0000 : registers[ra2];

    // Write logic
    always_ff @(posedge clk) begin
        if (we && (wa != 5'd0)) begin
            registers[wa] <= wd;
        end
    end

endmodule
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