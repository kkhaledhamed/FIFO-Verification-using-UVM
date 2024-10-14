vlib work
vlog -f FIFO.list +cover -covercells
vsim -voptargs=+acc work.FIFO_top -cover -sv_seed -l sim.FIFO_log
add wave /FIFO_top/FIFO_IF/*
coverage save FIFO.ucdb -onexit
run -all
#quit -sim
#vcover report FIFO.ucdb -details -annotate -all -output coverage_FIFO_rpt.txt

