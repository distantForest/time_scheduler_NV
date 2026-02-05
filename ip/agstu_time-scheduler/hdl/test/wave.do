onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Tick generation}
add wave -noupdate /period_controller_tb/DUT/tick_function_1/timer_data
add wave -noupdate /period_controller_tb/DUT/tick_function_1/clk
add wave -noupdate /period_controller_tb/DUT/tick_function_1/tick
add wave -noupdate /period_controller_tb/DUT/tick_function_1/reset_timer_n
add wave -noupdate /period_controller_tb/DUT/tick_function_1/reset_n
add wave -noupdate -divider <NULL>
add wave -noupdate -divider {Period counting}
add wave -noupdate /period_controller_tb/DUT/counter_module_1/reset_n
add wave -noupdate /period_controller_tb/DUT/counter_module_1/clk
add wave -noupdate /period_controller_tb/DUT/counter_module_1/tick_front
add wave -noupdate -radix decimal -childformat {{/period_controller_tb/DUT/counter_module_1/period_counters(2) -radix decimal} {/period_controller_tb/DUT/counter_module_1/period_counters(1) -radix decimal} {/period_controller_tb/DUT/counter_module_1/period_counters(0) -radix decimal}} -expand -subitemconfig {/period_controller_tb/DUT/counter_module_1/period_counters(2) {-height 16 -radix decimal} /period_controller_tb/DUT/counter_module_1/period_counters(1) {-height 16 -radix decimal} /period_controller_tb/DUT/counter_module_1/period_counters(0) {-height 16 -radix decimal}} /period_controller_tb/DUT/counter_module_1/period_counters
add wave -noupdate -radix decimal /period_controller_tb/DUT/counter_module_1/period_length
add wave -noupdate -radix hexadecimal -childformat {{/period_controller_tb/DUT/counter_module_1/p_counter_irq(2) -radix hexadecimal} {/period_controller_tb/DUT/counter_module_1/p_counter_irq(1) -radix hexadecimal} {/period_controller_tb/DUT/counter_module_1/p_counter_irq(0) -radix hexadecimal}} -expand -subitemconfig {/period_controller_tb/DUT/counter_module_1/p_counter_irq(2) {-height 16 -radix hexadecimal} /period_controller_tb/DUT/counter_module_1/p_counter_irq(1) {-height 16 -radix hexadecimal} /period_controller_tb/DUT/counter_module_1/p_counter_irq(0) {-height 16 -radix hexadecimal}} /period_controller_tb/DUT/counter_module_1/p_counter_irq
add wave -noupdate -divider <NULL>
add wave -noupdate -divider {IRQ processing}
add wave -noupdate -radix hexadecimal -childformat {{/period_controller_tb/DUT/counter_module_1/p_counter_irq(2) -radix hexadecimal} {/period_controller_tb/DUT/counter_module_1/p_counter_irq(1) -radix hexadecimal} {/period_controller_tb/DUT/counter_module_1/p_counter_irq(0) -radix hexadecimal}} -expand -subitemconfig {/period_controller_tb/DUT/counter_module_1/p_counter_irq(2) {-color Coral -height 16 -radix hexadecimal} /period_controller_tb/DUT/counter_module_1/p_counter_irq(1) {-color {Green Yellow} -height 16 -radix hexadecimal} /period_controller_tb/DUT/counter_module_1/p_counter_irq(0) {-color {Sky Blue} -height 16 -radix hexadecimal}} /period_controller_tb/DUT/counter_module_1/p_counter_irq
add wave -noupdate -radix hexadecimal -expand -subitemconfig {/period_controller_tb/DUT/irq_selector_1/irq_in_mx(2) {-color Coral} /period_controller_tb/DUT/irq_selector_1/irq_in_mx(1) {-color {Green Yellow}} /period_controller_tb/DUT/irq_selector_1/irq_in_mx(0) {-color {Sky Blue}}} /period_controller_tb/DUT/irq_selector_1/irq_in_mx
add wave -noupdate -radix hexadecimal -expand -subitemconfig {/period_controller_tb/DUT/p_irq_ack(2) {-color Coral} /period_controller_tb/DUT/p_irq_ack(1) {-color {Green Yellow}} /period_controller_tb/DUT/p_irq_ack(0) {-color {Sky Blue}}} /period_controller_tb/DUT/p_irq_ack
add wave -noupdate -divider <NULL>
add wave -noupdate -color Red /period_controller_tb/p0_irq_out
add wave -noupdate /period_controller_tb/DUT/p_irq_ack_gl
add wave -noupdate /period_controller_tb/DUT/irq_selector_1/ack_in
add wave -noupdate /period_controller_tb/DUT/irq_selector_1/vector_out
add wave -noupdate -divider <NULL>
add wave -noupdate -divider {Interaction with ISR}
add wave -noupdate /period_controller_tb/cs_n
add wave -noupdate /period_controller_tb/write_n
add wave -noupdate /period_controller_tb/read_n
add wave -noupdate /period_controller_tb/addr
add wave -noupdate /period_controller_tb/din
add wave -noupdate /period_controller_tb/dout
add wave -noupdate /period_controller_tb/DUT/irq_selector_1/vector_out
add wave -noupdate -expand /period_controller_tb/DUT/irq_selector_1/irq_in_mx
add wave -noupdate -divider <NULL>
add wave -noupdate /period_controller_tb/reset_n
add wave -noupdate /period_controller_tb/p0_irq_out
add wave -noupdate /period_controller_tb/cs_n
add wave -noupdate /period_controller_tb/addr
add wave -noupdate /period_controller_tb/write_n
add wave -noupdate /period_controller_tb/read_n
add wave -noupdate /period_controller_tb/din
add wave -noupdate /period_controller_tb/dout
add wave -noupdate /period_controller_tb/Clk
add wave -noupdate /period_controller_tb/vector_reg_op
add wave -noupdate /period_controller_tb/bus_address
add wave -noupdate /period_controller_tb/do_read
add wave -noupdate /period_controller_tb/do_operation
add wave -noupdate /period_controller_tb/test_seq_operations
add wave -noupdate /period_controller_tb/irq_resp_operations
add wave -noupdate /period_controller_tb/func_resp_operations0
add wave -noupdate /period_controller_tb/func_resp_operations1
add wave -noupdate /period_controller_tb/func_resp_operations2
add wave -noupdate /period_controller_tb/vector
add wave -noupdate /period_controller_tb/irq_front
add wave -noupdate /period_controller_tb/function_0
add wave -noupdate /period_controller_tb/function_0r
add wave -noupdate /period_controller_tb/function_1
add wave -noupdate /period_controller_tb/function_1r
add wave -noupdate /period_controller_tb/function_2
add wave -noupdate /period_controller_tb/function_2r
add wave -noupdate /period_controller_tb/DUT/clk
add wave -noupdate /period_controller_tb/DUT/reset_n
add wave -noupdate /period_controller_tb/DUT/p0_irq_out
add wave -noupdate /period_controller_tb/DUT/cs_n
add wave -noupdate /period_controller_tb/DUT/addr
add wave -noupdate /period_controller_tb/DUT/write_n
add wave -noupdate /period_controller_tb/DUT/read_n
add wave -noupdate /period_controller_tb/DUT/din
add wave -noupdate /period_controller_tb/DUT/dout
add wave -noupdate /period_controller_tb/DUT/period_length
add wave -noupdate /period_controller_tb/DUT/period_index
add wave -noupdate /period_controller_tb/DUT/p_vector
add wave -noupdate /period_controller_tb/DUT/counter_p0
add wave -noupdate /period_controller_tb/DUT/timer_data
add wave -noupdate /period_controller_tb/DUT/tick
add wave -noupdate /period_controller_tb/DUT/tick_front
add wave -noupdate /period_controller_tb/DUT/tick_ack
add wave -noupdate /period_controller_tb/DUT/p0_counter_irq
add wave -noupdate /period_controller_tb/DUT/p0_irq
add wave -noupdate /period_controller_tb/DUT/p_counter_irq
add wave -noupdate /period_controller_tb/DUT/p_irq
add wave -noupdate -expand /period_controller_tb/DUT/p_irq_ack
add wave -noupdate /period_controller_tb/DUT/p_irq_ack_reg
add wave -noupdate /period_controller_tb/DUT/p_irq_enable_reg
add wave -noupdate /period_controller_tb/DUT/p_irq_vector_reg
add wave -noupdate /period_controller_tb/DUT/p_irq_ack_gl
add wave -noupdate /period_controller_tb/DUT/read_irq_enable_reg
add wave -noupdate /period_controller_tb/DUT/read_irq_vector_reg
add wave -noupdate /period_controller_tb/DUT/read_period_limit_reg
add wave -noupdate /period_controller_tb/DUT/write_regs
add wave -noupdate /period_controller_tb/DUT/p_counter_run
add wave -noupdate /period_controller_tb/DUT/counter_module_1/tick_front
add wave -noupdate /period_controller_tb/DUT/counter_module_1/reset_n
add wave -noupdate /period_controller_tb/DUT/counter_module_1/clk
add wave -noupdate /period_controller_tb/DUT/counter_module_1/period_length
add wave -noupdate /period_controller_tb/DUT/counter_module_1/p_counter_irq
add wave -noupdate /period_controller_tb/DUT/tick_function_1/counter_en
add wave -noupdate /period_controller_tb/DUT/tick_function_1/period_counter
add wave -noupdate /period_controller_tb/DUT/tick_function_1/period_counter_clk
add wave -noupdate /period_controller_tb/DUT/tick_function_1/period_done
add wave -noupdate /period_controller_tb/DUT/tick_function_1/tick_local
add wave -noupdate /period_controller_tb/DUT/irq_selector_1/clk
add wave -noupdate /period_controller_tb/DUT/irq_selector_1/reset_n
add wave -noupdate /period_controller_tb/DUT/irq_selector_1/irq_in_mx
add wave -noupdate /period_controller_tb/DUT/irq_selector_1/ack_in_mx
add wave -noupdate /period_controller_tb/DUT/irq_selector_1/ack_in
add wave -noupdate /period_controller_tb/DUT/irq_selector_1/p_irq_out
add wave -noupdate /period_controller_tb/DUT/irq_selector_1/vector_out
add wave -noupdate /period_controller_tb/DUT/irq_selector_1/vector
add wave -noupdate /period_controller_tb/DUT/irq_selector_1/irq_sent
add wave -noupdate /period_controller_tb/DUT/irq_selector_1/irq_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors
quietly wave cursor active 0
configure wave -namecolwidth 136
configure wave -valuecolwidth 72
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {25102878 ps}
