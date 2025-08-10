vlib work
vlog REG_MUX_pair.v DSP.v DSP_tb.v
vsim -voptargs=+acc work.DSP48A1_tb
add wave *
run -all
#quit -sim