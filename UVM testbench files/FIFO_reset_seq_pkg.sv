package FIFO_reset_seq_pkg;
	import FIFO_sequence_item_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh";

	class FIFO_reset_seq extends uvm_sequence #(FIFO_seq_item);
		`uvm_object_utils(FIFO_reset_seq)
		FIFO_seq_item seq_item;

		function new(string name = "FIFO_reset_seq");
			super.new(name);
		endfunction

		task body();
			seq_item = FIFO_seq_item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.rst_n = 0;
			seq_item.data_in = 0;
			seq_item.wr_en = 0;
			seq_item.rd_en = 0;
			finish_item(seq_item);
		endtask : body
	endclass : FIFO_reset_seq
	
endpackage : FIFO_reset_seq_pkg
