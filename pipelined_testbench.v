`timescale 1ns/1ps

module pipelined_cordictest;

    reg clk;
    reg rst_n;
    reg signed [15:0] angle_in;

    wire signed [15:0] cos_out;
    wire signed [15:0] sin_out;


    integer k;
    real pi;
    real deg_angles[0:9];
    real rad_angles[0:9];
    real norm_deg;   

    
    function signed [15:0] rad_to_q;
        input real rad;
        begin
            rad_to_q = $rtoi(rad * 8192.0);
        end
    endfunction

    
    function real q_to_real;
        input signed [15:0] val;
        begin
            q_to_real = val / 8192.0;
        end
    endfunction

    
    pipelined_cordic dut (
        .clk(clk),
        .rst_n(rst_n),
        .angle_in(angle_in),
        .cos_out(cos_out),
        .sin_out(sin_out)
    );

    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end


    initial begin

        pi = 3.141592653589793;

        
        deg_angles[0] = -180;
        deg_angles[1] = -90;
        deg_angles[2] = -45;
        deg_angles[3] =   0;
        deg_angles[4] =  22.5;
        deg_angles[5] =  45;
        deg_angles[6] =  90;
        deg_angles[7] = 300;   
        deg_angles[8] = 450;   
        deg_angles[9] = -540;  

        
        for (k = 0; k < 10; k = k + 1) begin

            norm_deg = deg_angles[k];

            while (norm_deg > 180.0)  norm_deg = norm_deg - 360.0;
            while (norm_deg < -180.0) norm_deg = norm_deg + 360.0;

            rad_angles[k] = norm_deg * pi / 180.0;
        end

       
        rst_n = 0;
        angle_in = 0;
        #20 rst_n = 1;

        $display("\n==================== CORDIC LOG ===========================================\n");
        $display(" Angle(deg)   Angle(rad)     cos(real)     sin(real)     cos(hex)  sin(hex)");
        $display("-------------------------------------------------------------------------------");

        
        for (k = 0; k < 10; k = k + 1) begin

            angle_in = rad_to_q(rad_angles[k]);

            @(posedge clk);
            repeat (16) @(posedge clk);

            $display(" %8.3f   %10.6f   %12.6f   %12.6f     0x%h    0x%h",
                deg_angles[k],
                rad_angles[k],
                q_to_real(cos_out),
                q_to_real(sin_out),
                cos_out,
                sin_out
            );

        end

        $display("\n=====================================================\n");

        #20 $finish;
    end

endmodule

