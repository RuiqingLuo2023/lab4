module user_proj_example (
    input wire wb_clk_i,
    input wire wb_rst_i,
    input wire wbs_stb_i,
    input wire wbs_cyc_i,
    input wire wbs_we_i,
    input wire [3:0] wbs_sel_i,
    input wire [31:0] wbs_adr_i,
    input wire [31:0] wbs_dat_i,
    output wire [31:0] wbs_dat_o,
    output wire wbs_ack_o,
    input wire [37:0] io_in,
    output wire [37:0] io_out,
    output wire [37:0] io_oeb,
    output wire [2:0] irq
);

    wire [31:0] mprj_output;

    assign io_out[31:0] = mprj_output;
    assign io_out[37:32] = 6'b0;
    assign io_oeb = 38'b0;
    assign irq = 3'b000;

    wb_fir_wrapper #(
        .DATA_WIDTH(32),
        .TAP_NUM(16)
    ) fir_wrapper_inst (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(wbs_stb_i),
        .wbs_cyc_i(wbs_cyc_i),
        .wbs_we_i(wbs_we_i),
        .wbs_sel_i(wbs_sel_i),
        .wbs_adr_i(wbs_adr_i),
        .wbs_dat_i(wbs_dat_i),
        .wbs_dat_o(wbs_dat_o),
        .wbs_ack_o(wbs_ack_o),
        .mprj_output(mprj_output)
    );

endmodule
