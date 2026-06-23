`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:56:13 06/23/2026 
// Design Name: 
// Module Name:    a_fifo 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


module async_fifo_simple(
    input wclk,
    input rclk,
    input rst,
    input wr_en,
    input rd_en,
    input [15:0] din,
    output reg [15:0] dout,
    output full,
    output empty
);

reg [15:0] mem [0:7];

// Write and Read pointers
reg [3:0] wptr;
reg [3:0] rptr;

// Pointer synchronizers
reg [3:0] wptr_sync1, wptr_sync2;
reg [3:0] rptr_sync1, rptr_sync2;

//////////////////////
// Write Logic
//////////////////////

always @(posedge wclk or posedge rst)
begin
    if(rst)
        wptr <= 0;
    else if(wr_en && !full)
    begin
        mem[wptr[2:0]] <= din;
        wptr <= wptr + 1;
    end
end

//////////////////////
// Read Logic
//////////////////////

always @(posedge rclk or posedge rst)
begin
    if(rst)
    begin
        rptr <= 0;
        dout <= 0;
    end
    else if(rd_en && !empty)
    begin
        dout <= mem[rptr[2:0]];
        rptr <= rptr + 1;
    end
end

//////////////////////
// Synchronize Read Pointer
//////////////////////

always @(posedge wclk)
begin
    rptr_sync1 <= rptr;
    rptr_sync2 <= rptr_sync1;
end

//////////////////////
// Synchronize Write Pointer
//////////////////////

always @(posedge rclk)
begin
    wptr_sync1 <= wptr;
    wptr_sync2 <= wptr_sync1;
end

//////////////////////
// Status Flags
//////////////////////

assign empty = (wptr_sync2 == rptr);

assign full =
    (wptr[3] != rptr_sync2[3]) &&
    (wptr[2:0] == rptr_sync2[2:0]);

endmodule
