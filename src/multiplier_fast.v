// multiplier_fast.v
// 8-bit multiplier using a balanced adder-tree over partial products.
// This reduces the addition depth compared to a naive linear sum of partial products,
// giving much better timing in practice.  Functionally equivalent to a Wallace-like
// reduction for this bit-width, and easy to extend/replace with CSAs/CLAs later.

module multiplier_fast (
    input  [7:0] a,
    input  [7:0] b,
    output [15:0] product
);

    // Partial products (each shifted into a 16-bit vector)
    wire [15:0] pp0 = (b[0]) ? {8'b0, a}        : 16'b0;
    wire [15:0] pp1 = (b[1]) ? {7'b0, a, 1'b0}  : 16'b0;
    wire [15:0] pp2 = (b[2]) ? {6'b0, a, 2'b0}  : 16'b0;
    wire [15:0] pp3 = (b[3]) ? {5'b0, a, 3'b0}  : 16'b0;
    wire [15:0] pp4 = (b[4]) ? {4'b0, a, 4'b0}  : 16'b0;
    wire [15:0] pp5 = (b[5]) ? {3'b0, a, 5'b0}  : 16'b0;
    wire [15:0] pp6 = (b[6]) ? {2'b0, a, 6'b0}  : 16'b0;
    wire [15:0] pp7 = (b[7]) ? {1'b0, a, 7'b0}  : 16'b0;

    // Balanced adder tree (pairwise additions -> pairwise -> final)
    wire [15:0] s0 = pp0 + pp1;
    wire [15:0] s1 = pp2 + pp3;
    wire [15:0] s2 = pp4 + pp5;
    wire [15:0] s3 = pp6 + pp7;

    wire [15:0] t0 = s0 + s1;  // combines pp0..pp3
    wire [15:0] t1 = s2 + s3;  // combines pp4..pp7

    assign product = t0 + t1;  // final combination (balanced)
endmodule
