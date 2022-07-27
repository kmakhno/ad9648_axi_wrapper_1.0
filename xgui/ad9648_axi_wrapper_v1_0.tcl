# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "FIFO_WIDTH"

}

proc update_PARAM_VALUE.FIFO_WIDTH { PARAM_VALUE.FIFO_WIDTH } {
	# Procedure called to update FIFO_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIFO_WIDTH { PARAM_VALUE.FIFO_WIDTH } {
	# Procedure called to validate FIFO_WIDTH
	return true
}

proc update_PARAM_VALUE.RxRegWidth { PARAM_VALUE.RxRegWidth } {
	# Procedure called to update RxRegWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RxRegWidth { PARAM_VALUE.RxRegWidth } {
	# Procedure called to validate RxRegWidth
	return true
}

proc update_PARAM_VALUE.TxRegWidth { PARAM_VALUE.TxRegWidth } {
	# Procedure called to update TxRegWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TxRegWidth { PARAM_VALUE.TxRegWidth } {
	# Procedure called to validate TxRegWidth
	return true
}

proc update_PARAM_VALUE.C_S0_AXI_DATA_WIDTH { PARAM_VALUE.C_S0_AXI_DATA_WIDTH } {
	# Procedure called to update C_S0_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S0_AXI_DATA_WIDTH { PARAM_VALUE.C_S0_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S0_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S0_AXI_ADDR_WIDTH { PARAM_VALUE.C_S0_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S0_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S0_AXI_ADDR_WIDTH { PARAM_VALUE.C_S0_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S0_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S0_AXI_BASEADDR { PARAM_VALUE.C_S0_AXI_BASEADDR } {
	# Procedure called to update C_S0_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S0_AXI_BASEADDR { PARAM_VALUE.C_S0_AXI_BASEADDR } {
	# Procedure called to validate C_S0_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S0_AXI_HIGHADDR { PARAM_VALUE.C_S0_AXI_HIGHADDR } {
	# Procedure called to update C_S0_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S0_AXI_HIGHADDR { PARAM_VALUE.C_S0_AXI_HIGHADDR } {
	# Procedure called to validate C_S0_AXI_HIGHADDR
	return true
}

proc update_PARAM_VALUE.C_M0_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M0_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_M0_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M0_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M0_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_M0_AXIS_TDATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_S0_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S0_AXI_DATA_WIDTH PARAM_VALUE.C_S0_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S0_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S0_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S0_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S0_AXI_ADDR_WIDTH PARAM_VALUE.C_S0_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S0_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S0_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M0_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_M0_AXIS_TDATA_WIDTH PARAM_VALUE.C_M0_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M0_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_M0_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.TxRegWidth { MODELPARAM_VALUE.TxRegWidth PARAM_VALUE.TxRegWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TxRegWidth}] ${MODELPARAM_VALUE.TxRegWidth}
}

proc update_MODELPARAM_VALUE.RxRegWidth { MODELPARAM_VALUE.RxRegWidth PARAM_VALUE.RxRegWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RxRegWidth}] ${MODELPARAM_VALUE.RxRegWidth}
}

proc update_MODELPARAM_VALUE.FIFO_WIDTH { MODELPARAM_VALUE.FIFO_WIDTH PARAM_VALUE.FIFO_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFO_WIDTH}] ${MODELPARAM_VALUE.FIFO_WIDTH}
}

