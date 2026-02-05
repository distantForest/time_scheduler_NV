-- Create work library
vlib work
vmap work work


-- Compile source files (adjust the paths if needed)
vcom -2008 ../irq_selector.vhd
vcom -2008 ../tick_timer.vhd
vcom -2008 ../per_counter.vhd
vcom -2008 ../period_controller.vhd
vcom -2008 ../period_controller_tb.vhd

-- Run simulation
vsim work.period_controller_tb

-- Add signals to the waveform
-- add wave -r *
do wave.do

-- Run for 1 ms (adjust as needed)
run 200 ms

-- Keep the window open
restart

