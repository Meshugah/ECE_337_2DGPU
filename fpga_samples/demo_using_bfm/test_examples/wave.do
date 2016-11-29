onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {clock and reset}
add wave -noupdate /tb/clk
add wave -noupdate /tb/reset
add wave -noupdate -divider {master bfm}
add wave -noupdate -radix hexadecimal /tb/dut/master_0/avm_address
add wave -noupdate -radix hexadecimal /tb/dut/master_0/avm_burstcount
add wave -noupdate -radix hexadecimal /tb/dut/master_0/avm_waitrequest
add wave -noupdate -radix hexadecimal /tb/dut/master_0/avm_write
add wave -noupdate -radix hexadecimal /tb/dut/master_0/avm_writedata
add wave -noupdate -radix hexadecimal /tb/dut/master_0/avm_byteenable
add wave -noupdate -radix hexadecimal /tb/dut/master_0/avm_read
add wave -noupdate -radix hexadecimal /tb/dut/master_0/avm_readdatavalid
add wave -noupdate -radix hexadecimal /tb/dut/master_0/avm_readdata
add wave -noupdate -divider {slave bfm}
add wave -noupdate -radix hexadecimal /tb/dut/slave_0/avs_address
add wave -noupdate -radix hexadecimal /tb/dut/slave_0/avs_burstcount
add wave -noupdate -radix hexadecimal /tb/dut/slave_0/avs_waitrequest
add wave -noupdate -radix hexadecimal /tb/dut/slave_0/avs_write
add wave -noupdate -radix hexadecimal /tb/dut/slave_0/avs_writedata
add wave -noupdate -radix hexadecimal /tb/dut/slave_0/avs_byteenable
add wave -noupdate -radix hexadecimal /tb/dut/slave_0/avs_read
add wave -noupdate -radix hexadecimal /tb/dut/slave_0/avs_readdatavalid
add wave -noupdate -radix hexadecimal /tb/dut/slave_0/avs_readdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14950 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 300
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 2
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
WaveRestoreZoom {0 ps} {39689 ps}
