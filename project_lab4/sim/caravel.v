module caravel (
    input wire clk,
    input wire RSTB,
    input wire power1,
    input wire power2,
    input wire power3,
    input wire power4,

    inout wire [37:0] mprj_io,

    output wire flash_csb,
    output wire flash_clk,
    inout  wire flash_io0,
    inout  wire flash_io1
);

    // Dummy SPI flash pass-through
    assign flash_clk = clk;
    assign flash_csb = 1'b0;
    assign flash_io0 = 1'bz;
    assign flash_io1 = 1'bz;

    wire [37:0] io_out;
    wire [37:0] io_oeb;

    // Top module
    user_proj_example user_proj_inst (
        .wb_clk_i(clk),
        .wb_rst_i(~RSTB),  // active-low reset
        .wbs_stb_i(1'b0),
        .wbs_cyc_i(1'b0),
        .wbs_we_i(1'b0),
        .wbs_sel_i(4'b0000),
        .wbs_adr_i(32'h0),
        .wbs_dat_i(32'h0),
        .wbs_dat_o(),         // unused
        .wbs_ack_o(),         // unused
        .io_in(mprj_io),
        .io_out(io_out),
        .io_oeb(io_oeb),
        .irq()
    );

    // Connect output to mprj_io
    assign mprj_io = io_oeb == 38'b0 ? io_out : 38'bz; // optional high-Z check

endmodule
