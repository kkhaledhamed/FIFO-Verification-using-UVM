package FIFO_test_pkg;
	import uvm_pkg::*;
	import FIFO_env_pkg::*;
	import FIFO_config_pkg::*;
	import FIFO_read_only_seq_pkg::*;
	import FIFO_write_read_seq_pkg::*;
	import FIFO_write_only_seq_pkg::*;
	import FIFO_reset_seq_pkg::*;
	import FIFO_write_read_empty_seq_pkg::*;
	`include "uvm_macros.svh";

	class FIFO_test extends  uvm_test;
		`uvm_component_utils(FIFO_test)

		FIFO_env FIFO_env_comp; 
		virtual FIFO_if FIFO_test_vif; 
		FIFO_config FIFO_config_obj_test;
		FIFO_read_only_seq read_seq;
		FIFO_write_read_seq write_read_seq;
		FIFO_write_only_seq write_seq;
		FIFO_reset_seq reset_seq;
		FIFO_write_read_empty_seq write_read_empty_seq;

		function new(string name = "FIFO_test", uvm_component parent = null);
			super.new(name, parent);
		endfunction 

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			FIFO_env_comp = FIFO_env::type_id::create("FIFO_env_comp", this);
			FIFO_config_obj_test = FIFO_config::type_id::create("FIFO_config_obj_test");
			read_seq = FIFO_read_only_seq::type_id::create("read_seq");
			reset_seq = FIFO_reset_seq::type_id::create("reset_seq");
			write_seq = FIFO_write_only_seq::type_id::create("write_seq");
			write_read_seq = FIFO_write_read_seq::type_id::create("write_read_seq");
			write_read_empty_seq = FIFO_write_read_empty_seq::type_id::create("write_read_empty_seq");

			if (!uvm_config_db#(virtual FIFO_if)::get(this, "", "FIFO_IF", FIFO_config_obj_test.FIFO_config_vif)) begin
				`uvm_fatal("build_phase","Test - unable to get the virtual interface");
			end
			uvm_config_db#(FIFO_config)::set(this, "*", "FIFO_CFG", FIFO_config_obj_test);
		endfunction 

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);
			
			`uvm_info("run_phase", "Reset sequence asserted", UVM_LOW)
			reset_seq.start(FIFO_env_comp.agt.sqr);

			`uvm_info("run_phase","Write operation started", UVM_LOW)
			write_seq.start(FIFO_env_comp.agt.sqr);

			`uvm_info("run_phase","Read operation started", UVM_LOW)
			read_seq.start(FIFO_env_comp.agt.sqr);

			`uvm_info("run_phase","Write & Read operations together with empty started", UVM_LOW)
			write_read_empty_seq.start(FIFO_env_comp.agt.sqr);

			`uvm_info("run_phase","Write & Read operations together started", UVM_LOW)
			write_read_seq.start(FIFO_env_comp.agt.sqr);

			phase.drop_objection(this);
		endtask : run_phase
		
	endclass : FIFO_test
	
endpackage 



