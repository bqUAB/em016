DE10-Nano to DLP 2000 EVM pinout
================================

The purpose of this pinout is to create a pin assignation based on the Golden
Hardware Reference Design (GHRD) provided by Terasic for the DE10-Nano, but
taking into account the DLP 2000 EVM pinout.

The main difference between this pinout and the GHRD's pinout is that some GPIO
pins are reserved for the DLP 2000 EVM. However, these pins are still available
for use inside the design, but with different naming.

The pinout relationship between the DE10-Nano and the DLP 2000 EVM can be seen
in the adapter board [schematic](/adapter-board/kicad/adapter-board-schematic.pdf)
, and in the .csv file.

## File Description

**.qsf**: quartus settings file. This file stores the pin assignments for the
Cyclone V SoC found on the DE10-Nano.

**.csv**: comma-separated values. This file stores the pinout relationship
between the DE10's GPIOs and the [DLP 2000 EVM](http://www.ti.com/tool/DLPDLCR2000EVM)
GPIOs.
