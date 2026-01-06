`timescale 1ns/1ps

module fifo_tb;

    reg clk;
    reg rst_n;
    reg wr_en;
    reg rd_en;
    reg [7:0] din;

    wire [7:0] dout;
    wire full;
    wire empty;

    // DUT instantiation
    fifo dut (
        .clk   (clk),
        .rst_n (rst_n),
        .wr_en (wr_en),
        .rd_en (rd_en),
        .din   (din),
        .dout  (dout),
        .full  (full),
        .empty (empty)
    );

    // Clock: 10ns period
    always #5 clk = ~clk;

    initial begin
        // Init
        clk   = 0;
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        din   = 0;

        // Reset pulse
        #20;
        rst_n = 1;

        // Write 5 values
        repeat (5) begin
            @(posedge clk);
            wr_en = 1;
            din   = $random;
        end

        @(posedge clk);
        wr_en = 0;

        // Read 5 values
        repeat (5) begin
            @(posedge clk);
            rd_en = 1;
        end

        @(posedge clk);
        rd_en = 0;

        #50;
        $finish;
    end

    // Dump waveforms
    initial begin
        $dumpfile("fifo.vcd");
        $dumpvars(0, fifo_tb);
    end

endmodule

