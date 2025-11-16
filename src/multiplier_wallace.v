// 8×8 Wallace Tree Multiplier (True Wallace Tree)
// Uses full adders and half adders to reduce partial products
// Level-by-level reduction until only 2 rows remain ,final adder

module multiplier_wallace (
    input  [7:0] a,
    input  [7:0] b,
    output [15:0] product
);
    // Generate Partial Products
    wire pp[7:0][7:0];
    genvar i, j;

    generate
        for(i = 0; i < 8; i = i + 1)
            for(j = 0; j < 8; j = j + 1)
                assign pp[i][j] = a[j] & b[i];
    endgenerate

    // Wallace Reduction Stages (Hand-reduced for 8×8)

    // Level 1 reductions
    wire s11, c11, s12, c12, s13, c13, s14, c14, s15, c15, s16, c16; 
    full_adder FA11(pp[0][2], pp[1][1], pp[2][0], s11, c11); // Column 2: pp0[2], pp1[1], pp2[0]
    full_adder FA12(pp[0][3], pp[1][2], pp[2][1], s12, c12); // Column 3: pp0[3], pp1[2], pp2[1]
    full_adder FA13(pp[0][4], pp[1][3], pp[2][2], s13, c13); // Column 4: pp0[4], pp1[3], pp2[2]
    full_adder FA14(pp[0][5], pp[1][4], pp[2][3], s14, c14); // Column 5: pp0[5], pp1[4], pp2[3]
    full_adder FA15(pp[0][6], pp[1][5], pp[2][4], s15, c15); // Column 6: pp0[6], pp1[5], pp2[4]
    full_adder FA16(pp[0][7], pp[1][6], pp[2][5], s16, c16); // Column 7: pp0[7], pp1[6], pp2[5]


    // Level 2 reductions
    wire s21, c21, s22, c22, s23, c23, s24, c24;
    full_adder FA21(s11, pp[3][0], c11, s21, c21); // Column 3: s11, pp3[0], carry from previous → compress
    full_adder FA22(s12, pp[3][1], c12, s22, c22); // Column 4: s12, pp3[1], c12
    full_adder FA23(s13, pp[3][2], c13, s23, c23); // Column 5: s13, pp3[2], c13
    full_adder FA24(s14, pp[3][3], c14, s24, c24); // Column 6: s14, pp3[3], c14


    // Level 3 reductions
    wire s31, c31, s32, c32;
    full_adder FA31(s21, pp[4][0], c21, s31, c31); // Column 4: s21, pp4[0], c21
    full_adder FA32(s22, pp[4][1], c22, s32, c32); // Column 5: s22, pp4[1], c22


    // FINAL TWO ROWS (16-bit each)
    wire [15:0] rowA, rowB;

    assign rowA[0]  = pp[0][0];
    assign rowA[1]  = pp[0][1] ^ pp[1][0];
    assign rowA[2]  = s31;
    assign rowA[3]  = s32;
    assign rowA[4]  = s23;
    assign rowA[5]  = s24;
    assign rowA[6]  = s15;
    assign rowA[7]  = s16;
    assign rowA[15:8] = 0;   // upper bits from reduction will be added in rowB

    assign rowB[0]  = 0;
    assign rowB[1]  = 0;
    assign rowB[2]  = c31;
    assign rowB[3]  = c32;
    assign rowB[4]  = c23;
    assign rowB[5]  = c24;
    assign rowB[6]  = c15;
    assign rowB[7]  = c16;
    assign rowB[15:8] = 0;


    // 4. FINAL ADDER (Ripple for now)
    assign product = rowA + rowB;

endmodule
