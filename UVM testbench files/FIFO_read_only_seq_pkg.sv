package FIFO_read_only_seq_pkg;
	import FIFO_sequence_item_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh";

	class FIFO_read_only_seq extends uvm_sequence #(FIFO_seq_item);
		`uvm_object_utils(FIFO_read_only_seq)
		FIFO_seq_item seq_item;

		function new(string name = "FIFO_read_only_seq");
			super.new(name);
		endfunction

		task body();
			repeat (10_000) begin
				seq_item = FIFO_seq_item::type_id::create("seq_item");
				start_item(seq_item);
				seq_item.rst_n = 1;
				seq_item.wr_en = 0;
				seq_item.rd_en = 1;
		        seq_item.randomize(data_in);
				finish_item(seq_item);
			end
		endtask : body
	endclass : FIFO_read_only_seq
	
endpackage : FIFO_read_only_seq_pkg
