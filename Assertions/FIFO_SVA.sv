module FIFO_SVA (FIFO_if.DUT FIFO_IF);

	// Properties, Assertions & Covers
	always_comb begin 
		if(!FIFO_IF.rst_n)
		reset_1_assertion: assert final ((!FIFO_IF.wr_ack)&&(!FIFO_IF.overflow)&&(!FIFO_IF.underflow)&&(!FIFO.wr_ptr )&&(!FIFO.rd_ptr)&&(!FIFO.count));
		reset_1_cover: cover final ((!FIFO_IF.wr_ack)&&(!FIFO_IF.overflow)&&(!FIFO_IF.underflow)&&(!FIFO.wr_ptr)&&(!FIFO.rd_ptr)&&(!FIFO.count));
	end

	always_comb begin 
		if((FIFO_IF.rst_n)&&(FIFO.count == FIFO_IF.FIFO_DEPTH))
		full_assertion: assert final (FIFO_IF.full);
		full_cover: cover (FIFO_IF.full);
	end

	always_comb begin 
		if((FIFO_IF.rst_n)&&(FIFO.count == 0))
		empty_assertion: assert final (FIFO_IF.empty);
		empty_cover: cover (FIFO_IF.empty);
	end

	always_comb begin 
		if((FIFO_IF.rst_n)&&(FIFO.count == FIFO_IF.FIFO_DEPTH-1))
		almostfull_assertion: assert final (FIFO_IF.almostfull);
		almostfull_cover: cover (FIFO_IF.almostfull);
	end
 
	always_comb begin 
		if((FIFO_IF.rst_n)&&(FIFO.count == 1))
		almostempty_assertion: assert final (FIFO_IF.almostempty);
		almostempty_cover: cover (FIFO_IF.almostempty);
	end

	property P1;
		@(posedge FIFO_IF.clk or negedge FIFO_IF.rst_n) 
		(!FIFO_IF.rst_n) |-> ((!FIFO_IF.wr_ack)&&(!FIFO_IF.overflow)&&(!FIFO_IF.underflow)&&(!FIFO.wr_ptr)&&(!FIFO.rd_ptr)&&(!FIFO.count));
	endproperty

	property P2;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		(FIFO_IF.wr_en && !FIFO_IF.full ) |=> ((FIFO_IF.wr_ack)&&((FIFO.wr_ptr==$past(FIFO.wr_ptr)+1'b1)||(FIFO.wr_ptr==0 && $past(FIFO.wr_ptr) +1'b1 == 8)));
	endproperty

	property P3;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		(FIFO_IF.full & FIFO_IF.wr_en) |=> (FIFO_IF.overflow);
	endproperty


	property P4;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		(FIFO_IF.rd_en && FIFO.count != 0) |=> ((FIFO.rd_ptr==$past(FIFO.rd_ptr)+1'b1)||(FIFO.rd_ptr==0 && $past(FIFO.rd_ptr) +1'b1 == 8));
	endproperty 

	property P5;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		(FIFO_IF.empty & FIFO_IF.rd_en) |=> (FIFO_IF.underflow);
	endproperty
	
	property P6;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		(({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b10) && !FIFO_IF.full)   |=> ((FIFO.count==$past(FIFO.count)+1'b1));
	endproperty

	property P7;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		( ({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b01) && !FIFO_IF.empty)  |=> ((FIFO.count==$past(FIFO.count)-1'b1));
	endproperty

	property P8;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		( ({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b11) && FIFO_IF.empty)  |=> ((FIFO.count==$past(FIFO.count)+1'b1));
	endproperty 

	property P9;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		( ({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b11) && FIFO_IF.full)  |=> ((FIFO.count==$past(FIFO.count)-1'b1));
	endproperty

	reset_2_assertion: assert property(P1);
	reset_2_cover: cover property(P1);

	write_assertion: assert property(P2);
	write_cover: cover property(P2);

	overflow_assertion: assert property(P3);
	overflow_cover: cover property(P3);

	read_assertion: assert property(P4);
	read_cover: cover property(P4); 

	underflow_assertion: assert property(P5);
	underflow_cover: cover property(P5);

	write_not_full_assertion: assert property(P6);
	write_not_full_cover: cover property(P6);

	read_not_empty_assertion: assert property(P7);
	read_not_empty_cover: cover property(P7);

	read_write_empty_assertion: assert property(P8);
	read_write_empty_cover: cover property(P8);

	read_write_full_assertion: assert property(P9);
	read_write_full_cover: cover property(P9); 
endmodule : FIFO_SVA