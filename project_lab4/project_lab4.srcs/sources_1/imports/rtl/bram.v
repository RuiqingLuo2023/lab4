module bram #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 8,
    parameter MEM_DEPTH  = 1 << ADDR_WIDTH
)(
    input  wire                   clk,
    input  wire                   rst,
    input  wire                   en,
    input  wire [DATA_WIDTH/8-1:0] we,
    input  wire [ADDR_WIDTH-1:0]  addr,
    input  wire [DATA_WIDTH-1:0]  din,
    output reg  [DATA_WIDTH-1:0]  dout
);

    // Memory array
    reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    // Read-write logic
    always @(posedge clk) begin
        if (rst) begin
            dout <= 0;
        end else if (en) begin
            // Write operation
            if (we) begin
                if (we[0]) mem[addr][7:0]   <= din[7:0];
                if (we[1]) mem[addr][15:8]  <= din[15:8];
                if (we[2]) mem[addr][23:16] <= din[23:16];
                if (we[3]) mem[addr][31:24] <= din[31:24];
            end
            // Read operation
            dout <= mem[addr];
        end
    end

endmodule
