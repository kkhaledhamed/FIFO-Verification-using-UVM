interface FIFO_if (input bit clk);

	// Parameters
	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
	localparam max_fifo_addr = $clog2(FIFO_DEPTH);

	// Signals (All IO ports)
	logic [FIFO_WIDTH-1:0] data_in;
	logic rst_n, wr_en, rd_en;
	logic [FIFO_WIDTH-1:0] data_out; 
	logic wr_ack, overflow, underflow;
	logic full, empty, almostfull, almostempty;

	// Modport for Design & Assertion
	modport DUT (input data_in, rst_n, wr_en, rd_en, clk,
				 output data_out, wr_ack, overflow, underflow, full, empty, almostfull, almostempty);

endinterface 


