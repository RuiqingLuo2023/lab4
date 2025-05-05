module spiflash #(parameter FILENAME = "firmware.hex") (
    input wire csb,
    input wire clk,
    inout wire io0,
    inout wire io1
);

// Simulated flash memory load
initial begin
    $display("SPI Flash loading file: %s", FILENAME);
    $readmemh(FILENAME, flash_memory);
end

reg [7:0] flash_memory [0:65535];  // example 64K flash

assign io0 = 1'bz;  // not implemented
assign io1 = 1'bz;  // not implemented

endmodule
