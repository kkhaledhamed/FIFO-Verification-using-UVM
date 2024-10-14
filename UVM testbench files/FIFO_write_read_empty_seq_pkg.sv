package FIFO_write_read_empty_seq_pkg;
	import FIFO_sequence_item_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh";

	class FIFO_write_read_empty_seq extends uvm_sequence #(FIFO_seq_item);
		`uvm_object_utils(FIFO_write_read_empty_seq)
		FIFO_seq_item seq_item;

		function new(string name = "FIFO_write_read_empty_seq");
			super.new(name);
		endfunction

		task body();
			seq_item = FIFO_seq_item::type_id::create("seq_item");
			start_item(seq_item);
			// Write until FIFO is full
			for (int i = 0; i < seq_item.FIFO_DEPTH; i++) begin
				seq_item.rst_n = 1;
				seq_item.wr_en = 1;   
				seq_item.rd_en = 0;   
				seq_item.randomize(data_in);
			end

			// Read until FIFO is empty
			for (int i = 0; i < seq_item.FIFO_DEPTH; i++) begin
				seq_item.rst_n = 1;
				seq_item.wr_en = 0;   
				seq_item.rd_en = 1;   
			end
			seq_item.rst_n = 1;
			seq_item.wr_en = 1;   
			seq_item.rd_en = 1;   
			finish_item(seq_item);
		endtask : body
	endclass : FIFO_write_read_empty_seq
	
endpackage : FIFO_write_read_empty_seq_pkg
