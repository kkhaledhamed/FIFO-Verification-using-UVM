package FIFO_driver_pkg;
	import FIFO_config_pkg::*;
	import uvm_pkg::*;
	import FIFO_sequence_item_pkg::*;
	`include "uvm_macros.svh";

	class FIFO_driver extends uvm_driver #(FIFO_seq_item);
		`uvm_component_utils(FIFO_driver);
		virtual FIFO_if FIFO_driver_vif;
		FIFO_seq_item FIFO_sqr_item;

		function new(string name = "FIFO_driver", uvm_component parent = null);
			super.new(name, parent);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				FIFO_sqr_item = FIFO_seq_item::type_id::create("FIFO_sqr_item");
	            seq_item_port.get_next_item(FIFO_sqr_item);
	            FIFO_driver_vif.data_in=FIFO_sqr_item.data_in;
	            FIFO_driver_vif.rst_n=FIFO_sqr_item.rst_n; 
	            FIFO_driver_vif.wr_en=FIFO_sqr_item.wr_en;
	            FIFO_driver_vif.rd_en=FIFO_sqr_item.rd_en;
				@(negedge FIFO_driver_vif.clk);
				seq_item_port.item_done();
				`uvm_info("run_phase", FIFO_sqr_item.convert2string_stimulus(), UVM_HIGH)
			end
		endtask : run_phase
		
	endclass : FIFO_driver
endpackage : FIFO_driver_pkg

