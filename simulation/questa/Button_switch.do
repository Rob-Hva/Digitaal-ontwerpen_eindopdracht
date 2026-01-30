-- Compile the project
vcom ../../Button_Switch.vhd

-- Compile the testbench.
vcom Button_switch_testbench.vhd

-- Start simulation
vsim -t ns Button_switch_testbench

-- Waves are added right here.
add wave -position insertpoint  \
-label clk sim:/button_switch_testbench/clk \
-label rst_n sim:/button_switch_testbench/rst_n \
-label button sim:/button_switch_testbench/button \
-label pressed sim:/button_switch_testbench/pressed \
-label switch sim:/button_switch_testbench/DUT/switch 

-- Run the program long enough to sumulate a button press.
-- (5000 + 50000 + 5000 + 50000) * 20[ns] * 10 = 22000000 [ns]
run 220000000

-- Display the values in the disired format.
radix signal sim:/button_switch_testbench/clk binary
radix signal sim:/button_switch_testbench/rst_n binary
radix signal sim:/button_switch_testbench/button binary
radix signal sim:/button_switch_testbench/pressed binary
radix signal sim:/button_switch_testbench/switch binary