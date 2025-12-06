module cordic_stage #(
    parameter integer STAGE = 0
)(
    input signed [15:0] x_in,
    input signed [15:0] y_in,
    input signed [15:0] z_in,

    output reg signed [15:0] x_out,
    output reg signed [15:0] y_out,
    output reg signed [15:0] z_out
);

    wire signed [15:0] atan_val;
    cordic_atan rom(.idx(STAGE[3:0]), .atan_val(atan_val));

    wire signed [15:0] x_sh = x_in >>> STAGE;
    wire signed [15:0] y_sh = y_in >>> STAGE;

    always @(*) begin
        if (z_in >= 0) begin
            x_out = x_in - y_sh;
            y_out = y_in + x_sh;
            z_out = z_in - atan_val;
        end else begin
            x_out = x_in + y_sh;
            y_out = y_in - x_sh;
            z_out = z_in + atan_val;
        end
    end

endmodule

