`default_nettype none

module FPU(
    input wire clk,
    input wire rstn,
    input wire [3:0] f_ope_data,
    input wire [31:0] f_in1_data,
    input wire [31:0] f_in2_data,
    output reg f_in_rdy,
    input wire f_in_vld,
    output reg [31:0] f_out_data,
    input wire f_out_rdy,
    output reg f_out_vld,
    output reg [2:0] f_err
    );

    logic [3:0] ope;
    logic [31:0] in1_data,in2_data;
    logic [31:0] fadd_out,fsub_out,fmul_out,fdiv_out,feq_out,flt_out,fle_out;
    logic [31:0] fsqrt_out,fneg_out,itof_out,ftoi_out;

    logic [1:0] status;

/*  status = 0 -> 準備OK、f_in_vld待ち
　　　　status = 1 -> 計算中
　　　　status = 2 -> 計算完了、f_out_rdy待ち

*/

    fadd u1(in1_data,in2_data,fadd_out);
    fsub u2(in1_data,in2_data,fsub_out);
    fmul u3(in1_data,in2_data,fmul_out);
    fdiv u4(in1_data,in2_data,fdiv_out);
    feq  u5(in1_data,in2_data,feq_out);
    flt  u6(in1_data,in2_data,flt_out);
    fle  u7(in1_data,in2_data,fle_out);
    fsqrt u8(in1_data,fsqrt_out);
    fneg  u9(in1_data,fneg_out);
    itof u10(in1_data,itof_out);
    ftoi u11(in1_data,ftoi_out);

    always @(posedge clk) begin
        if (~rstn) begin
	    f_in_rdy <= 1'b1;
	    f_err <= 2'b0;
	    status <= 2'd0;
        end else if (status == 2'd0 & f_in_rdy & f_in_vld) begin
	    f_in_rdy <= 1'b0;
	    ope <= f_ope_data;
	    in1_data <= f_in1_data;
	    in2_data <= f_in2_data;
	    status <= 2'd1;
        end else if (status == 2'd1) begin
	    case(ope)
		4'd1 : f_out_data <= fadd_out;
		4'd2 : f_out_data <= fsub_out;
		4'd3 : f_out_data <= fmul_out;
		4'd4 : f_out_data <= fdiv_out;
		4'd5 : f_out_data <= feq_out;
		4'd6 : f_out_data <= flt_out;
		4'd7 : f_out_data <= fle_out;
		4'd8 : f_out_data <= fsqrt_out;
		4'd9 : f_out_data <= fneg_out;
		4'd10: f_out_data <= itof_out;
		4'd11: f_out_data <= ftoi_out;
		default: f_err <= 2'b1;
	    endcase
	    f_out_vld <= 1'b1;
	    status <= 2'd2;
	end else if (status == 2'd2 & f_out_rdy & f_out_vld) begin
	    f_out_vld <= 1'b0;
	    status <= 2'b0;
	end 
    end


endmodule
