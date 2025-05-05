module fir #(
    parameter DATA_WIDTH = 32,
    parameter TAP_NUM = 16
)(
    input wire clk,
    input wire rst,

    // tap parameters write interface
    input wire tap_we,
    input wire [3:0] tap_addr,
    input wire [DATA_WIDTH-1:0] tap_data,

    // input data stream
    input wire start,
    input wire [DATA_WIDTH-1:0] x_in,

    // output
    output reg [DATA_WIDTH-1:0] y_out,
    output reg done
);

    // internal registers
    reg [DATA_WIDTH-1:0] taps [0:TAP_NUM-1];
    reg [DATA_WIDTH-1:0] x_shift [0:TAP_NUM-1];
    integer i;

    reg running;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            done <= 0;
            y_out <= 0;
            running <= 0;
            for (i = 0; i < TAP_NUM; i = i + 1) begin
                taps[i] <= 0;
                x_shift[i] <= 0;
            end
        end else begin
            done <= 0;

            if (tap_we)
                taps[tap_addr] <= tap_data;

            if (start && !running) begin
                for (i = TAP_NUM-1; i > 0; i = i - 1)
                    x_shift[i] <= x_shift[i-1];
                x_shift[0] <= x_in;

                y_out <= 0;
                for (i = 0; i < TAP_NUM; i = i + 1)
                    y_out <= y_out + x_shift[i] * taps[i];

                running <= 1;
            end else if (running) begin
                done <= 1;
                running <= 0;
            end
        end
    end

endmodule
