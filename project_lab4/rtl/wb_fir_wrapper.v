module wb_fir_wrapper #(
    parameter DATA_WIDTH = 32,
    parameter TAP_NUM = 16
)(
    input wire wb_clk_i,
    input wire wb_rst_i,
    input wire wbs_stb_i,
    input wire wbs_cyc_i,
    input wire wbs_we_i,
    input wire [3:0] wbs_sel_i,
    input wire [31:0] wbs_adr_i,
    input wire [31:0] wbs_dat_i,
    output reg [31:0] wbs_dat_o,
    output reg wbs_ack_o
);

    // Internal control
    reg start;
    reg [DATA_WIDTH-1:0] x_in;
    wire [DATA_WIDTH-1:0] y_out;
    wire valid, done;

    reg [DATA_WIDTH-1:0] taps [0:TAP_NUM-1];

    // Address decoding
    localparam ADDR_CTRL = 32'h00;
    localparam ADDR_LEN  = 32'h10;
    localparam ADDR_TAP  = 32'h40;
    localparam ADDR_X    = 32'h80;
    localparam ADDR_Y    = 32'h84;

    fir fir_inst (
        .clk(wb_clk_i),
        .rst(wb_rst_i),
        .start(start),
        .data_in(x_in),
        .taps(taps),
        .data_out(y_out),
        .valid(valid),
        .done(done)
    );

    integer i;

    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            wbs_ack_o <= 0;
            start <= 0;
        end else begin
            wbs_ack_o <= 0;
            if (wbs_stb_i && wbs_cyc_i) begin
                wbs_ack_o <= 1;

                if (wbs_we_i) begin
                    // Write
                    case (wbs_adr_i[7:0])
                        8'h00: start <= wbs_dat_i[0];
                        8'h80: x_in <= wbs_dat_i;
                        default:
                            if ((wbs_adr_i[7:0] >= 8'h40) && (wbs_adr_i[7:0] < 8'h40 + TAP_NUM * 4)) begin
                                i = (wbs_adr_i[7:0] - 8'h40) >> 2;
                                taps[i] <= wbs_dat_i;
                            end
                    endcase
                end else begin
                    // Read
                    case (wbs_adr_i[7:0])
                        8'h00: wbs_dat_o <= {30'd0, done, start};
                        8'h84: wbs_dat_o <= y_out;
                        default: wbs_dat_o <= 32'h0;
                    endcase
                end
            end
        end
    end

endmodule
