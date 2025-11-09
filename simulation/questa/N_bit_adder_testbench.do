# Reading pref.tcl
# //  Questa Intel Starter FPGA Edition-64
# //  Version 2024.3 win64 Sep 10 2024
# //
# // Unpublished work. Copyright 2024 Siemens
# //
# // This material contains trade secrets or otherwise confidential information
# // owned by Siemens Industry Software Inc. or its affiliates (collectively,
# // "SISW"), or its licensors. Access to and use of this information is strictly
# // limited as set forth in the Customer's applicable agreements with SISW.
# //
# // This material may not be copied, distributed, or otherwise disclosed outside
# // of the Customer's facilities without the express written permission of SISW,
# // and may not be used in any way not expressly authorized by SISW.
# //
# do ALU_run_msim_rtl_vhdl.do
# if {[file exists rtl_work]} {
# 	vdel -lib rtl_work -all
# }
# vlib rtl_work
# vmap work rtl_work
# Questa Intel Starter FPGA Edition-64 vmap 2024.3 Lib Mapping Utility 2024.09 Sep 10 2024
# vmap work rtl_work 
# Copying c:/intelfpga_lite/24.1std/questa_fse/win64/../modelsim.ini to modelsim.ini
# Modifying modelsim.ini
# 

-- Compile the testbench.
vcom N_bit_adder_testbench.vhd
# Questa Intel Starter FPGA Edition-64 vcom 2024.3 Compiler 2024.09 Sep 10 2024
# Start time: 16:45:04 on Nov 09,2025
# vcom -reportprogress 300 N_bit_adder_testbench.vhd 
# -- Loading package STANDARD
# -- Loading package TEXTIO
# -- Loading package std_logic_1164
# -- Loading package NUMERIC_STD
# -- Compiling entity N_bit_adder_testbench
# -- Compiling architecture testbench of N_bit_adder_testbench
# End time: 16:45:04 on Nov 09,2025, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
#

-- Start simulation
vsim -t ns N_bit_adder_testbench
# vsim -t ns N_bit_adder_testbench 
# Start time: 16:49:05 on Nov 09,2025
# ** Note: (vsim-8009) Loading existing optimized design _opt
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.n_bit_adder_testbench(testbench)#1
# Loading work.n_bit_adder(behaviour)#1

-- Waves are added right here.
add wave -position insertpoint  \
-label a sim:/n_bit_adder_testbench/a \
-label b sim:/n_bit_adder_testbench/b \
-label op sim:/n_bit_adder_testbench/op \
-label z sim:/n_bit_adder_testbench/z \
-label z_buffer sim:/n_bit_adder_testbench/DUT/z_buffer \
-label carry_out sim:/n_bit_adder_testbench/DUT/carry_out

-- Run the program long enough to test every possible comination.
-- 2 * 10 * 2^8 *2^8 = 1310720
run 1310720

-- Display the values in decimal.
radix signal sim:/n_bit_adder_testbench/a unsigned
radix signal sim:/n_bit_adder_testbench/b unsigned
radix signal sim:/n_bit_adder_testbench/DUT/z_buffer unsigned
radix signal sim:/n_bit_adder_testbench/z dec