`timescale 1ns/1ps

module fir_la_tb;

reg clk;
reg RSTB;
reg power1, power2, power3, power4;
wire [37:0] mprj_io;

reg [31:0] wbs_adr_i;
reg [31:0] wbs_dat_i;
reg wbs_we_i, wbs_stb_i, wbs_cyc_i;
wire [31:0] wbs_dat_o;
wire wbs_ack_o;
wire [3:0] wbs_sel_i = 4'b1111;

// Clock generation
always #5 clk = ~clk;

initial begin
    clk = 0;
    RSTB = 0;
    power1 = 0;
    power2 = 0;
    power3 = 0;
    power4 = 0;

    #100;
    power1 = 1;
    power2 = 1;
    power3 = 1;
    power4 = 1;

    #100;
    RSTB = 1;

    $display("Starting Wishbone write...");

    #200;
    // Simulate Wishbone write to reg_mprj_datal
    wbs_we_i  = 1;
    wbs_stb_i = 1;
    wbs_cyc_i = 1;
    wbs_adr_i = 32'h2600000C;
    wbs_dat_i = 32'hA5A50000;

    #20;
    wbs_stb_i = 0;
    wbs_cyc_i = 0;
    wbs_we_i  = 0;

    #1000;
    $finish;
end

// DUT: directly instantiate user_proj_example
user_proj_example uut (
    .wb_clk_i(clk),
    .wb_rst_i(~RSTB),
    .wbs_stb_i(wbs_stb_i),
    .wbs_cyc_i(wbs_cyc_i),
    .wbs_we_i(wbs_we_i),
    .wbs_sel_i(wbs_sel_i),
    .wbs_adr_i(wbs_adr_i),
    .wbs_dat_i(wbs_dat_i),
    .wbs_dat_o(wbs_dat_o),
    .wbs_ack_o(wbs_ack_o),
    .io_in(),
    .io_out(mprj_io),
    .io_oeb(),
    .irq()
);

endmodule
