module quadrant_detector(
    input  signed [15:0] angle_in,
    output reg signed [15:0] Xi,
    output reg signed [15:0] Yi,
    output reg signed [15:0] Zi
);

    localparam signed [15:0] PI_2       = 16'sh3244;
    localparam signed [15:0] MINUS_PI_2 = -16'sh3244;
    localparam signed [15:0] PI         = 16'sh6488;  
    localparam signed [15:0] X_INIT     = 16'sh136E;
    localparam signed [15:0] Y_INIT     = 16'sh0000;

    always @(*) begin
        Xi = X_INIT;
        Yi = Y_INIT;
        Zi = angle_in;

        if (angle_in > PI_2) begin
            Zi = angle_in - PI;
            Xi = -X_INIT;
            Yi = -Y_INIT;
        end else if (angle_in < MINUS_PI_2) begin
            Zi = angle_in + PI;
            Xi = -X_INIT;
            Yi = -Y_INIT;
        end
    end

endmodule

