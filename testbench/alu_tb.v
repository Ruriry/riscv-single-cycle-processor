`timescale 1ns/1ps

module alu_tb;

    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] alu_control;

    wire [31:0] result;
    wire zero;

    integer passed = 0;
    integer failed = 0;

    alu uut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    task run_test;
        input [31:0] test_a;
        input [31:0] test_b;
        input [2:0] control;
        input [31:0] expected_result;
        input expected_zero;

        begin
            a = test_a;
            b = test_b;
            alu_control = control;

            #10;

            if (result === expected_result &&
                zero === expected_zero) begin

                $display("PASS: A=%d B=%d CTRL=%b RESULT=%d",
                         a, b, alu_control, result);

                passed = passed + 1;

            end else begin

                $display("FAIL: A=%d B=%d CTRL=%b EXPECTED=%d GOT=%d",
                         a, b, alu_control, expected_result, result);

                failed = failed + 1;

            end
        end
    endtask

    initial begin

        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);

        // Arithmetic tests
        run_test(10, 5, 3'b000, 15, 0);
        run_test(10, 5, 3'b001, 5, 0);

        // Logical tests
        run_test(10, 5, 3'b010, 0, 1);
        run_test(10, 5, 3'b011, 15, 0);

        // Zero flag test
        run_test(5, 5, 3'b001, 0, 1);

        // Additional arithmetic tests
        run_test(100, 200, 3'b000, 300, 0);
        run_test(50, 25, 3'b001, 25, 0);

        // Boundary tests
        run_test(32'hFFFFFFFF, 1, 3'b000, 0, 1);
        run_test(0, 1, 3'b001, 32'hFFFFFFFF, 0);

        // Logical edge cases
        run_test(32'hFFFFFFFF, 0, 3'b010, 0, 1);
        run_test(32'hFFFFFFFF, 0, 3'b011, 32'hFFFFFFFF, 0);

        $display("\n==========================");
        $display("ALU VERIFICATION SUMMARY");
        $display("==========================");
        $display("PASSED: %0d", passed);
        $display("FAILED: %0d", failed);
        $display("==========================");

        if (failed == 0)
            $display("OVERALL STATUS: PASS");
        else
            $display("OVERALL STATUS: FAIL");

        $finish;

    end

endmodule