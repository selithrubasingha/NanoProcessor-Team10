## nanoprocessor_basys3.xdc
## BASYS 3 Artix-7 Constraints for the Nanoprocessor
## Vivado 2018 format
##
## PIN ASSIGNMENTS:
##   Clk    -> W5  (on-board 100 MHz clock – divide externally or use slow_clk)
##   Reset  -> T17 (BTNC – centre pushbutton, active high)
##   R7_Out -> LD3..LD0  (4-bit result on LEDs)
##   ZeroFlag -> LD14
##   Overflow -> LD15
##
## NOTE: You MUST use a clock divider module (or Vivado Clocking Wizard IP)
## to generate a ~0.5 Hz clock from the 100 MHz source and connect that
## to the Clk port of nanoprocessor so changes are visible on the LEDs.
## The constraints below bind the 100 MHz pin; if you add a clock divider
## wrapper entity, update the net name in the get_ports call accordingly.
## -----------------------------------------------------------------------
 
## nanoprocessor_basys3.xdc
## BASYS 3 Artix-7 Constraints for the Nanoprocessor

## -- Clock (100 MHz on-board oscillator)
set_property PACKAGE_PIN W5  [get_ports Clk]
set_property IOSTANDARD LVCMOS33 [get_ports Clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports Clk]

## -- Reset (BTNC centre button, active high)
set_property PACKAGE_PIN U18 [get_ports Reset]
set_property IOSTANDARD LVCMOS33 [get_ports Reset]

## -- Result output: R7(3:0) -> LD3..LD0
set_property PACKAGE_PIN U16 [get_ports {R7_Out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {R7_Out[0]}]

set_property PACKAGE_PIN E19 [get_ports {R7_Out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {R7_Out[1]}]

set_property PACKAGE_PIN U19 [get_ports {R7_Out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {R7_Out[2]}]

set_property PACKAGE_PIN V19 [get_ports {R7_Out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {R7_Out[3]}]

## -- Zero flag -> LD14
set_property PACKAGE_PIN P1 [get_ports ZeroFlag]
set_property IOSTANDARD LVCMOS33 [get_ports ZeroFlag]

## -- Overflow flag -> LD15
set_property PACKAGE_PIN L1 [get_ports Overflow]
set_property IOSTANDARD LVCMOS33 [get_ports Overflow]