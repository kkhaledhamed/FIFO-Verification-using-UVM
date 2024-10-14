package FIFO_write_read_seq_pkg;
	import FIFO_sequence_item_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh";

	class FIFO_write_read_seq extends uvm_sequence #(FIFO_seq_item);
		`uvm_object_utils(FIFO_write_read_seq)
		FIFO_seq_item seq_item;

		function new(string name = "FIFO_write_read_seq");
			super.new(name);
		endfunction

		task body();
			repeat (10_000) begin
				seq_item = FIFO_seq_item::type_id::create("seq_item");
				start_item(seq_item);
		        seq_item.randomize();
				finish_item(seq_item);
			end
		endtask : body
	endclass : FIFO_write_read_seq
	
endpackage : FIFO_write_read_seq_pkg
