module pipelined_cordic(
    input clk,
    input rst_n,
    input signed [15:0] angle_in,
    output reg signed [15:0] cos_out,
    output reg signed [15:0] sin_out
);

    localparam STAGES = 14;

    wire signed [15:0] Xi0, Yi0, Zi0;
    quadrant_detector qd(
        .angle_in(angle_in),
        .Xi(Xi0),
        .Yi(Yi0),
        .Zi(Zi0)
    );

    reg signed [15:0] x_reg [0:STAGES];
    reg signed [15:0] y_reg [0:STAGES];
    reg signed [15:0] z_reg [0:STAGES];

    
    wire signed [15:0] x_s [0:STAGES-1];
    wire signed [15:0] y_s [0:STAGES-1];
    wire signed [15:0] z_s [0:STAGES-1];

    
    genvar i;
    generate
        for (i = 0; i < STAGES; i = i + 1) begin : stage_gen
            cordic_stage #(.STAGE(i)) u_stage (
                .x_in(x_reg[i]),
                .y_in(y_reg[i]),
                .z_in(z_reg[i]),
                .x_out(x_s[i]),
                .y_out(y_s[i]),
                .z_out(z_s[i])
            );
        end
    endgenerate

    integer k;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
	begin
            for (k = 0; k <= STAGES; k = k + 1) 
	    begin
                x_reg[k] <= 0;
                y_reg[k] <= 0;
                z_reg[k] <= 0;
            end
            cos_out <= 0;
            sin_out <= 0;
        end 
	else 
	begin
            x_reg[0] <= Xi0;
            y_reg[0] <= Yi0;
            z_reg[0] <= Zi0;

            for (k = 0; k < STAGES; k = k + 1) 
	    begin
                x_reg[k+1] <= x_s[k];
                y_reg[k+1] <= y_s[k];
                z_reg[k+1] <= z_s[k];
            end
            cos_out <= x_reg[STAGES];
            sin_out <= y_reg[STAGES];
        end
    end
endmodule

