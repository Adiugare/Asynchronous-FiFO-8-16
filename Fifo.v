module async_fifo_simple (
    input wclk, rclk, rst,
    input wr_en, rd_en,
    input [15:0] in,
    output reg [15:0] out,
    output empty, full
);

reg [15:0] mem[7:0];
reg [3:0] wptr, rptr;
integer i;

// WRITE DOMAIN
always @(posedge wclk or posedge rst) begin
    if (rst) begin
        wptr <= 0;
        for (i=0; i<8; i=i+1)
            mem[i] <= 0;
    end else if (wr_en && !full) begin
        mem[wptr[2:0]] <= in;
        wptr <= wptr + 1;
    end
end

// READ DOMAIN
always @(posedge rclk or posedge rst) begin
    if (rst) begin
        rptr <= 0;
        out  <= 0;
    end else if (rd_en && !empty) begin
        out <= mem[rptr[2:0]];
        rptr <= rptr + 1;
    end
end

assign empty = (wptr == rptr);
assign full  = (wptr[3] != rptr[3]) &&
               (wptr[2:0] == rptr[2:0]);

endmodule
