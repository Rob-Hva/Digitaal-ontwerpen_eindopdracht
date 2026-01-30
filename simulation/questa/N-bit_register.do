-- Compile the project
vcom ../../N-bit_register.vhd

-- Compile the testbench.
vcom N-bit_register_testbench.vhd

-- Start simulation
vsim -t ns Nbit_register_testbench

-- Waves are added right here.
add wave -position insertpoint  \
-label rst_n sim:/Nbit_register_testbench/rst_n \
-label clk sim:/Nbit_register_testbench/clk \
-label D sim:/Nbit_register_testbench/D \
-label Q sim:/Nbit_register_testbench/Q

-- Run the program long enough to sumulate a button press.
-- 2^4 * 20[ns] = 320 [ns]
run 320

-- Display the values in the disired format.
radix signal sim:/Nbit_register_testbench/clk binary
radix signal sim:/Nbit_register_testbench/rst_n binary
radix signal sim:/Nbit_register_testbench/D unsigned
radix signal sim:/Nbit_register_testbench/Q unsigned