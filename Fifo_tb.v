module async_fifo_tb;
reg wclk, rclk, rst, wr_en, rd_en;
reg [15:0] in;
wire [15:0] out;
wire empty, full;
integer i;

async_fifo_simple dut(.wclk(wclk), .rclk(rclk), .rst(rst),
                      .wr_en(wr_en), .rd_en(rd_en),
                      .in(in), .out(out), .empty(empty), .full(full));

initial begin
    wclk = 0;
    forever #5 wclk = ~wclk;
end

initial begin
    rclk = 0;
    forever #7 rclk = ~rclk;   // different freq
end

task reset();
begin rst = 1; #20; rst = 0; end
endtask

task write(input [15:0] d);
begin
    @(posedge wclk);
    wr_en = 1; in = d;
    @(posedge wclk);
    wr_en = 0;
end
endtask

task read();
begin
    @(posedge rclk);
    rd_en = 1;
    @(posedge rclk);
    rd_en = 0;
end
endtask

initial begin
    wr_en = 0; rd_en = 0; in = 0;

    reset();

    repeat (8) write($random % 256);
    repeat (8) read();

    #20 $finish;
end
endmodule
