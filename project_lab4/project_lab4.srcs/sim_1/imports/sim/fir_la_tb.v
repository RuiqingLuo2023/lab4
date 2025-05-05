`timescale 1ns/1ps

module fir_la_tb;

reg clk;
reg RSTB;
reg power1, power2, power3, power4;
wire [37:0] mprj_io;
wire flash_csb;
wire flash_clk;
wire flash_io0;
wire flash_io1;

// Clock generator
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

    $display(">> Starting simulation...");
    #2000000;
    $display(">> Timeout.");
    $finish;
end

// UUT
caravel uut (
    .clk(clk),
    .RSTB(RSTB),
    .power1(power1),
    .power2(power2),
    .power3(power3),
    .power4(power4),
    .mprj_io(mprj_io),
    .flash_csb(flash_csb),
    .flash_clk(flash_clk),
    .flash_io0(flash_io0),
    .flash_io1(flash_io1)
);

// SPI flash
spiflash #(
    .FILENAME("fir.hex")
) spiflash_inst (
    .csb(flash_csb),
    .clk(flash_clk),
    .io0(flash_io0),
    .io1(flash_io1)
);

// Monitor
wire [15:0] checkbits = mprj_io[31:16];

always @(checkbits) begin
    $display("checkbits = %h", checkbits);
    if (checkbits == 16'hA5A5) $display(">> FIR started!");
    if (checkbits == 16'h5A5A) $display(">> FIR finished!");
end

endmodule
