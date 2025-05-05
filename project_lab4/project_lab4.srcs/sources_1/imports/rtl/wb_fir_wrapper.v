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
    output reg wbs_ack_o,

    output reg [31:0] mprj_output   // ? ????? io_out[31:0]
);

    // FIR control signals
    reg start;
    reg [DATA_WIDTH-1:0] x_in;
    wire [DATA_WIDTH-1:0] y_out;
    wire done;

    // Tap write interface
    reg [3:0] tap_addr;
    reg [DATA_WIDTH-1:0] tap_data;
    reg tap_we;

    // Address decode constants
    localparam ADDR_CTRL  = 32'h30000000;
    localparam ADDR_TAP   = 32'h30000040;
    localparam ADDR_X     = 32'h30000080;
    localparam ADDR_Y     = 32'h30000084;
    localparam ADDR_MPRJ  = 32'h2600000C; // Write to mprj_output

    // Wishbone transaction logic
    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            wbs_ack_o <= 0;
            start <= 0;
            tap_we <= 0;
            mprj_output <= 32'd0;
        end else begin
            wbs_ack_o <= 0;
            tap_we <= 0;

            if (wbs_stb_i && wbs_cyc_i) begin
                wbs_ack_o <= 1;

                if (wbs_we_i) begin
                    case (wbs_adr_i)
                        ADDR_CTRL: start <= wbs_dat_i[0];
                        ADDR_X:    x_in  <= wbs_dat_i;
                        ADDR_MPRJ: mprj_output <= wbs_dat_i;
                        default: begin
                            if ((wbs_adr_i >= ADDR_TAP) && (wbs_adr_i < ADDR_TAP + TAP_NUM * 4)) begin
                                tap_addr <= (wbs_adr_i - ADDR_TAP) >> 2;
                                tap_data <= wbs_dat_i;
                                tap_we <= 1;
                            end
                        end
                    endcase
                end else begin
                    case (wbs_adr_i)
                        ADDR_CTRL: wbs_dat_o <= {30'd0, done, start};
                        ADDR_Y:    wbs_dat_o <= y_out;
                        default:   wbs_dat_o <= 32'd0;
                    endcase
                end
            end
        end
    end

    // FIR core connection
    fir #(
        .DATA_WIDTH(DATA_WIDTH),
        .TAP_NUM(TAP_NUM)
    ) fir_inst (
        .clk(wb_clk_i),
        .rst(wb_rst_i),
        .tap_we(tap_we),
        .tap_addr(tap_addr),
        .tap_data(tap_data),
        .start(start),
        .x_in(x_in),
        .y_out(y_out),
        .done(done)
    );

endmodule
