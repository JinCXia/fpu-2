`default_nettype none

module fmul(
    input wire [31:0] x1,
    input wire [31:0] x2,
    output wire [31:0] y);

    wire s1,s2,sy;
    wire [7:0] e1,e2,ey;
    wire [22:0] m1,m2,my;
    assign s1 = x1[31:31];
    assign e1 = x1[30:23];
    assign m1 = x1[22:0];
    assign s2 = x2[31:31];
    assign e2 = x2[30:23];
    assign m2 = x2[22:0];

    assign sy = s1 ^ s2;

    // 2^23 <= {1,m1} < 2^24 だから {1,m1} * {1,m2} は47ないし48桁
    wire [47:0] mya;
    assign mya = {1'b1,m1} * {1'b1,m2};

    wire a;
    assign a = mya[47:47];
    assign my = (a) ? mya[46:24]: mya[45:23];

    wire [7:0] e1a,e2a;
    assign e1a = (e2 == 8'b0) ? 0: e1;
    assign e2a = (e1 == 8'b0) ? 0: e2; 

    wire [8:0] eya;
    assign eya = e1a + e2a + a;
    assign ey = (eya > 9'd127) ? eya - 9'd127: 0;
		
    assign y = {sy,ey,my};

endmodule
