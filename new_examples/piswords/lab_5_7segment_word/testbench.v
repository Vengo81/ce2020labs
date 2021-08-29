`include "config.vh"

module testbench;

    reg       clk;
    reg [3:0] key;

    top i_top
    (
        .clk ( clk ),
        .key ( key )
    );

    initial
    begin
        clk = 1'b0;

        forever
            # 10 clk = ! clk;
    end

    reg reset;

    always @*
        key [3] = ~ reset;

    initial
    begin
        reset <= 'bx;
        repeat (2) @ (posedge clk);
        reset <= 1;
        repeat (2) @ (posedge clk);
        reset <= 0;
    end

    initial
    begin
        #0
        $dumpvars;

        key [3:0] <= 'b0;

        @ (negedge reset);

        repeat (1000)
        begin
            @ (posedge clk);

            key [3:0] <= $random;
        end

        `ifdef MODEL_TECH  // Mentor ModelSim and Questa
            $stop;
        `else
            $finish;
        `endif
    end

endmodule