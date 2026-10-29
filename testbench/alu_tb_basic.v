`timescale 1ns/1ps

module alu_tb;

    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] alu_control;

    wire [31:0] result;
    wire zero;

    alu uut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    initial begin

        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);

        // ADD
        a = 10;
        b = 5;
        alu_control = 3'b000;
        #10;
        $display("ADD: %d", result);

        // SUB
        alu_control = 3'b001;
        #10;
        $display("SUB: %d", result);

        // AND
        alu_control = 3'b010;
        #10;
        $display("AND: %d", result);

        // OR
        alu_control = 3'b011;
        #10;
        $display("OR: %d", result);

        // ZERO FLAG
        a = 5;
        b = 5;
        alu_control = 3'b001;
        #10;
        $display("ZERO FLAG: %b", zero);

        $finish;

    end

endmodule
