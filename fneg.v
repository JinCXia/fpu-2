`default_nettype none

module fneg(
    input wire [31:0] x1,
    output wire [31:0] y);

    wire s1;
    assign s1 = x1[31:31];

    assign y = {~x1[31:31],x1[30:0]};

endmodule
