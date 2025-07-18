// Copyright 2025 Maktab-e-Digital Systems Lahore.
// Licensed under the Apache License, Version 2.0, see LICENSE file for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: javeria
// =============================================================================
// RISC-V Control Unit Testbench (With Result Checking)
// =============================================================================

module tb_Controller;

    // Inputs
    logic [31:0] inst;

    // Outputs
    logic reg_wr, rd_en, wr_en, sel_A, sel_B;
    logic [1:0] wb_sel;
    logic [2:0] br_type;
    logic [3:0] alu_op;

    int total = 0, passed = 0, failed = 0;

    // Instantiate DUT
    Controller dut (
        .inst(inst),
        .reg_wr(reg_wr),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .sel_A(sel_A),
        .sel_B(sel_B),
        .wb_sel(wb_sel),
        .br_type(br_type),
        .alu_op(alu_op)
    );

    // Helper function to assemble instruction from opcode, funct3, funct7
    function [31:0] assemble_inst(input [6:0] opc, input [2:0] f3, input [6:0] f7);
        return {f7, 5'd0, f3, 5'd0, opc};
    endfunction

    // Task to run a test case
    task run_test(
        input [6:0] opc, 
        input [2:0] f3, 
        input [6:0] f7,
        input logic exp_reg_wr,
        input logic exp_rd_en,
        input logic exp_wr_en,
        input logic exp_sel_A,
        input logic exp_sel_B,
        input [1:0] exp_wb_sel,
        input [2:0] exp_br_type,
        input [3:0] exp_alu_op,
        input string desc
    );
        begin
            inst = assemble_inst(opc, f3, f7);
            #1;
            total++;
            if (reg_wr == exp_reg_wr && rd_en == exp_rd_en && wr_en == exp_wr_en &&
                sel_A == exp_sel_A && sel_B == exp_sel_B && wb_sel == exp_wb_sel &&
                br_type == exp_br_type && alu_op == exp_alu_op) begin
                passed++;
                $display("[PASS] %-25s | ALU=%b WB=%b", desc, alu_op, wb_sel);
            end else begin
                failed++;
                $display("[FAIL] %-25s", desc);
                $display("       => reg_wr=%b (exp %b), rd_en=%b (exp %b), wr_en=%b (exp %b)",
                    reg_wr, exp_reg_wr, rd_en, exp_rd_en, wr_en, exp_wr_en);
                $display("       => sel_A=%b (exp %b), sel_B=%b (exp %b), wb_sel=%b (exp %b)",
                    sel_A, exp_sel_A, sel_B, exp_sel_B, wb_sel, exp_wb_sel);
                $display("       => br_type=%b (exp %b), alu_op=%b (exp %b)",
                    br_type, exp_br_type, alu_op, exp_alu_op);
            end
        end
    endtask

    initial begin
        $display("=== Controller Unit Testbench Start ===");

        run_test(7'b0110011, 3'b000, 7'b0000000, 1, 0, 0, 1, 0, 2'b01, 3'b000, 4'b0000, "R-type ADD");
        run_test(7'b0110011, 3'b111, 7'b0000000, 1, 0, 0, 1, 0, 2'b01, 3'b000, 4'b1001, "R-type AND");
        run_test(7'b0010011, 3'b000, 7'b0000000, 1, 0, 0, 1, 1, 2'b01, 3'b000, 4'b0000, "I-type ADDI");
        run_test(7'b0000011, 3'b010, 7'b0000000, 1, 1, 0, 1, 1, 2'b10, 3'b000, 4'b0000, "Load (LW)");
        run_test(7'b0100011, 3'b010, 7'b0000000, 0, 0, 1, 1, 1, 2'b01, 3'b000, 4'b0000, "Store (SW)");
        run_test(7'b1100011, 3'b000, 7'b0000000, 0, 0, 0, 0, 1, 2'b01, 3'b001, 4'b0000, "Branch (BEQ)");
        run_test(7'b1101111, 3'b000, 7'b0000000, 1, 0, 0, 0, 1, 2'b00, 3'b111, 4'b0000, "JAL");
        run_test(7'b0110111, 3'b000, 7'b0000000, 1, 0, 0, 0, 1, 2'b01, 3'b000, 4'b1010, "LUI");
        run_test(7'b0010111, 3'b000, 7'b0000000, 1, 0, 0, 0, 1, 2'b01, 3'b000, 4'b0000, "AUIPC");

        run_test(7'b1111111, 3'b000, 7'b0000000, 0, 0, 0, 0, 0, 2'b00, 3'b000, 4'b0000, "Invalid/NOP");

        $display("=== Controller Unit Testbench Summary ===");
        $display("Total tests: %0d", total);
        $display("Passed     : %0d", passed);
        $display("Failed     : %0d", failed);
        if (failed == 0)
            $display("✅ All controller tests passed.");
        else
            $display("❌ Some controller tests failed. Review above output.");

        $finish;
    end
endmodule
