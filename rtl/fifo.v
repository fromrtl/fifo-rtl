//simple synchronous FIFO
//Author:Ritika
//Description:Parameterized FIFO for learning RTL design

module fifo (input wire clk,
	     input wire rst_n,
	     
	     input wire wr_en,//write enable
	     input wire rd_en,//read enable
	     input wire [7:0] din,

	     output reg [7:0] dout,
	     output wire full,//FIFO full flag
	     output wire empty//FIFO empty flag
	     );

	reg [7:0] mem[0:15]; //FIFO memory, 16 entries 8 bit each
	
	reg [4:0] wr_ptr;//write pointer
	reg [4:0] rd_ptr;//read pointer
	
 // -------------------------
    // Empty and Full conditions
    // -------------------------
    assign empty = (wr_ptr == rd_ptr);

    assign full  = (wr_ptr[4] != rd_ptr[4]) &&
                   (wr_ptr[3:0] == rd_ptr[3:0]);

    // -------------------------
    // Write logic
    // -------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr[3:0]] <= din;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // -------------------------
    // Read logic
    // -------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 0;
            dout   <= 0;
        end else if (rd_en && !empty) begin
            dout   <= mem[rd_ptr[3:0]];
            rd_ptr <= rd_ptr + 1;
        end
    end

endmodule

