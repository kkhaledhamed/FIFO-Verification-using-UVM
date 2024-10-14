package FIFO_scoreboard_pkg;
	import FIFO_sequence_item_pkg::*;
	import uvm_pkg::*;
	import FIFO_shared_pkg::*;
	`include "uvm_macros.svh";

	class FIFO_scoreboard extends uvm_scoreboard;
		`uvm_component_utils(FIFO_scoreboard)
		// Parameters
		localparam FIFO_WIDTH = 16;
		localparam FIFO_DEPTH = 8;

		FIFO_seq_item seq_item_sb;
		uvm_analysis_export #(FIFO_seq_item) sb_export;
		uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;

		logic [FIFO_WIDTH-1:0] fifo_ref [$];
		integer fifo_count = 0;
		logic [FIFO_WIDTH-1:0] data_out_ref; 

		function new(string name = "FIFO_scoreboard", uvm_component parent = null);
			super.new(name, parent);
		endfunction 
		
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			sb_export = new("sb_export", this);
			sb_fifo = new("sb_fifo", this);
		endfunction 

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			sb_export.connect(sb_fifo.analysis_export);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				sb_fifo.get(seq_item_sb);
				reference_model(seq_item_sb);
				#2;
				if (seq_item_sb.data_out != data_out_ref) begin
					`uvm_error("run_phase", $sformatf("Comparision faild, received by DUT %s, received by TEST %s",
					seq_item_sb.convert2string_stimulus(), data_out_ref));
					error_count ++;
				end else begin
					`uvm_info("run_phase", $sformatf("Correct Transacton received, Output is: %s",
					seq_item_sb.convert2string()),UVM_HIGH);
					correct_count ++;
				end
			end
		endtask : run_phase

		function void reference_model(input FIFO_seq_item F_txn);
			if (!F_txn.rst_n) begin
				fifo_ref <= {};
				fifo_count = 0;
			end
			else begin
				if (F_txn.wr_en && fifo_count < F_txn.FIFO_DEPTH) begin
					fifo_ref.push_back(F_txn.data_in);
					fifo_count <= fifo_ref.size();
				end 

				if (F_txn.rd_en && fifo_count != 0) begin
					data_out_ref <= fifo_ref.pop_front();
					fifo_count <= fifo_ref.size();
				end 
			end
		endfunction 

		function void report_phase(uvm_phase phase);
			super.report_phase(phase);
			`uvm_info("report_phase", $sformatf("total successful operations %0d", correct_count), UVM_MEDIUM);
			`uvm_info("report_phase", $sformatf("total errors operations %0d", error_count), UVM_MEDIUM);
		endfunction 
	endclass : FIFO_scoreboard
	
endpackage : FIFO_scoreboard_pkg
