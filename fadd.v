`default_nettype none

module fadd(
    input wire [31:0] x1,
    input wire [31:0] x2,
    output wire [31:0] y);

    // 絶対値がでかい方を x1a とする。
    wire a;
    wire [31:0] x1a,x2a;
    assign a = (x1[30:0] < x2[30:0]);
    assign x1a = (a) ? x2: x1;
    assign x2a = (a) ? x1: x2;

    wire s1a,s2a,sy;
    wire [7:0] e1a,e2a,ey;
    wire [22:0] m1a,m2a,my;
    assign s1a = x1a[31:31];
    assign e1a = x1a[30:23];
    assign m1a = x1a[22:0];
    assign s2a = x2a[31:31];
    assign e2a = x2a[30:23];
    assign m2a = x2a[22:0];

    wire [7:0] sm;
    assign sm = e1a - e2a;

    wire [25:0] m1b;
    assign m1b = {2'b01,m1a,1'b0};

    wire [25:0] m2b;
    assign m2b = {2'b01,m2a,1'b0} >> sm;

    wire [25:0] mya;
    assign mya = (s1a == s2a) ? m1b + m2b: m1b - m2b;

    function [7:0] SE (
	input [25:0] MYA
    );
    begin
	casex(MYA)
        26'b1xxxxxxxxxxxxxxxxxxxxxxxxx: SE = 8'd0;
        26'b01xxxxxxxxxxxxxxxxxxxxxxxx: SE = 8'd1;
	26'b001xxxxxxxxxxxxxxxxxxxxxxx: SE = 8'd2;
	26'b0001xxxxxxxxxxxxxxxxxxxxxx: SE = 8'd3;
	26'b00001xxxxxxxxxxxxxxxxxxxxx: SE = 8'd4;
        26'b000001xxxxxxxxxxxxxxxxxxxx: SE = 8'd5;
	26'b0000001xxxxxxxxxxxxxxxxxxx: SE = 8'd6;
	26'b00000001xxxxxxxxxxxxxxxxxx: SE = 8'd7;
	26'b000000001xxxxxxxxxxxxxxxxx: SE = 8'd8;
	26'b0000000001xxxxxxxxxxxxxxxx: SE = 8'd9;
	26'b00000000001xxxxxxxxxxxxxxx: SE = 8'd10;
	26'b000000000001xxxxxxxxxxxxxx: SE = 8'd11;
	26'b0000000000001xxxxxxxxxxxxx: SE = 8'd12;
	26'b00000000000001xxxxxxxxxxxx: SE = 8'd13;
	26'b000000000000001xxxxxxxxxxx: SE = 8'd14;
	26'b0000000000000001xxxxxxxxxx: SE = 8'd15;
	26'b00000000000000001xxxxxxxxx: SE = 8'd16;
	26'b000000000000000001xxxxxxxx: SE = 8'd17;
	26'b0000000000000000001xxxxxxx: SE = 8'd18;
	26'b00000000000000000001xxxxxx: SE = 8'd19;
	26'b000000000000000000001xxxxx: SE = 8'd20;
	26'b0000000000000000000001xxxx: SE = 8'd21;
	26'b00000000000000000000001xxx: SE = 8'd22;
	26'b000000000000000000000001xx: SE = 8'd23;
	26'b0000000000000000000000001x: SE = 8'd24;
        26'b00000000000000000000000001: SE = 8'd25;
        default : SE = 8'd255;

	endcase
    end
    endfunction

    wire [7:0] se;
    assign se = SE(mya);

    assign sy = s1a;

    wire [7:0] eya,eyb;
    assign eya = e1a + 1;
    assign eyb = (eya > se) ? eya - se: 0;
    assign ey = (e2a == 0) ? e1a: eyb;

    wire [25:0] myb;    
    assign myb = mya << se;
    assign my = (e2a == 0) ? m1a: myb[24:2];

    assign y = {sy,ey,my};

endmodule
