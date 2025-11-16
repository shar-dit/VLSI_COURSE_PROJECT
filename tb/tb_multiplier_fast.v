`timescale 1ns/1ps

module tb_multiplier_fast;
    reg  [7:0] a, b;
    wire [15:0] product;

    multiplier_fast DUT (.a(a), .b(b), .product(product));

    integer i, j;

    initial begin
        $dumpfile("waves/multiplier_fast.vcd");
        $dumpvars(0, tb_multiplier_fast);
        // Some directed tests
        // a = 8'd0;   b = 8'd0;    #10;
        a = 8'd1;   b = 8'd255;  #10;
        a = 8'd5;   b = 8'd10;   #10;
        a = 8'd15;  b = 8'd15;   #10;
        a = 8'd127; b = 8'd2;    #10;
        a = 8'd255; b = 8'd255;  #10;

        // Random exhaustive-ish tests (not full 65536 but many)
        for (i = 0; i < 2000; i = i + 1) begin
            a = $random % 256;
            b = $random % 256;
            #1;
            if (product !== (a * b)) begin
                $display("ERROR: a=%0d b=%0d product=%0d expected=%0d", a, b, product, a*b);
                $finish;
            end
            #4;
        end

        $display("All random checks passed.");
        $finish;
    end
endmodule
