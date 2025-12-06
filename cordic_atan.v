module cordic_atan(
    input  [3:0] idx,
    output reg signed [15:0] atan_val
);
    always @(*) begin
        case(idx)
            0: atan_val = 16'sh1922;
            1: atan_val = 16'sh0ED6;
            2: atan_val = 16'sh07D7;
            3: atan_val = 16'sh03FB;
            4: atan_val = 16'sh01FF;
            5: atan_val = 16'sh0100;
            6: atan_val = 16'sh0080;
            7: atan_val = 16'sh0040;
            8: atan_val = 16'sh0020;
            9: atan_val = 16'sh0010;
            10: atan_val = 16'sh0008;
            11: atan_val = 16'sh0004;
            12: atan_val = 16'sh0002;
            13: atan_val = 16'sh0001;
            default: atan_val = 0;
        endcase
    end
endmodule

