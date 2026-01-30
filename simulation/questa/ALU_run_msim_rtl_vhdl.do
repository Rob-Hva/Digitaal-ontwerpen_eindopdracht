transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/school/Digitaal ontwerpen/quartus projecten/Digitaal-ontwerpen_eindopdracht/Button_switch.vhd}

