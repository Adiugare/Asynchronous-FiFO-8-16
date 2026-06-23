`timescale 1ns/1ps

module async_fifo_simple_tb;

reg wclk, rclk;
reg rst;
reg wr_en, rd_en;
reg [15:0] din;

wire [15:0] dout;
wire full, empty;

async_fifo_simple uut(
    .wclk(wclk),
    .rclk(rclk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .din(din),
    .dout(dout),
    .full(full),
    .empty(empty)
);

// Write Clock
always #5 wclk = ~wclk;

// Read Clock
always #8 rclk = ~rclk;

initial
begin
    wclk = 0;
    rclk = 0;
    rst = 1;
    wr_en = 0;
    rd_en = 0;
    din = 0;

    #20;
    rst = 0;

    //-------------------------
    // WRITE 8 VALUES
    //-------------------------

    @(negedge wclk) wr_en = 1; din = 10;
    @(negedge wclk) din = 20;
    @(negedge wclk) din = 30;
    @(negedge wclk) din = 40;
    @(negedge wclk) din = 50;
    @(negedge wclk) din = 60;
    @(negedge wclk) din = 70;
    @(negedge wclk) din = 80;

    @(negedge wclk)
    wr_en = 0;

    //-------------------------
    // Wait
    //-------------------------

    #50;

    //-------------------------
    // READ 8 VALUES
    //-------------------------

    @(negedge rclk) rd_en = 1;

    repeat(8)
        @(posedge rclk);

    @(negedge rclk)
    rd_en = 0;

    #50;
    $finish;
end

// Display Writes
always @(posedge wclk)
begin
    if(wr_en && !full)
        $display("Time=%0t WRITE=%0d FULL=%b EMPTY=%b",
                 $time,din,full,empty);
end

// Display Reads
always @(posedge rclk)
begin
    if(rd_en && !empty)
        $display("Time=%0t READ=%0d FULL=%b EMPTY=%b",
                 $time,dout,full,empty);
end

endmodule
