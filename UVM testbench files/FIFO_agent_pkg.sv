package FIFO_agent_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh";
	import FIFO_shared_pkg::*;
	import FIFO_driver_pkg::*;
	import FIFO_sequencer_pkg::*;
	import FIFO_config_pkg::*;
	import FIFO_monitor_pkg::*;
	import FIFO_sequence_item_pkg::*;
	
	class FIFO_agent extends uvm_agent;
		`uvm_component_utils(FIFO_agent)

		FIFO_sequencer sqr;
		FIFO_driver driver;
		FIFO_monitor monitor;
		FIFO_config cfg;
		uvm_analysis_port #(FIFO_seq_item) agt_ap;

		function new(string name = "FIFO_agent", uvm_component parent = null);
			super.new(name, parent);
		endfunction 

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);

			if (!uvm_config_db#(FIFO_config)::get(this, "", "FIFO_CFG", cfg)) begin
				`uvm_fatal("build_phase", "Test - unable get the configration of interface of the fifo");
			end
			
			driver = FIFO_driver::type_id::create("driver", this);
			sqr = FIFO_sequencer::type_id::create("sqr", this);
			monitor = FIFO_monitor::type_id::create("monitor", this);
			agt_ap = new("agt_ap", this);

		endfunction 

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			driver.seq_item_port.connect(sqr.seq_item_export);
			driver.FIFO_driver_vif = cfg.FIFO_config_vif;
			monitor.FIFO_vif = cfg.FIFO_config_vif;
			monitor.mon_ap.connect(agt_ap);
		endfunction

	endclass : FIFO_agent
endpackage : FIFO_agent_pkg