package FIFO_sequence_item_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh";

	class FIFO_seq_item extends uvm_sequence_item;
		`uvm_object_utils(FIFO_seq_item)

		// Parameters
		localparam FIFO_WIDTH = 16;
		localparam FIFO_DEPTH = 8;
		localparam max_fifo_addr = $clog2(FIFO_DEPTH);

		// Randomized input signals
		rand logic [FIFO_WIDTH-1:0] data_in;
		rand logic clk, rst_n, wr_en, rd_en;

		// output ports
		logic [FIFO_WIDTH-1:0] data_out; 
		logic wr_ack, overflow, underflow;
		logic full, empty, almostfull, almostempty;

		/*************Added signals as integers**************/
		integer RD_EN_ON_DIST = 30;
		integer WR_EN_ON_DIST = 70;

	 	// Constructor
	 	function new(string name = "FIFO_seq_item");
			super.new(name);
		endfunction

		//  Constraint to assert reset less often
		constraint reset {
			rst_n dist {0:=5, 1:=95};
		}

		// Constraint the wr_en to be high with distribution of the value WR_EN_ON_DIST 
		constraint Write_enable {
			wr_en dist {1:/WR_EN_ON_DIST, 0:/(100-WR_EN_ON_DIST)};
		}

		// Constraint the rd_en to be high with distribution of the value RD_EN_ON_DIST 
		constraint Read_enable {
			rd_en dist {1:/RD_EN_ON_DIST, 0:/(100-RD_EN_ON_DIST)};
		}

		function string convert2string();
			return $sformatf("%s rst_n = 0b%0b, data_in = 0b%0b, wr_en = 0b%0b, rd_en = 0b%0b,
			data_out = 0b%0b, wr_ack = 0b%0b, overflow = 0b%0b, underflow = 0b%0b, full = 0b%0b,
			empty = 0b%0b, almostfull = 0b%0b, almostempty = 0b%0b",
			super.convert2string(), rst_n, data_in, wr_en, rd_en, data_out, wr_ack, overflow,
			underflow, full, empty, almostfull, almostempty);
		endfunction : convert2string 

		function string convert2string_stimulus();
			return $sformatf(" rst_n = 0b%0b, data_in = 0b%0b, wr_en = 0b%0b, rd_en = 0b%0b",
			rst_n, data_in, wr_en, rd_en, );
		endfunction : convert2string_stimulus
		
	endclass : FIFO_seq_item
endpackage : FIFO_sequence_item_pkg


