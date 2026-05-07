## =========================================
## BASYS3 STACK UNIT XDC
## =========================================

## =========================================
## CLOCK (100 MHz)
## =========================================
set_property PACKAGE_PIN W5 [get_ports Clk]
set_property IOSTANDARD LVCMOS33 [get_ports Clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports Clk]

## =========================================
## RESET BUTTON
## =========================================
set_property PACKAGE_PIN U18 [get_ports Reset]
set_property IOSTANDARD LVCMOS33 [get_ports Reset]

## =========================================
## STACK CONTROL BUTTONS
## =========================================

## PUSH WRITE
set_property PACKAGE_PIN T18 [get_ports StackWrite]
set_property IOSTANDARD LVCMOS33 [get_ports StackWrite]

## STACK POINTER INCREMENT
set_property PACKAGE_PIN T17 [get_ports SP_inc]
set_property IOSTANDARD LVCMOS33 [get_ports SP_inc]

## STACK POINTER DECREMENT (POP)
set_property PACKAGE_PIN W19 [get_ports SP_dec]
set_property IOSTANDARD LVCMOS33 [get_ports SP_dec]

## =========================================
## DATA INPUT SWITCHES
## =========================================

set_property PACKAGE_PIN V17 [get_ports {DataIn[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataIn[0]}]

set_property PACKAGE_PIN V16 [get_ports {DataIn[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataIn[1]}]

set_property PACKAGE_PIN W16 [get_ports {DataIn[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataIn[2]}]

set_property PACKAGE_PIN W17 [get_ports {DataIn[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataIn[3]}]

## =========================================
## DATA OUTPUT LEDs
## =========================================

set_property PACKAGE_PIN U16 [get_ports {DataOut[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataOut[0]}]

set_property PACKAGE_PIN E19 [get_ports {DataOut[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataOut[1]}]

set_property PACKAGE_PIN U19 [get_ports {DataOut[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataOut[2]}]

set_property PACKAGE_PIN V19 [get_ports {DataOut[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DataOut[3]}]

## =========================================
## STATUS LEDs
## =========================================

## STACK FULL
set_property PACKAGE_PIN P1 [get_ports StackFull]
set_property IOSTANDARD LVCMOS33 [get_ports StackFull]

## STACK EMPTY
set_property PACKAGE_PIN L1 [get_ports StackEmpty]
set_property IOSTANDARD LVCMOS33 [get_ports StackEmpty]